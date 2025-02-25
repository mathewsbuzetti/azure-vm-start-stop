# 🚀 Azure VM Start/Stop Automation

<div align="center">

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Mathews_Buzetti-blue?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/mathewsbuzetti)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Status](https://img.shields.io/badge/Status-Production-success?style=for-the-badge)
![Documentation](https://img.shields.io/badge/Documentation-Technical-informational?style=for-the-badge)

<a href="https://github.com/mathewsbuzetti/azure-infrastructure-template/blob/main/Scripts/Script_Start_e_Stop_de_VMs.ps1">
  <img src="https://img.shields.io/badge/DOWNLOAD%20SCRIPT-5391FE?style=for-the-badge&logo=powershell&logoColor=white" alt="Download Script" style="max-width: 100%;">
</a>

</div>

<p align="center">
Automatize o ciclo de vida de suas VMs Azure com agendamento inteligente baseado em tags.
</p>

---

## 📋 Metadados
| Metadado | Descrição |
|----------|-----------|
| **Título** | Azure VM Start/Stop Automation via PowerShell Runbook |
| **Assunto** | Automação de ciclo de vida de VMs Azure |
| **Versão** | 1.0.0 |
| **Data** | 18/02/2025 |
| **Autor** | Mathews Buzetti |
| **Tags** | `azure-automation`, `powershell-runbook`, `cost-optimization`, `vm-scheduling` |

## 📋 Índice
- [Sobre o Projeto](#-sobre-o-projeto)
- [Funcionalidades](#-funcionalidades)
- [Pré-requisitos](#-pré-requisitos)
- [Como Utilizar](#-como-utilizar)
  - [Configuração do Runbook](#configuração-do-runbook)
  - [Configuração das Tags nas VMs](#configuração-de-tags-na-vm)
  - [Configuração de Alertas](#-configuração-de-alertas-para-o-startstop-de-vms)
- [Parâmetros do Script](#-parâmetros-do-script)
- [Como Funciona](#-como-funciona)
- [Logs e Monitoramento](#-logs-e-monitoramento)
- [Troubleshooting](#-troubleshooting)
- [Contribuições](#-contribuições)
- [Licença](#-licença)

## 🔍 Sobre o Projeto

<div align="center">
<img src="https://raw.githubusercontent.com/microsoft/azuredatastudio/main/extensions/resource-deployment/images/virtual-machine.svg" width="120" height="120" alt="Azure VM">
</div>

Este script PowerShell automatiza o processo de inicialização e desligamento de máquinas virtuais no Azure com base em tags. Isso permite agendar automaticamente o início e o desligamento de VMs em horários específicos, reduzindo custos e otimizando o uso de recursos na nuvem.

> **Economize até 70% nos custos** de VMs não-críticas desligando-as automaticamente em horários ociosos.

## ✨ Funcionalidades

<table>
  <tr>
    <td width="33%" align="center"><b>⏰ Automação Inteligente</b></td>
    <td width="33%" align="center"><b>🏷️ Gestão por Tags</b></td>
    <td width="33%" align="center"><b>📊 Monitoramento Completo</b></td>
  </tr>
  <tr>
    <td>Programa horários de ligar/desligar VMs sem intervenção manual</td>
    <td>Seleciona VMs específicas usando sistema de tags do Azure</td>
    <td>Sistema de logs detalhados e alertas por e-mail</td>
  </tr>
  <tr>
    <td width="33%" align="center"><b>🔐 Segurança Integrada</b></td>
    <td width="33%" align="center"><b>💰 Economia de Custos</b></td>
    <td width="33%" align="center"><b>⚙️ Fácil Configuração</b></td>
  </tr>
  <tr>
    <td>Autenticação via Identidade Gerenciada do Azure</td>
    <td>Reduz despesas com recursos quando não estão em uso</td>
    <td>Integra-se facilmente ao workflow existente no Azure</td>
  </tr>
</table>

## 📋 Pré-requisitos

<div align="center">
  <table>
    <tr>
      <td align="center" width="20%">
        <a href="https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade">
          <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/subscriptionicon.png" width="48" height="48" alt="Subscription"><br/>
          <b>Subscription</b>
        </a>
      </td>
      <td align="center" width="20%">
        <a href="https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.Automation%2FAutomationAccounts">
          <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/ARMExplorer.png" width="48" height="48" alt="Automation Account"><br/>
          <b>Automation Account</b>
        </a>
      </td>
      <td align="center" width="20%">
        <a href="https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.ManagedIdentity%2FUserAssignedIdentities">
          <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/azure-government.png" width="48" height="48" alt="Managed Identity"><br/>
          <b>Managed Identity</b>
        </a>
      </td>
      <td align="center" width="20%">
        <a href="https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.OperationalInsights%2Fworkspaces">
          <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/LogAnalyticsLog.svg" width="48" height="48" alt="Log Analytics"><br/>
          <b>Log Analytics</b>
        </a>
      </td>
      <td align="center" width="20%">
        <a href="https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.Compute%2FVirtualMachines">
          <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/vm.png" width="48" height="48" alt="Virtual Machines"><br/>
          <b>Virtual Machines</b>
        </a>
      </td>
    </tr>
  </table>
</div>

- **Azure Subscription** ativa
- **Automation Account** com privilégios de "Virtual Machine Contributor"
- **Identidade Gerenciada** configurada para o Automation Account
- **Log Analytics Workspace** (para configuração de alertas)
- **VMs Azure** que deseja gerenciar com start/stop automatizado

## 🚀 Como Utilizar

### Configuração do Runbook

<div align="center">
  <a href="https://github.com/mathewsbuzetti/azure-infrastructure-template/blob/main/Scripts/Script_Start_e_Stop_de_VMs.ps1">
    <img src="https://img.shields.io/badge/DOWNLOAD%20SCRIPT%20START%2FSTOP-5391FE?style=for-the-badge&logo=powershell&logoColor=white" alt="Download Script">
  </a>
</div>

<br>

<div align="center">
  <img src="https://i.imgur.com/o8qDNGz.png" width="650" alt="Configuração do Runbook no Azure Automation">
  <p><i>Configuração do Runbook no Azure Automation</i></p>
</div>

#### Passos para configuração:

1. No Azure Portal, acesse o **Automation Account** e depois o Runbook "START_STOP_VMs"

2. Importe o conteúdo do script baixado

3. Configure os agendamentos:

   <details>
   <summary><b>📅 Agendamento para INICIAR VMs</b></summary>
   <table>
     <tr>
       <td><img src="https://github.com/user-attachments/assets/a49a51f6-c229-4d40-b235-19f4bdae45e6" width="500"></td>
     </tr>
     <tr>
       <td>
         <ul>
           <li><b>Recorrência:</b> Dias úteis às 9h</li>
           <li><b>TagName:</b> Nome da tag identificadora</li>
           <li><b>TagValue:</b> Valor correspondente</li>
           <li><b>Shutdown:</b> <code>false</code></li>
         </ul>
       </td>
     </tr>
   </table>
   </details>

   <details>
   <summary><b>📅 Agendamento para PARAR VMs</b></summary>
   <table>
     <tr>
       <td><img src="https://github.com/user-attachments/assets/6bb4c703-8a6c-4a1a-8714-b6f5274792e9" width="500"></td>
     </tr>
     <tr>
       <td>
         <ul>
           <li><b>Recorrência:</b> Dias úteis às 19h</li>
           <li><b>TagName:</b> Nome da tag identificadora</li>
           <li><b>TagValue:</b> Valor correspondente</li>
           <li><b>Shutdown:</b> <code>true</code></li>
         </ul>
       </td>
     </tr>
   </table>
   </details>

### Configuração de Tags na VM

<div align="center">
  <img src="https://i.imgur.com/Iht8OzS.png" width="650" alt="Adicionando tags às VMs para automação">
  <p><i>Adicionando tags às VMs para automação</i></p>
</div>

1. Acesse a VM que deseja configurar o Start/Stop automático
2. Na seção "Tags", adicione uma nova tag:
   
   <div align="center">
     <table>
       <tr>
         <th>Configuração</th>
         <th>Descrição</th>
       </tr>
       <tr>
         <td><b>Nome da tag</b></td>
         <td>Deve corresponder ao <code>TagName</code> configurado no Runbook</td>
       </tr>
       <tr>
         <td><b>Valor da tag</b></td>
         <td>Deve corresponder ao <code>TagValue</code> configurado no Runbook</td>
       </tr>
     </table>
   </div>

> ⚠️ **Importante**: Apenas VMs com a tag e valor exatos configurados no Runbook serão afetadas pelo Start/Stop automático.

### 📧 Configuração de Alertas para o Start/Stop de VMs

#### 1. Configuração do Diagnostic Settings 
1. No portal Azure, acesse o **Automation Account**
2. Na seção Monitoring, clique em **Diagnostic settings**

![Diagnostic Settings](https://github.com/user-attachments/assets/9ec9d390-2e4f-471c-9904-c002f29d411c)

3. Configure as categorias:
   * Marque JobLogs, JobStreams e AuditEvent
   * Em "Destination details", ative "Send to Log Analytics workspace"
   * Selecione seu workspace

![Diagnostic Categories](https://github.com/user-attachments/assets/a3b213d1-566c-4b53-bd84-c1c02c937e4f)

#### 2. Criação do Alerta por E-mail
1. No Log Analytics workspace:
   * Acesse a seção Monitoring
   * Clique em **Alerts**
   * Clique em "New alert rule"

![Novo Alerta](https://github.com/user-attachments/assets/c0fc8eed-8a69-40e8-b4e1-585c93db8574)

2. Em "Scope":
   * Selecione o Automation Account

![Seleção Scope](https://github.com/user-attachments/assets/0a0a0a3f-d8d1-41a0-9742-fe4afa1aa2d7)

3. Em "Condition":
   * Selecione "Custom log search"

![Custom Log Search](https://github.com/user-attachments/assets/46b53ede-1edc-496f-b015-c8d77f02c546)

4. Cole a seguinte query:
```kql
// Azure Automation jobs that are failed, suspended, or stopped 
// List all the automation jobs that failed, suspended or stopped in the last 24 hours.
let jobLogs = AzureDiagnostics
    | where ResourceProvider == "MICROSOFT.AUTOMATION"
        and Category == "JobLogs"
        and (ResultType == "Failed" or ResultType == "Stopped" or ResultType == "Suspended")
    | project
        TimeGenerated,
        RunbookName_s,
        ResultType,
        _ResourceId,
        JobId_g,
        OperationName,
        Category;
let auditEvents = AzureDiagnostics
    | where ResourceProvider == "MICROSOFT.AUTOMATION"
        and Category == "AuditEvent"
        and OperationName == "Delete"
    | project
        TimeGenerated,
        RunbookName_s,
        ResultType,
        _ResourceId,
        JobId_g,
        OperationName,
        Category;
jobLogs
| union auditEvents
| order by TimeGenerated desc
```

![query](https://github.com/user-attachments/assets/287872f9-060e-4fa1-beb5-feee15c1bd81)

5. Configure a Measurement e Alert Logic:

![Configuração Measurement e Alert Logic](https://github.com/user-attachments/assets/f1f3d5af-cc85-4fdc-90f2-d80d7aeaf52b)

#### 3. Configuração do Action Group
1. Clique em "Create action group"

![Criar Action Group](https://github.com/user-attachments/assets/32c6bddb-58dc-4a59-809a-6919a8e68c50)

2. Configure os detalhes básicos:
   * Action group name: "JobErrorsGrp001"
   * Display name: "JobErrorsGrp"
   * Resource group: RG de Automation

![Configurar Email](https://github.com/user-attachments/assets/3aa89cfa-4bfb-4944-9cb3-0d506cab5269)

3. Configure as notificações:
   * Tipo: Email/SMS message/Push/Voice
   * Adicione o email desejado

![Configurar Email](https://github.com/user-attachments/assets/bd54df3c-8430-44b4-a069-886f4c1cd27b)

4. Revise as configurações do Action Group

![Review Action Group](https://github.com/user-attachments/assets/323b8638-7602-4df4-96f7-28dc44de3ef7)

5. Selecione o Action Group criado

![Select Action Group](https://github.com/user-attachments/assets/7a321391-d45d-4418-ae0b-2b2416cd199c)

#### 4. Finalização do Alerta
1. Configure os detalhes do alerta:
   * Severity: 1 - Error
   * Alert rule name: "RunbookFailureAlert"
   * Region: East US

![Alert Details](https://github.com/user-attachments/assets/69c197f6-1a33-47f4-9347-a0473cb7efad)

3. Revise todas as configurações

![Review Alert](https://github.com/user-attachments/assets/3c3c2305-d274-447d-a50e-e163d83c5ebf)
   
> [!NOTE]
> - Após configuração, você receberá emails em caso de falhas no Start/Stop das VMs
> - Monitore o Log Analytics workspace periodicamente
> - Mantenha o email de notificação sempre atualizado

## 🔧 Parâmetros do Script

<div align="center">
  <table>
    <tr>
      <th width="20%">Parâmetro</th>
      <th width="45%">Descrição</th>
      <th width="15%">Obrigatório</th>
      <th width="20%">Tipo</th>
    </tr>
    <tr>
      <td align="center"><code>TagName</code></td>
      <td>Nome da tag usada para identificar as VMs que devem ser gerenciadas</td>
      <td align="center">✅ Sim</td>
      <td align="center">String</td>
    </tr>
    <tr>
      <td align="center"><code>TagValue</code></td>
      <td>Valor específico da tag que as VMs devem ter para serem incluídas</td>
      <td align="center">✅ Sim</td>
      <td align="center">String</td>
    </tr>
    <tr>
      <td align="center"><code>Shutdown</code></td>
      <td>Define a ação a ser executada:<br><code>true</code> = desligar VMs<br><code>false</code> = iniciar VMs</td>
      <td align="center">✅ Sim</td>
      <td align="center">Boolean</td>
    </tr>
  </table>
</div>

> 💡 **Dica**: Use diferentes combinações de tags para criar grupos distintos de VMs com agendamentos específicos.

## ⚙️ Como Funciona

<div align="center">
  <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true" width="0" height="0" alt="" style="display:none">
  
  ```mermaid
  graph TD
    A[Runbook Agendado] --> B{Authenticate-Azure}
    B -->|Sucesso| C[Manage-VMs]
    B -->|Falha| Z[Log Erro]
    
    C --> D[Busca VMs por Tag]
    D --> E{VMs Encontradas?}
    
    E -->|Sim| F[Para cada VM]
    E -->|Não| Y[Log: Nenhuma VM]
    
    F --> G{Verificar Status}
    
    G -->|VM com Erro| X[Log Erro VM]
    
    G -->|VM OK| H{Parâmetro Shutdown?}
    
    H -->|True| I{VM já Parada?}
    H -->|False| M{VM já Iniciada?}
    
    I -->|Sim| J[Log: VM já Parada]
    I -->|Não| K[Stop-AzVM]
    
    M -->|Sim| N[Log: VM já Iniciada]
    M -->|Não| O[Start-AzVM]
    
    K --> L[Log Resultado]
    O --> P[Log Resultado]
    
    L --> F
    P --> F
    J --> F
    N --> F
    X --> F
  ```
</div>

### Principais Componentes:

<div class="grid-container" style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px;">
  <div class="grid-item">
    <h4>🔐 Authenticate-Azure</h4>
    <ul>
      <li>Autentica no Azure usando Identidade Gerenciada</li>
      <li>Configura o contexto da subscription</li>
      <li>Garante segurança sem credenciais hardcoded</li>
    </ul>
  </div>
  
  <div class="grid-item">
    <h4>⚡ Manage-VMs</h4>
    <ul>
      <li>Filtra VMs com as tags específicas</li>
      <li>Verifica estado atual para evitar operações desnecessárias</li>
      <li>Gerencia inicialização/desligamento com tratamento de erros</li>
    </ul>
  </div>
  
  <div class="grid-item">
    <h4>📝 Log-Message</h4>
    <ul>
      <li>Registra operações com timestamp preciso</li>
      <li>Categoriza por níveis: INFO, SUCCESS, ERROR, WARNING</li>
      <li>Facilita diagnóstico e auditoria das operações</li>
    </ul>
  </div>
</div>

## 📊 Logs e Monitoramento

O script gera logs detalhados que podem ser visualizados em:

- **Job Logs do Automation Account**: Disponíveis diretamente no portal Azure
- **Log Analytics**: Se configurado o Diagnostic Settings
- **Alertas de E-mail**: Notificações para execuções falhas

## ❓ Troubleshooting

<div align="center">
  <table>
    <tr>
      <th width="30%">Problema</th>
      <th width="30%">Possível Causa</th>
      <th width="40%">Solução</th>
    </tr>
    <tr>
      <td>
        <div align="center">
          <span style="color: red; font-size: 24px;">⚠️</span><br>
          <b>Erro "Identidade não configurada"</b>
        </div>
      </td>
      <td>Identidade Gerenciada não está ativada no Automation Account</td>
      <td>
        <ol>
          <li>Acesse o Automation Account</li>
          <li>Navegue para <b>Identity</b> no menu lateral</li>
          <li>Defina <b>System assigned</b> como <b>On</b></li>
          <li>Clique em <b>Save</b></li>
        </ol>
      </td>
    </tr>
    <tr>
      <td>
        <div align="center">
          <span style="color: red; font-size: 24px;">🔒</span><br>
          <b>Permissão negada</b>
        </div>
      </td>
      <td>Falta de privilégios adequados para a Identidade Gerenciada</td>
      <td>
        <ol>
          <li>Acesse <b>Subscription</b> > <b>Access control (IAM)</b></li>
          <li>Adicione a Identidade Gerenciada do Automation Account</li>
          <li>Atribua o papel <b>"Virtual Machine Contributor"</b></li>
        </ol>
      </td>
    </tr>
    <tr>
      <td>
        <div align="center">
          <span style="color: red; font-size: 24px;">🔍</span><br>
          <b>Nenhuma VM encontrada</b>
        </div>
      </td>
      <td>Tag incorreta ou inexistente nas VMs alvo</td>
      <td>
        <ol>
          <li>Verifique se as VMs possuem <b>exatamente</b> a mesma tag (nome e valor) configurada no Runbook</li>
          <li>Confirme se não há erros de digitação ou espaços extras</li>
          <li>Tags são case-sensitive, verifique maiúsculas/minúsculas</li>
        </ol>
      </td>
    </tr>
    <tr>
      <td>
        <div align="center">
          <span style="color: red; font-size: 24px;">💻</span><br>
          <b>VM em estado de falha</b>
        </div>
      </td>
      <td>Problema específico com a VM</td>
      <td>
        <ol>
          <li>No portal Azure, acesse a VM específica</li>
          <li>Verifique <b>Activity log</b> e <b>Diagnostics</b></li>
          <li>Consulte os logs detalhados do Automation Account</li>
          <li>Verifique se não há locks de recursos impedindo a operação</li>
        </ol>
      </td>
    </tr>
  </table>
</div>

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests com melhorias.

## 📝 Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

Desenvolvido com ❤️ por [Mathews Buzetti](https://www.linkedin.com/in/mathewsbuzetti)
