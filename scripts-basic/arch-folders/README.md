# Script de Geração de Pastas - Arquitetura Limpa

## 📋 Descrição

Este script bash automatiza a criação de uma estrutura de pastas padronizada para implementar um projeto Java seguindo os princípios da **Arquitetura Limpa (Clean Architecture)**. Ele gera automaticamente todas as pastas necessárias para organizar o código de forma modular e mantível.

## 🎯 Objetivo

Criar uma estrutura de diretórios que separa as responsabilidades do projeto em camadas bem definidas, facilitando:
- A manutenção e evolução do código
- O entendimento da arquitetura por novos desenvolvedores
- A aplicação dos princípios SOLID
- O teste unitário e de integração

## 📁 Estrutura de Camadas Gerada

O script cria as seguintes camadas:

### 1. **Application** (`src/main/java/com/example/payment/application`)
Camada de aplicação contendo:

- **Domain**: Entidades e regras de negócio
  - `entity/`: Entidades do domínio
  - `enum/`: Enumerações de domínio
  - `gateway/`: Interfaces de contrato com outras camadas

- **UseCase**: Casos de uso da aplicação
  - `usecases/`: Definição dos casos de uso
  - `usecases/impl/`: Implementação dos casos de uso

### 2. **DataProvider** (`src/main/java/com/example/payment/dataprovider`)
Camada de acesso a dados e provedores externos:

- `repository/`: Implementação de repositórios
  - `entity/`: Entidades de persistência
- `service/`: Serviços de integração
  - `model/`: Modelos de dados
    - `input/`: DTOs de entrada
    - `output/`: DTOs de saída
- `mapper/`: Mapeadores entre entidades e DTOs

### 3. **Entrypoint** (`src/main/java/com/example/payment/entrypoint`)
Camada de entrada (APIs REST, Listeners, etc.):

- `controller/`: Controladores REST
- `listener/`: Listeners de eventos
- `model/`: Modelos de requisição e resposta
  - `request/`: DTOs de requisição
  - `response/`: DTOs de resposta

### 4. **Infrastructure** (`src/main/java/com/example/payment/infraestructure`)
Camada de infraestrutura:

- `exception/`: Definição e tratamento de exceções
  - `handler/`: Handlers customizados
- `configuration/`: Configurações da aplicação

## 🚀 Como Usar

### Pré-requisitos
- Sistema operacional Unix/Linux/macOS
- Bash shell disponível

### Executar o Script

```bash
# Tornar o script executável
chmod +x create-fouders-clean-arch.sh

# Executar
./create-fouders-clean-arch.sh
```

### Resultado
Após executar o script, uma estrutura de diretórios completa será criada sob `src/main/java/com/example/payment/`, pronta para iniciar o desenvolvimento.

## 📊 Exemplo da Estrutura Gerada

```
src/
└── main/
    └── java/
        └── com/example/payment/
            ├── application/
            │   ├── domain/
            │   │   ├── entity/
            │   │   ├── enum/
            │   │   └── gateway/
            │   └── usecases/
            │       └── impl/
            ├── dataprovider/
            │   ├── repository/
            │   │   └── entity/
            │   ├── service/
            │   │   └── model/
            │   │       ├── input/
            │   │       └── output/
            │   └── mapper/
            ├── entrypoint/
            │   ├── controller/
            │   ├── listener/
            │   └── model/
            │       ├── request/
            │       └── response/
            └── infraestructure/
                ├── exception/
                │   └── handler/
                └── configuration/
```

## 💡 Princípios de Arquitetura Limpa

Este script implementa uma estrutura baseada em:

- **Independência de Frameworks**: A lógica de negócio não depende de frameworks externos
- **Testabilidade**: Cada camada pode ser testada isoladamente
- **Independência de Interface de Usuário**: UI pode ser alterada sem afetar a lógica
- **Independência de Banco de Dados**: DB é apenas um detalhe de implementação
- **Independência de Agentes Externos**: A regra de negócio é isolada

## 🔧 Personalizando

Para adaptar o script para seu projeto, edite as seguintes variáveis:

- `com/example/payment/`: Substitua pelo seu `com.organization.project`

Exemplo:
```bash
# Altere:
src/main/java/com/example/payment/

# Para:
src/main/java/com/seuadmin/seuprojeto/
```

## 📝 Notas

- O script cria automaticamente pastas pai se não existirem (usando `mkdir -p`)
- Alguns comentários no script indicam pastas opcionais (com `#`)
- O script é idempotente: pode ser executado múltiplas vezes sem causar problemas

## 📖 Referências

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Clean Architecture in Java](https://www.baeldung.com/hexagonal-architecture-ddd-java)

---

**Versão**: 1.0  
**Último atualizado**: Janeiro de 2026
