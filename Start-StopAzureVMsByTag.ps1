Param(
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [String]
  $TagName,
  
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [String]
  $TagValue,
  
  [Parameter(Mandatory = $true)]
  [Boolean]
  $Shutdown
)

# Função para registrar logs
function Log-Message {
    param (
        [string]$message,
        [string]$level = "INFO" # Nível de log: INFO, SUCCESS, ERROR, WARNING
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - ${level}: ${message}"
    
    switch ($level) {
        "INFO" { Write-Output $logEntry }
        "SUCCESS" { Write-Output $logEntry }
        "ERROR" { Write-Error $logEntry }
        "WARNING" { Write-Warning $logEntry }
    }
}

# Função para autenticação no Azure
function Authenticate-Azure {
    try {
        # Conecta-se ao Azure com Identidade Gerenciada atribuída pelo sistema
        $global:AzureContext = (Connect-AzAccount -Identity -ErrorAction Stop).context

        # Define e armazena o contexto
        Set-AzContext -SubscriptionName $global:AzureContext.Subscription -DefaultProfile $global:AzureContext
        Log-Message "Autenticação no Azure realizada com sucesso." "SUCCESS"
        
    } catch {
        $errorMessage = "Erro de identidade não configurada para executar o script: $_. 
        A conta de automação precisa de permissão na Subscription como 'Virtual Machine Contributor'."
        Log-Message $errorMessage "ERROR"
        throw $errorMessage
    }
}

# Função para gerenciar VMs
function Manage-VMs {
    param (
        [string]$TagName,
        [string]$TagValue,
        [boolean]$Shutdown
    )

    try {
        # Obtém as VMs com a Tag especificada
        $vms = Get-AzResource -TagName $TagName -TagValue $TagValue | Where-Object -FilterScript {
            $_.ResourceType -like 'Microsoft.Compute/virtualMachines' 
        }

        if ($vms.Count -eq 0) {
            throw "Nenhuma VM encontrada com a TagName '$TagName' e TagValue '$TagValue'."
        }

        # Itera sobre cada VM encontrada e executa a ação de iniciar ou parar
        foreach ($vm in $vms) {
            $vmStatus = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
            
            # Verifica se o estado de provisionamento é 'Failed'
            if ($vmStatus.Statuses[0].Code -eq 'ProvisioningState/failed') {
                Log-Message "A operação de provisionamento da VM $($vm.Name) falhou." "ERROR"
                continue
            }
            
            if ($Shutdown -eq $true) {
                if ($vmStatus.Statuses[1].Code -eq 'PowerState/deallocated') {
                    Log-Message "VM $($vm.Name) já está parada." "INFO"
                    continue
                }

                Log-Message "Parando VM $($vm.Name)" "INFO"
                try {
                    Stop-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force -ErrorAction Stop
                    Log-Message "VM $($vm.Name) parada com sucesso." "SUCCESS"
                } catch {
                    $detailedError = $_.Exception.Message
                    Log-Message "Falha ao parar a VM $($vm.Name): $detailedError" "ERROR"
                }
            } else {
                if ($vmStatus.Statuses[1].Code -eq 'PowerState/running') {
                    Log-Message "VM $($vm.Name) já está iniciada." "INFO"
                    continue
                }

                Log-Message "Iniciando VM $($vm.Name)" "INFO"
                try {
                    Start-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -ErrorAction Stop
                    Log-Message "VM $($vm.Name) iniciada com sucesso." "SUCCESS"
                } catch {
                    $detailedError = $_.Exception.Message
                    Log-Message "Falha ao iniciar a VM $($vm.Name): $detailedError" "ERROR"
                }
            }
        }

        Log-Message "Operação concluída com sucesso." "SUCCESS"
        
    } catch {
        Log-Message "Erro ao gerenciar as VMs: $_" "ERROR"
        throw $_
    }
}

# Função para limpar recursos ou contexto (se necessário)
function Cleanup {
    Log-Message "Limpeza dos recursos concluída." "INFO"
}

# Desabilita o salvamento automático do contexto do Azure
Disable-AzContextAutosave -Scope Process

# Autenticação no Azure
Authenticate-Azure

# Gestão das VMs
Manage-VMs -TagName $TagName -TagValue $TagValue -Shutdown $Shutdown

# Limpeza de recursos ou contexto
Cleanup
