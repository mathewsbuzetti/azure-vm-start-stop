# Script de Automação Start/Stop de VMs Azure

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Mathews_Buzetti-blue)](https://www.linkedin.com/in/mathewsbuzetti)
![Azure](https://img.shields.io/badge/Azure-blue?style=flat-square&logo=microsoftazure)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)
![Status](https://img.shields.io/badge/Status-Production-green?style=flat-square)

## 📋 Metadados
| Metadado | Descrição |
|----------|-----------|
| **Título** | Script de Automação Start/Stop de VMs Azure |
| **Versão** | 1.0.0 |
| **Data** | 18/02/2025 |
| **Autor** | Mathews Buzetti |
| **Tags** | `azure-automation`, `powershell`, `start-stop-vms`, `custo-eficiência` |

## ✅ Benefícios

- **Redução de custos**: Economize até 70% em ambientes não-produtivos
- **Automação completa**: Sem necessidade de intervenção manual
- **Flexibilidade**: Agendamentos personalizados por grupos de VMs
- **Segurança**: Autenticação via Identidade Gerenciada sem credenciais expostas
- **Monitoramento**: Sistema detalhado de logs para acompanhamento

## 📋 Visão Geral

Este script PowerShell automatiza o processo de inicialização e desligamento de máquinas virtuais no Azure com base em tags. Perfeito para ambientes não-produtivos (desenvolvimento, testes, QA, homologação) onde as VMs podem ser desligadas fora do horário comercial, gerando economia significativa.

## ⚙️ Pré-requisitos

- Azure Subscription ativa
- Automation Account com privilégios de "Virtual Machine Contributor"
- Identidade Gerenciada configurada para o Automation Account
- VMs Azure para aplicação de start/stop automatizado

> [!WARNING]  
> O Automation Account **precisa ter** a Identidade Gerenciada habilitada e permissões adequadas para gerenciar as VMs. Sem isto, o script falhará durante a execução.

## 🔧 Instalação e Configuração

1. **Baixe o script**:

   [![Download Script](https://img.shields.io/badge/Download%20Script%20Start%2FStop-blue?style=flat-square&logo=powershell)](https://github.com/mathewsbuzetti/azure-infrastructure-template/blob/main/Scripts/Script_Start_e_Stop_de_VMs.ps1)

2. **Configure o Runbook no Azure Automation**:

   - Acesse o Automation Account no Azure Portal
   - Crie um novo Runbook "START_STOP_VMs" ou use um existente
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

> [!WARNING]  
> Ao configurar agendamentos, verifique o fuso horário para garantir que as VMs sejam iniciadas/desligadas no horário local correto. O Azure Automation usa UTC por padrão.

4. **Configure as VMs**:
   
   - Acesse cada VM que deseja incluir na automação
   - Adicione a tag com o mesmo nome e valor configurados no Runbook

> [!TIP]  
> Use um padrão consistente para suas tags como "AutoStartStop: True" ou "Environment: Dev" para facilitar o gerenciamento. Tags são case-sensitive, então mantenha a mesma formatação em todas as VMs.

## 📝 Parâmetros do Script

| Parâmetro | Descrição | Obrigatório | Tipo |
|-----------|-----------|------------|------|
| `TagName` | Nome da tag para identificar as VMs | Sim | String |
| `TagValue` | Valor da tag para filtrar as VMs | Sim | String |
| `Shutdown` | Define a ação: true = desligar, false = iniciar | Sim | Boolean |

> [!WARNING]  
> Não modifique os nomes dos parâmetros no script. O Runbook espera exatamente esses nomes de parâmetros para funcionar corretamente.

## ⚙️ Como Funciona

O script opera em três etapas principais:

1. **Autenticação**: Conecta ao Azure usando a Identidade Gerenciada do Automation Account
2. **Identificação**: Busca todas as VMs que possuem a tag e valor específicos
3. **Operação**: Inicia ou para cada VM de acordo com o parâmetro Shutdown

O script verifica o estado atual de cada VM antes de executar a ação, evitando operações desnecessárias em VMs que já estão no estado desejado.

> [!TIP]  
> O script registra logs detalhados que você pode consultar no Automation Account > Jobs. Verifique esses logs para entender o comportamento do script e diagnosticar problemas.

## 🔍 Troubleshooting

| Problema | Possível Causa | Solução |
|----------|----------------|---------|
| Erro "Identidade não configurada" | Identidade Gerenciada não ativada | Ativar Identidade Gerenciada no Automation Account |
| Permissão negada | Falta de privilégios | Conceder papel "Virtual Machine Contributor" à Identidade Gerenciada |
| Nenhuma VM encontrada | Tag incorreta ou inexistente | Verificar se as tags estão configuradas corretamente nas VMs |
| VM em estado de falha | Problema na VM | Verificar logs detalhados da VM no portal Azure |

## 📈 Economia de Custos

Exemplo de economia mensal por VM:

| Tipo de VM | Custo Mensal (24/7) | Custo com Start/Stop (9h x dias úteis) | Economia |
|------------|---------------------|--------------------------------------|----------|
| B2s | $30.37 | $9.11 | 70% |
| D2s v3 | $91.10 | $27.33 | 70% |
| E2s v3 | $122.44 | $36.73 | 70% |

*Valores aproximados, podem variar conforme a região e promoções.

> [!TIP]  
> Para maximizar a economia, considere agrupar suas VMs por função e criar diferentes agendamentos. Por exemplo, servidores de desenvolvimento podem ser desligados às 19h, enquanto servidores de testes noturnos podem ser programados para iniciar às 20h e desligar às 6h.

## 📄 Licença

Este projeto está licenciado sob a licença MIT.

---

Desenvolvido por [Mathews Buzetti](https://www.linkedin.com/in/mathewsbuzetti)
