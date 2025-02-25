# Script de Automação Start/Stop de VMs Azure

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Mathews_Buzetti-blue)](https://www.linkedin.com/in/mathewsbuzetti)
![Azure](https://img.shields.io/badge/Azure-blue?style=flat-square&logo=microsoftazure)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)
![Status](https://img.shields.io/badge/Status-Production-green?style=flat-square)

## ✅ Benefícios

- **Redução de custos**: Economize até 70% em ambientes não-produtivos
- **Automação completa**: Sem necessidade de intervenção manual
- **Flexibilidade**: Agendamentos personalizados por grupos de VMs
- **Segurança**: Autenticação via Identidade Gerenciada sem credenciais expostas
- **Monitoramento**: Sistema de logs e notificações de falhas por e-mail

## 📋 Visão Geral

Script PowerShell para agendamento automático de inicialização e desligamento de VMs Azure baseado em tags. Perfeito para ambientes não-produtivos (desenvolvimento, testes, QA, homologação) onde as VMs podem ser desligadas fora do horário comercial, gerando economia significativa.

## ⚙️ Pré-requisitos

- Azure Subscription ativa
- Automation Account com privilégios de "Virtual Machine Contributor"
- Identidade Gerenciada configurada para o Automation Account
- Log Analytics Workspace (para alertas)
- VMs Azure que deseja gerenciar

## 🔧 Instalação e Configuração

1. **Baixe o script**:

   [![Download Script](https://img.shields.io/badge/Download%20Script%20Start%2FStop-blue?style=flat-square&logo=powershell)](https://github.com/mathewsbuzetti/azure-infrastructure-template/blob/main/Scripts/Script_Start_e_Stop_de_VMs.ps1)

2. **Configure o Runbook no Azure Automation**:

   - Acesse o Automation Account no Azure Portal
   - Crie um novo Runbook ou use um existente
   - Importe o conteúdo do script baixado
   - Publique o Runbook

3. **Configure os agendamentos**:

   - **Para iniciar VMs**: Crie um agendamento (ex: dias úteis às 9h)
     - Parâmetros:
       - TagName: Nome da tag (ex: "Ambiente")
       - TagValue: Valor da tag (ex: "Desenvolvimento")
       - Shutdown: false

   - **Para parar VMs**: Crie um agendamento (ex: dias úteis às 19h)
     - Parâmetros:
       - TagName: Nome da tag (ex: "Ambiente")
       - TagValue: Valor da tag (ex: "Desenvolvimento")
       - Shutdown: true

4. **Configure as VMs**:
   
   - Acesse cada VM que deseja incluir na automação
   - Adicione a tag com o mesmo nome e valor configurados no Runbook

## 📝 Parâmetros do Script

| Parâmetro | Descrição | Obrigatório |
|-----------|-----------|------------|
| `TagName` | Nome da tag para identificar as VMs | Sim |
| `TagValue` | Valor da tag para filtrar as VMs | Sim |
| `Shutdown` | Define a ação: true = desligar, false = iniciar | Sim |

## 🔔 Alertas e Monitoramento

### Configuração de Alertas por E-mail

1. Configure o Diagnostic Settings no Automation Account:
   - Ative JobLogs, JobStreams e AuditEvent
   - Envie para Log Analytics

2. Crie um alerta no Log Analytics:
   - Use a query fornecida para detectar falhas nos jobs
   - Configure um Action Group para enviar e-mails

```kql
// Azure Automation jobs que falharam, foram suspensos ou interrompidos
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

## 🔍 Troubleshooting

| Problema | Solução |
|----------|---------|
| Erro de autenticação | Verifique se a Identidade Gerenciada está ativada e tem permissões corretas |
| VMs não afetadas | Confirme se as tags estão exatamente iguais às configuradas no Runbook |
| Falhas de execução | Verifique os logs do Runbook no Automation Account |

## 📈 Economia de Custos

Exemplo de economia mensal por VM:

| Tipo de VM | Custo Mensal (24/7) | Custo com Start/Stop (9h x dias úteis) | Economia |
|------------|---------------------|--------------------------------------|----------|
| B2s | $30.37 | $9.11 | 70% |
| D2s v3 | $91.10 | $27.33 | 70% |
| E2s v3 | $122.44 | $36.73 | 70% |

*Valores aproximados, podem variar conforme a região e promoções.

## 📄 Licença

Este projeto está licenciado sob a licença MIT.

---

Desenvolvido por [Mathews Buzetti](https://www.linkedin.com/in/mathewsbuzetti)
