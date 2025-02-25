# 🚀 Automação de Start/Stop para VMs Azure

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Mathews_Buzetti-blue)](https://www.linkedin.com/in/mathewsbuzetti)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)
![Status](https://img.shields.io/badge/Status-Production-success?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 💰 Economize até 70% em seus custos com Azure VMs

**Automatize totalmente o ciclo de início e parada das suas máquinas virtuais Azure com base em tags e agendamentos personalizados.**

<div align="center">
<h3>⏱️ Configuração em 15 minutos | 🔧 Zero intervenção manual | 📊 ROI imediato</h3>
</div>

## 📌 Índice
- [📊 Visão Geral](#-visão-geral)
- [✨ Benefícios-Chave](#-benefícios-chave)
- [📈 Análise de Economia](#-análise-de-economia)
- [🔍 Como Funciona](#-como-funciona)
- [🚀 Guia de Início Rápido](#-guia-de-início-rápido)
- [⚙️ Pré-requisitos](#️-pré-requisitos)
- [📝 Parâmetros do Script](#-parâmetros-do-script)
- [❓ Perguntas Frequentes](#-perguntas-frequentes)
- [⚠️ Resolução de Problemas](#-resolução-de-problemas)
- [📋 Metadados](#-metadados)
- [📄 Licença](#-licença)

## 📊 Visão Geral

Esta solução **totalmente automatizada** gerencia o ciclo de vida de máquinas virtuais no Azure com base em tags personalizáveis. Ideal para ambientes não-produtivos (desenvolvimento, testes, QA, homologação), permite programar o desligamento e inicialização automáticos das VMs de acordo com seus horários de trabalho.

**A solução é perfeita para:**
- 💻 Times de desenvolvimento com ambientes dedicados
- 🧪 Ambientes de homologação e testes
- 🏢 Empresas que desejam otimizar custos na nuvem
- 🔍 Equipes DevOps gerenciando múltiplos ambientes

## ✨ Benefícios-Chave



## 📈 Análise de Economia


### 💡 Cenário de Economia Real

Uma empresa com 20 VMs de desenvolvimento e teste (mix de B2s, D2s v3 e E2s v3) economizou mais de **$15.000 por ano** implementando esta solução de automação, pagando apenas pelas horas de uso efetivo durante o horário comercial.

## 🔍 Como Funciona



O script PowerShell opera através de um processo otimizado e seguro:

1. **📡 Conexão**: Autentica-se ao Azure usando Identidade Gerenciada (sem credenciais expostas)
2. **🔍 Identificação**: Localiza todas as VMs com as tags especificadas nos parâmetros
3. **📊 Avaliação**: Analisa o estado atual de cada VM para evitar operações redundantes
4. **⚙️ Execução**: Realiza a operação de iniciar ou parar conforme o parâmetro `Shutdown`
5. **📝 Registro**: Documenta detalhadamente cada ação para auditoria e monitoramento

## 🚀 Guia de Início Rápido




## ⚙️ Pré-requisitos

- ✅ Subscrição Azure ativa
- ✅ Conta de Automação Azure
- ✅ Identidade Gerenciada ativada na conta de Automação
- ✅ Permissão "Virtual Machine Contributor" para a Identidade Gerenciada
- ✅ VMs Azure configuradas com as tags apropriadas

> [!IMPORTANT]  
> A Identidade Gerenciada é **fundamental** para a segurança da solução. Ela permite que o script se autentique no Azure sem armazenar credenciais, eliminando riscos de vazamento de senhas.

## 📝 Parâmetros do Script

Os parâmetros abaixo devem ser configurados nos agendamentos do Runbook:

| Parâmetro | Descrição | Exemplo | Obrigatório |
|-----------|-----------|---------|-------------|
| `TagName` | Nome da tag para identificar as VMs | "Ambiente" | ✅ |
| `TagValue` | Valor da tag para filtrar as VMs | "Desenvolvimento" | ✅ |
| `Shutdown` | Define a ação (true = desligar, false = iniciar) | true | ✅ |

**Exemplo de configuração para agendamento matutino:**
```powershell
TagName = "Ambiente"
TagValue = "Desenvolvimento" 
Shutdown = false
```

**Exemplo de configuração para agendamento noturno:**
```powershell
TagName = "Ambiente"
TagValue = "Desenvolvimento" 
Shutdown = true
```

## ❓ Perguntas Frequentes

<details>
<summary><b>🔄 Posso ter diferentes agendamentos para diferentes ambientes?</b></summary>
Sim! Basta criar múltiplos agendamentos com diferentes valores de parâmetros. Por exemplo, você pode ter um agendamento para o ambiente de desenvolvimento (TagValue = "Dev") e outro para o ambiente de testes (TagValue = "QA").
</details>

<details>
<summary><b>🌐 A solução funciona em todas as regiões do Azure?</b></summary>
Sim, a solução é independente de região e funcionará em qualquer região do Azure onde as VMs estejam hospedadas.
</details>

<details>
<summary><b>⏱️ Como ajustar o fuso horário dos agendamentos?</b></summary>
O Azure Automation utiliza UTC por padrão. Ao criar os agendamentos, certifique-se de ajustar o horário conforme seu fuso horário local. Por exemplo, se você está no horário de Brasília (UTC-3), para iniciar às 9h, configure o agendamento para 12h UTC.
</details>

<details>
<summary><b>🔍 Como saber se o script está funcionando corretamente?</b></summary>
Você pode verificar os logs de execução do Runbook na seção "Jobs" da sua Conta de Automação. Além disso, o status das VMs no portal Azure mostrará se elas estão sendo iniciadas e paradas nos horários programados.
</details>

<details>
<summary><b>🛑 E se eu precisar manter uma VM ligada fora do horário normal?</b></summary>
Basta remover temporariamente a tag da VM ou adicionar uma tag de exceção. O script só afetará VMs que correspondam exatamente aos critérios de tag especificados.
</details>

## ⚠️ Resolução de Problemas

| Erro | Possível Causa | Solução |
|------|----------------|---------|
| "Identidade Gerenciada não configurada" | A Identidade Gerenciada não está habilitada | Ative a Identidade Gerenciada na conta de Automação |
| "Acesso Negado" | Permissões insuficientes | Verifique se a Identidade Gerenciada tem o papel "Virtual Machine Contributor" |
| "Nenhuma VM encontrada com a tag especificada" | Tags configuradas incorretamente | Confirme o nome e valor exatos das tags nas VMs |
| "A VM está em estado transitório" | VM em processo de alteração de estado | Aguarde a conclusão da operação em andamento |
| "Falha ao iniciar/parar VM" | Problema específico da VM | Verifique os logs de diagnóstico da VM |

## 📋 Metadados

| Metadado | Descrição |
|----------|-----------|
| **Título** | Automação de Start/Stop para VMs Azure |
| **Versão** | 1.0.0 |
| **Data** | 18/02/2025 |
| **Autor** | Mathews Buzetti |
| **Tags** | `azure-automation`, `powershell`, `start-stop-vms`, `cost-optimization` |

## 📄 Licença

Este projeto está licenciado sob a [licença MIT](https://opensource.org/licenses/MIT).

---

<div align="center">

**Desenvolvido por [Mathews Buzetti](https://www.linkedin.com/in/mathewsbuzetti)**

**Tem dúvidas ou sugestões? Entre em contato via LinkedIn!**

</div>
