# ⚙️ Automação de Start/Stop para VMs Azure

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Mathews_Buzetti-blue)](https://www.linkedin.com/in/mathewsbuzetti)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)
![Status](https://img.shields.io/badge/Status-Production-success?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 📋 Metadados

| Metadado | Descrição |
|----------|-----------|
| **Título** | Automação de Start/Stop para VMs Azure |
| **Versão** | 1.0.0 |
| **Data** | 18/02/2025 |
| **Autor** | Mathews Buzetti |
| **Tags** | `azure-automation`, `powershell`, `start-stop-vms`, `cost-optimization` |
| **Status** | ✅ Aprovado para ambiente de produção |

## 💰 Economize até 70% em seus custos com Azure VMs

**Automatize totalmente o ciclo de início e parada das suas máquinas virtuais Azure com base em tags e agendamentos personalizados. Solução ideal para ambientes não-produtivos como desenvolvimento, testes, QA, e homologação.**

## 📌 Índice
- [✨ Benefícios-Chave](#-benefícios-chave)
- [🔍 Como Funciona](#-como-funciona)
- [⚙️ Pré-requisitos](#️-pré-requisitos)
- [🔧 Guia de Configuração Detalhado](#-guia-de-configuração-detalhado)
- [📝 Parâmetros do Script](#-parâmetros-do-script)
- [📄 Licença](#-licença)

## ✨ Benefícios-Chave

| Benefício | Antes | Depois |
|-----------|-------|--------|
| **💰 Economia Substancial** | Máquinas virtuais executando 24/7 mesmo sem uso | VMs ligadas apenas quando necessárias com economia de até 70% |
| **⏱️ Gestão do Tempo** | Intervenção manual diária para ligar/desligar VMs | Automação completa baseada em agendamentos personalizados |
| **🔄 Flexibilidade** | Esquemas rígidos ou desligamentos manuais esquecidos | Agendamentos específicos para diferentes grupos de VMs por tag |
| **🔒 Segurança** | Credenciais expostas ou senhas armazenadas | Autenticação segura via Identidade Gerenciada sem senhas |
| **📊 Monitoramento** | Sem visibilidade das operações realizadas | Sistema detalhado de logs para auditoria e controle |

## 🔍 Como Funciona

O script PowerShell opera através de um processo otimizado e seguro:

```mermaid
flowchart TD
    A[Início do Runbook Agendado] --> B[Autenticação via\nIdentidade Gerenciada]
    B --> C[Busca VMs por tag\nNome: TagName\nValor: TagValue]
    C --> D{Verificar parâmetro\nShutdown}
    
    D -->|Shutdown = true| E[Filtrar VMs ligadas]
    D -->|Shutdown = false| F[Filtrar VMs desligadas]
    
    E --> G[Para cada VM em execução]
    F --> H[Para cada VM parada]
    
    G --> G1{VM está em\nestado transitório?}
    G1 -->|Sim| G2[Aguardar estabilização\nou pular]
    G1 -->|Não| G3[Parar VM]
    G3 --> G4[Registrar evento\nno log]
    G2 --> G4
    
    H --> H1{VM está em\nestado transitório?}
    H1 -->|Sim| H2[Aguardar estabilização\nou pular]
    H1 -->|Não| H3[Iniciar VM]
    H3 --> H4[Registrar evento\nno log]
    H2 --> H4
    
    G4 --> I[Fim do Runbook]
    H4 --> I
```

1. **📡 Conexão**: Autentica-se ao Azure usando Identidade Gerenciada (sem credenciais expostas)
2. **🔍 Identificação**: Localiza todas as VMs com as tags especificadas nos parâmetros
3. **📊 Avaliação**: Analisa o estado atual de cada VM para evitar operações redundantes
4. **⚙️ Execução**: Realiza a operação de iniciar ou parar conforme o parâmetro `Shutdown`
5. **📝 Registro**: Documenta detalhadamente cada ação para auditoria e monitoramento

## 🔧 Guia de Configuração Detalhado

### 1. Preparação da Conta de Automação

#### 1.1 Criar Conta de Automação

1. Acesse o **Portal Azure** ([portal.azure.com](https://portal.azure.com))
2. Clique em **Criar um recurso**
3. Pesquise por **Automation** e selecione **Conta de Automação**
4. Clique em **Criar**
5. Preencha os campos necessários:
   - **Nome:** Um nome exclusivo para sua conta (ex: AutomacaoVMs)
   - **Assinatura:** Selecione sua assinatura Azure
   - **Grupo de recursos:** Selecione existente ou crie um novo
   - **Região:** Escolha a região mais próxima de você
6. Clique em **Revisar + criar** e depois em **Criar**

#### 1.2 Habilitar Identidade Gerenciada

1. Aguarde a criação da conta de automação e acesse-a
2. No menu lateral, em **Configurações**, selecione **Identidade**
3. Na aba **Atribuído pelo sistema**, defina o **Status** como **Ativado**
4. Clique em **Salvar**
5. Uma notificação irá aparecer. Clique em **Sim** para confirmar
6. **IMPORTANTE:** Anote o **ID do Objeto** mostrado - você precisará dele para o próximo passo

> **Nota:** A Identidade Gerenciada é um recurso de segurança crítico que permite que o script se autentique no Azure sem a necessidade de credenciais hardcoded ou certificados.

#### 1.3 Configurar Permissões

1. No Portal Azure, acesse **Assinaturas**
2. Selecione a assinatura onde as VMs estão (ou estarão) alocadas
3. No menu lateral, selecione **Controle de acesso (IAM)**
4. Clique em **Adicionar** > **Adicionar atribuição de função**
5. Em **Função**, procure e selecione **Virtual Machine Contributor**
6. Em **Membros**, selecione **Identidade gerenciada**
7. Clique em **Selecionar membros**
8. Em **Identidades gerenciadas**, selecione **Conta de Automação**
9. Encontre e selecione a conta de automação criada anteriormente
10. Clique em **Selecionar** e depois em **Revisar + atribuir**
11. Clique em **Revisar + atribuir** novamente para confirmar

> **Dica de Segurança:** Para seguir o princípio de menor privilégio, você pode optar por atribuir a função apenas aos grupos de recursos específicos que contêm as VMs alvo, em vez de conceder acesso a toda a subscrição.

### 2. Configuração do Script e Runbook

#### 2.1 Obter o Script PowerShell

[![Download Script Start/Stop](https://img.shields.io/badge/Download%20Script%20Start%2FStop-blue?style=flat-square&logo=powershell)](https://github.com/mathewsbuzetti/azure-infrastructure-template/blob/main/Scripts/Script_Start_e_Stop_de_VMs.ps1)

#### 2.2 Criar um Novo Runbook

1. Acesse sua **Conta de Automação** no Portal Azure
2. No menu lateral, em **Recursos de automação**, selecione **Runbooks**
3. Clique em **+ Criar um runbook**
4. Preencha as informações:
   - **Nome:** START_STOP_VMs
   - **Tipo de runbook:** PowerShell
   - **Versão do Runtime:** 5.1
   - **Descrição:** "Automação para iniciar e parar VMs com base em tags"
5. Clique em **Criar**

#### 2.3 Importar o Script

1. No editor do runbook que acabou de abrir, apague qualquer código existente
2. Copie e cole o conteúdo completo do script **Script_Start_e_Stop_de_VMs.ps1**
3. Verifique se os três parâmetros estão presentes e corretos:
   - `$TagName`: Nome da tag para identificar as VMs
   - `$TagValue`: Valor da tag para filtrar as VMs
   - `$Shutdown`: Booleano que define se as VMs serão desligadas ou iniciadas
4. Clique em **Salvar**

> **Dica:** Não altere os nomes dos parâmetros, pois os agendamentos farão referência a esses nomes específicos.

#### 2.4 Testar e Publicar o Runbook

1. Clique em **Testar painel** para abrir o painel de teste
2. Preencha os parâmetros de teste:
   - **TagName:** Digite "Test" (ou outra tag de teste)
   - **TagValue:** Digite "Test" (ou outro valor de teste)
   - **Shutdown:** Digite "False" para testar a inicialização
3. Clique em **Iniciar** para executar o teste
4. Verifique os logs de saída para garantir que não há erros
5. Após o teste bem-sucedido, feche o painel de teste
6. Clique em **Publicar** para publicar o runbook
7. Confirme a publicação quando solicitado

> **Importante:** O teste do runbook verifica apenas a sintaxe e a conexão com o Azure. Não se preocupe se nenhuma VM for encontrada neste momento, pois ainda não configuramos as tags reais nas VMs.

### 3. Configuração dos Agendamentos

#### 3.1 Criar Agendamento para Iniciar VMs (Manhã)

1. No Portal Azure, acesse sua **Conta de Automação**
2. No menu lateral, em **Recursos compartilhados**, selecione **Agendamentos**
3. Clique em **+ Adicionar um agendamento**
4. Preencha as informações:
   - **Nome:** StartVMs_Morning
   - **Descrição:** "Inicia as VMs nos dias úteis pela manhã"
   - **Iniciar:** Selecione a data e hora de início (recomendado: próximo dia útil às 9h)
   - **Fuso horário:** Selecione seu fuso horário local
   - **Recorrência:** Recorrente
   - **Repetir a cada:** 1 Dia
   - **Definir expiração:** Não (ou defina conforme sua necessidade)
   - **Dias da semana:** Selecione apenas os dias úteis (Segunda a Sexta)
5. Clique em **Criar**

> **Atenção ao Fuso Horário:** O Azure Automation usa UTC por padrão. Certifique-se de selecionar o fuso horário correto para que as VMs sejam iniciadas no horário local desejado.

#### 3.2 Criar Agendamento para Parar VMs (Noite)

1. Ainda na seção **Agendamentos**, clique novamente em **+ Adicionar um agendamento**
2. Preencha as informações:
   - **Nome:** StopVMs_Evening
   - **Descrição:** "Para as VMs nos dias úteis à noite"
   - **Iniciar:** Selecione a data e hora de início (recomendado: próximo dia útil às 19h)
   - **Fuso horário:** Selecione seu fuso horário local (mesmo do agendamento anterior)
   - **Recorrência:** Recorrente
   - **Repetir a cada:** 1 Dia
   - **Definir expiração:** Não (ou defina conforme sua necessidade)
   - **Dias da semana:** Selecione apenas os dias úteis (Segunda a Sexta)
3. Clique em **Criar**

#### 3.3 Vincular o Agendamento Matutino ao Runbook

1. No menu lateral, em **Recursos de automação**, selecione **Runbooks**
2. Clique no runbook **START_STOP_VMs** que foi criado anteriormente
3. Na barra de menu superior, clique em **Vincular a um agendamento**
4. Selecione **Vincular um agendamento ao seu runbook**
5. Em **Agendamento**, selecione **StartVMs_Morning**
6. Em **Parâmetros**, preencha:
   - **TagName:** Digite o nome da tag (ex: "Ambiente")
   - **TagValue:** Digite o valor da tag (ex: "Desenvolvimento")
   - **Shutdown:** Digite "False" (para iniciar as VMs)
7. Clique em **OK** para salvar

> **Dica de configuração:** Você pode criar diferentes combinações de tags e valores para gerenciar grupos específicos de VMs. Por exemplo, separar ambientes de desenvolvimento, testes e homologação.

#### 3.4 Vincular o Agendamento Noturno ao Runbook

1. Na mesma tela do runbook, clique novamente em **Vincular a um agendamento**
2. Selecione **Vincular um agendamento ao seu runbook**
3. Em **Agendamento**, selecione **StopVMs_Evening**
4. Em **Parâmetros**, preencha:
   - **TagName:** Digite o mesmo nome de tag usado anteriormente (ex: "Ambiente")
   - **TagValue:** Digite o mesmo valor de tag usado anteriormente (ex: "Desenvolvimento")
   - **Shutdown:** Digite "True" (para parar as VMs)
5. Clique em **OK** para salvar

### 4. Preparação das VMs

#### 4.1 Identificar VMs Alvo

Identifique todas as VMs que você deseja incluir na automação de start/stop. Normalmente, estas serão:
- VMs de ambiente de desenvolvimento
- VMs de teste e QA
- VMs de homologação
- Qualquer VM não-produtiva que não precisa ficar disponível 24/7

> **Atenção:** Verifique cuidadosamente quais VMs devem ser incluídas. Não inclua VMs de produção a menos que tenha certeza absoluta de que podem ser desligadas nos horários programados.

#### 4.2 Adicionar Tags às VMs

Para cada VM que você deseja incluir na automação:

1. No Portal Azure, acesse **Máquinas Virtuais**
2. Clique na VM que deseja gerenciar
3. No menu lateral, selecione **Tags**
4. Adicione a tag com o mesmo nome e valor configurados nos agendamentos:
   - **Nome:** Digite o nome da tag (ex: "Ambiente")
   - **Valor:** Digite o valor da tag (ex: "Desenvolvimento")
5. Clique em **Salvar**

**Adicionar Tags em Lote:**
1. Na lista de Máquinas Virtuais, selecione todas as VMs desejadas
2. Clique em **Atribuir tags** na barra de menu superior
3. Adicione o nome e valor da tag
4. Clique em **Salvar**

**Estratégias de Tagging Eficientes:**
- **Ambiente:Desenvolvimento** - para VMs de desenvolvimento
- **Ambiente:Teste** - para VMs de teste
- **Ambiente:Homologação** - para VMs de homologação
- **AutoStartStop:True** - abordagem genérica para todas as VMs

#### 4.3 Verificar a Configuração das Tags

Após adicionar as tags, é importante verificar se estão corretamente configuradas:

1. No Portal Azure, acesse **Máquinas Virtuais**
2. Use o filtro na parte superior para filtrar por sua tag (ex: "Ambiente: Desenvolvimento")
3. Confirme se todas as VMs que deveriam estar incluídas aparecem na lista filtrada
4. Se alguma VM estiver faltando, verifique se a tag foi adicionada corretamente

> **Lembre-se:** As tags no Azure são case-sensitive. Certifique-se de que o nome e o valor da tag correspondam exatamente aos configurados nos agendamentos do Runbook.

### 5. Teste e Monitoramento

#### 5.1 Executar Teste Manual

1. No Portal Azure, acesse sua **Conta de Automação**
2. No menu lateral, em **Recursos de automação**, selecione **Runbooks**
3. Clique no runbook **START_STOP_VMs**
4. Na barra de menu superior, clique em **Iniciar**
5. Preencha os parâmetros:
   - **TagName:** Digite o nome da tag configurada nas VMs (ex: "Ambiente")
   - **TagValue:** Digite o valor da tag configurada nas VMs (ex: "Desenvolvimento")
   - **Shutdown:** Digite "True" para testar o desligamento ou "False" para testar a inicialização
6. Clique em **OK** para iniciar o runbook

> **Dica:** Recomenda-se testar primeiro com um pequeno conjunto de VMs não críticas. Você pode criar uma tag temporária (ex: "TesteAutomacao: True") em algumas VMs para esse propósito.

#### 5.2 Verificar os Logs de Execução

1. Na tela do runbook, clique no **Job** que acabou de ser iniciado na seção "Jobs"
2. Observe o **Status** do job (Em execução, Concluído, Com falha)
3. Revise a saída na aba **Saída**:
   - Verifique se a autenticação no Azure foi bem-sucedida
   - Confirme se as VMs esperadas foram encontradas
   - Observe as mensagens sobre o estado das VMs e as ações realizadas
   - Verifique se há mensagens de erro ou aviso
4. Acesse **Máquinas Virtuais** no Portal Azure para confirmar visualmente que as VMs foram realmente iniciadas ou paradas conforme o comando

#### 5.3 Monitorar Execuções Agendadas

Após confirmar que o teste manual funciona, monitore as primeiras execuções agendadas:

1. No dia e horário configurados para os agendamentos, verifique se o runbook foi iniciado automaticamente:
   - Acesse a **Conta de Automação** > **Runbooks** > **START_STOP_VMs**
   - Verifique se há um novo job na lista de jobs
2. Verifique os logs de execução do job agendado
3. Confirme que as VMs foram iniciadas ou paradas conforme programado
4. Configure alertas ou crie um processo de verificação regular para garantir que a automação continue funcionando corretamente ao longo do tempo

## 📝 Parâmetros do Script

```powershell
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
```

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
Shutdown = $false
```

**Exemplo de configuração para agendamento noturno:**
```powershell
TagName = "Ambiente"
TagValue = "Desenvolvimento" 
Shutdown = $true
```

### Como Verificar os Logs de Execução

1. Acesse sua **Conta de Automação** no Portal Azure
2. No menu lateral, em **Recursos de automação**, selecione **Runbooks**
3. Clique no runbook **START_STOP_VMs**
4. Selecione a aba **Jobs** para ver todas as execuções
5. Clique no job específico que deseja analisar
6. Na aba **Saída**, analise os logs detalhados da execução
7. Procure por mensagens de erro ou avisos que possam indicar o problema

> **Dica de diagnóstico:** O script utiliza diferentes níveis de log (INFO, SUCCESS, ERROR, WARNING) que podem ajudar a identificar o problema. Preste atenção especial às mensagens marcadas como ERROR ou WARNING.

## 📄 Licença

Este projeto está licenciado sob a [licença MIT](https://opensource.org/licenses/MIT).

---

<div align="center">

**Desenvolvido por [Mathews Buzetti](https://www.linkedin.com/in/mathewsbuzetti)**

**Tem dúvidas ou sugestões? Entre em contato via LinkedIn!**

</div>
