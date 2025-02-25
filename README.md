# ⚙️ Automação de Start/Stop para VMs Azure

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Mathews_Buzetti-blue)](https://www.linkedin.com/in/mathewsbuzetti)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)
![Status](https://img.shields.io/badge/Status-Production-success?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

**Economize até 70% nos custos da Azure automatizando o início e parada de VMs com base em tags.**

[![Download Script](https://img.shields.io/badge/Download%20Script-Start%2FStop%20VMs-blue?style=for-the-badge&logo=powershell)](https://github.com/mathewsbuzetti/azure-infrastructure-template/blob/main/Scripts/Script_Start_e_Stop_de_VMs.ps1)

## 💰 Benefícios Principais

- **Economia de até 70%** nos custos de VMs não-produtivas
- **Zero intervenção manual** após configuração
- **Segurança aprimorada** com Identidade Gerenciada (sem senhas expostas)
- **Flexibilidade total** com agendamentos personalizados por grupos de VMs
- **Logs detalhados** para auditoria e monitoramento

## 🔍 O que o script faz?

- Automatiza o ciclo completo de **ligar e desligar VMs** em horários definidos
- Identifica VMs através de **tags**, facilitando o gerenciamento de grupos
- Verifica inteligentemente o **estado atual** das VMs, evitando operações redundantes
- Usa **autenticação segura** sem credenciais expostas
- Gera **logs detalhados** de todas as operações para rastreamento

## 🚀 Configuração Rápida (5 passos)

### 1. Preparar a Conta de Automação
- Crie uma Conta de Automação ou use uma existente
- **Ative a Identidade Gerenciada** em "Configurações > Identidade"
- Atribua o papel **"Virtual Machine Contributor"** à Identidade Gerenciada

### 2. Criar o Runbook
- Na Conta de Automação, crie um **novo runbook PowerShell** chamado "START_STOP_VMs"
- Cole o conteúdo do script e **publique o runbook**

### 3. Configurar Agendamentos
- Crie **dois agendamentos**:
  - **StartVMs_Morning**: dias úteis às 9h, parâmetros (`TagName="Ambiente", TagValue="Desenvolvimento", Shutdown=$false`)
  - **StopVMs_Evening**: dias úteis às 19h, parâmetros (`TagName="Ambiente", TagValue="Desenvolvimento", Shutdown=$true`)
- **Vincule** cada agendamento ao runbook

### 4. Configurar as VMs
- Adicione as **mesmas tags** configuradas nos agendamentos às VMs que deseja gerenciar
- Exemplo: tag `Ambiente: Desenvolvimento` para todas as VMs de desenvolvimento

### 5. Testar
- Execute um **teste manual** do runbook para verificar o funcionamento
- Monitore os **logs de execução** na seção "Jobs" da Conta de Automação

## ⚙️ Características Técnicas do Script

- **Modular e reutilizável** para diferentes ambientes
- **Tratamento robusto de erros** com mensagens claras
- **Verificação inteligente** de estados de VM para evitar operações redundantes
- **Compatível com todas as regiões** do Azure
- **Escalável** para gerenciar dezenas ou centenas de VMs

## 🔧 Parâmetros do Script

O script aceita 3 parâmetros simples:

| Parâmetro | Descrição | Valor de Exemplo |
|-----------|-----------|------------------|
| `TagName` | Nome da tag que identifica as VMs | "Ambiente" |
| `TagValue` | Valor da tag que identifica as VMs | "Desenvolvimento" |
| `Shutdown` | true = desligar, false = iniciar | true ou false |

---

<div align="center">

**Desenvolvido por [Mathews Buzetti](https://www.linkedin.com/in/mathewsbuzetti)**

</div>
