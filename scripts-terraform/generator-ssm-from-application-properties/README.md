# Generator SSM from Application Properties

Este conjunto de scripts automatiza a geração de arquivos Terraform para gerenciar parâmetros de aplicação usando AWS Systems Manager Parameter Store.




## 📋 Pré-requisitos

- Arquivos de configuração de propriedades:
  - `application-dev.properties`
  - `application-hom.properties`
  - `application-prod.properties`
- `aws-parameter-config.properties` configurado com:
  - `tipo.configuracao`: tipo de configuração (ex: config)
  - `nome.aplicacao`: nome da aplicação

## 🚀 Scripts

### 1. `init.sh`
**O que faz:** Script principal que orquestra a execução de todos os outros scripts.

**Comando:**
```bash
bash init.sh
```

**Executa:**
- `generator-terraform-main.sh`
- `generator-terraform-data.sh`
- `generator-terraform-local.sh`
- `generator-terraform-parameter-store.sh`
- `generator-variables-application.sh`
- `generator-variables-env.sh`

**Saída esperada:** Mensagens indicando o início e fim da criação de recursos.

---

### 2. `generator-terraform-main.sh`
**O que faz:** Gera os arquivos Terraform base (`main.tf` e `variables.tf`) para configurar o provedor AWS e definir recursos de Parameter Store.

**Comando:**
```bash
bash generator-terraform-main.sh
```

**Arquivos criados:**
- `terraform/main.tf`: Define o provedor AWS e o recurso `aws_ssm_parameter`
- `terraform/variables.tf`: Define as variáveis Terraform necessárias

**Estrutura do main.tf:**
```hcl
terraform {
  required_providers {
    aws = { ... }
  }
}

provider "aws" {
  profile = var.profile
}

resource "aws_ssm_parameter" "parametersstore" { ... }
```

---

### 3. `generator-terraform-data.sh`
**O que faz:** Gera o arquivo `terraform/data.tf` que referencia parâmetros existentes no AWS Parameter Store (data sources).

**Comando:**
```bash
bash generator-terraform-data.sh
```

**Arquivo criado:** `terraform/data.tf`

**Exemplo de saída:**
```hcl
data "aws_ssm_parameter" "APP_NAME" {
  name = "/config/lab-a01-app-service-registry/app.name"
}

data "aws_ssm_parameter" "DB_HOST" {
  name = "/config/lab-a01-app-service-registry/db.host"
}
```

**Lógica:**
- Lê as propriedades do `application-dev.properties`
- Ignora variáveis de ambiente (padrão: `${VARIABLE}`)
- Converte chaves para formato UPPERCASE_SNAKE_CASE
- Cria data sources para cada propriedade

---

### 4. `generator-terraform-local.sh`
**O que faz:** Gera o arquivo `terraform/locals.tf` que define variáveis locais Terraform contendo os valores dos parâmetros do Parameter Store.

**Comando:**
```bash
bash generator-terraform-local.sh
```

**Arquivo criado:** `terraform/locals.tf`

**Exemplo de saída:**
```hcl
locals {
  task_env_vars = [
    {
      name  = "APP_NAME",
      value = data.aws_ssm_parameter.APP_NAME.value
    },
    {
      name  = "DB_HOST",
      value = data.aws_ssm_parameter.DB_HOST.value
    }
  ]
}
```

---

### 5. `generator-terraform-parameter-store.sh`
**O que faz:** Gera arquivos `terraform.tfvars` em diretórios específicos por ambiente (dev, hom, prod) contendo os valores reais dos parâmetros.

**Comando:**
```bash
bash generator-terraform-parameter-store.sh
```

**Arquivos criados:**
- `terraform/inventories/dev/terraform.tfvars`
- `terraform/inventories/hom/terraform.tfvars`
- `terraform/inventories/prod/terraform.tfvars`

**Exemplo de saída:**
```hcl
parametros = [
  {
    name                = "/config/lab-a01-app-service-registry/app.name"
    value               = "MyApplication"
    microservicename    = "lab-a01-app-service-registry"
  },
  {
    name                = "/config/lab-a01-app-service-registry/db.host"
    value               = "localhost"
    microservicename    = "lab-a01-app-service-registry"
  }
]
```

**Lógica:**
- Processa os três arquivos de propriedades (dev, hom, prod)
- Ignora variáveis de ambiente
- Cria um arquivo tfvars por ambiente
- Organiza em diretórios separados para melhor controle

---

### 6. `generator-variables-application.sh`
**O que faz:** Gera um arquivo `env/application.properties` contendo referências às variáveis de ambiente com base no arquivo de configuração.

**Comando:**
```bash
bash generator-variables-application.sh
```

**Arquivo criado:** `env/application.properties`

**Exemplo de saída:**
```properties
app.name=${APP_NAME}
db.host=${DB_HOST}
db.port=${DB_PORT}
server.port=${SERVER_PORT}
```

**Lógica:**
- Lê as propriedades do `application-dev.properties`
- Para cada propriedade, cria uma referência `${KEY_UPPERCASE}`
- Mantém variáveis de ambiente originais (formato `${VARIABLE}`)
- Útil para injeção de variáveis em runtime

---

### 7. `generator-variables-env.sh`
**O que faz:** Gera arquivos `.env` separados por ambiente (dev, hom, prod) contendo as variáveis em formato de ambiente.

**Comando:**
```bash
bash generator-variables-env.sh
```

**Arquivos criados:**
- `env/application-dev.properties.env`
- `env/application-hom.properties.env`
- `env/application-prod.properties.env`

**Exemplo de saída (application-dev.properties.env):**
```env
APP_NAME=MyApplication
DB_HOST=localhost
DB_PORT=5432
SERVER_PORT=8080
LOGGING_LEVEL_ROOT=INFO
```

**Lógica:**
- Processa os três arquivos de propriedades
- Converte as chaves para formato UPPERCASE_SNAKE_CASE
- Remove variáveis de ambiente referenciadas
- Cria um arquivo `.env` por ambiente

---

## 📁 Estrutura de Diretórios Gerada

Após executar todos os scripts, a estrutura fica assim:

```
.
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── data.tf
│   ├── locals.tf
│   └── inventories/
│       ├── dev/
│       │   └── terraform.tfvars
│       ├── hom/
│       │   └── terraform.tfvars
│       └── prod/
│           └── terraform.tfvars
├── env/
│   ├── application.properties
│   ├── application-dev.properties.env
│   ├── application-hom.properties.env
│   └── application-prod.properties.env
└── [arquivos de configuração originais]
```

---

## 🔧 Arquivos de Configuração

### `aws-parameter-config.properties`
Define configurações globais para geração de parâmetros:

```properties
tipo.configuracao=config                              # Tipo/categoria dos parâmetros
ambiente.des=application-dev.properties               # Arquivo ambiente dev
ambiente.hom=application-hom.properties               # Arquivo ambiente hom
ambiente.prod=application-prod.properties             # Arquivo ambiente prod
nome.aplicacao=lab-a01-app-service-registry          # Nome da aplicação
```

### Arquivos `application-*.properties`
Contêm as propriedades específicas de cada ambiente (dev, hom, prod):

```properties
app.name=MyApplication
db.host=localhost
db.port=5432
server.port=8080
```

---

## ⚠️ Comportamentos Especiais

1. **Ignorar Variáveis de Ambiente:**
   - Propriedades no formato `${VARIABLE}` são ignoradas durante processamento
   - Não geram parâmetros no AWS Parameter Store
   - Exemplo: `app.config=${EXTERNAL_CONFIG}`

2. **Conversão de Chaves:**
   - Hífens (`-`) são convertidos para underscores (`_`)
   - Pontos (`.`) são convertidos para underscores (`_`)
   - Texto é convertido para UPPERCASE
   - Exemplo: `app.name` → `APP_NAME`

3. **Nomes de Parâmetros:**
   - Padrão: `/<tipo.configuracao>/<nome.aplicacao>/<chave>`
   - Exemplo: `/config/lab-a01-app-service-registry/app.name`

---

## 📝 Exemplo de Uso Completo

```bash
# 1. Configurar os arquivos de propriedades
# application-dev.properties
# application-hom.properties
# application-prod.properties

# 2. Configurar aws-parameter-config.properties
vim aws-parameter-config.properties

# 3. Executar o script principal
bash init.sh

# 4. Resultado: arquivos Terraform e .env gerados
# Enviar para o AWS usando terraform:
cd terraform
terraform init
terraform plan -var-file=inventories/dev/terraform.tfvars
terraform apply -var-file=inventories/dev/terraform.tfvars
```

---

## 🎯 Resumo do Fluxo

```
init.sh
├── generator-terraform-main.sh → Cria main.tf e variables.tf
├── generator-terraform-data.sh → Cria data.tf (data sources)
├── generator-terraform-local.sh → Cria locals.tf (variáveis locais)
├── generator-terraform-parameter-store.sh → Cria terraform.tfvars por ambiente
├── generator-variables-application.sh → Cria application.properties com ${VAR}
└── generator-variables-env.sh → Cria .env por ambiente
```

