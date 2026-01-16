# Scripts de Gerenciamento de Snaps

Este diretório contém scripts bash para automatizar a instalação e limpeza de aplicações via snap do Ubuntu.

## 📋 Arquivos

### `snaps-install.sh`
Script para **instalar aplicações via snap** listadas no arquivo `snaps.txt`.

**Funcionalidades:**
- Lê a lista de aplicações do arquivo `snaps.txt`
- Instala cada aplicação usando `sudo snap install`
- Ignora linhas vazias e comentários
- Remove espaços em branco das linhas
- Exibe mensagens de progresso com feedback visual
- Mostra um resumo final com contagem de sucessos e falhas

**Como usar:**
```bash
./snaps-install.sh
```

**Exemplo de saída:**
```
🚀 Iniciando instalação de aplicações via snap...
================================================
📦 Instalando: aws-cli
✅ aws-cli instalado com sucesso!
📦 Instalando: docker
✅ docker instalado com sucesso!
...
📊 Resumo da instalação:
   ✅ Instalados com sucesso: 12
   ❌ Falharam: 0
```

---

### `snaps-uninstall-disable.sh`
Script para **desinstalar e limpar snaps desabilitados** do sistema.

**Funcionalidades:**
- Lista todos os snaps desabilitados instalados
- Verifica quais snaps desabilitados não têm processos em execução
- Remove os snaps inativos com a flag `--purge` para limpeza completa
- Exibe o progresso da verificação e remoção

**Como usar:**
```bash
./snaps-uninstall-disable.sh
```

**O que faz:**
1. Obtém lista de snaps com status "disabled"
2. Extrai o nome e revisão de cada snap
3. Verifica se o processo está ativo com `pgrep`
4. Se inativo, remove o snap com `sudo snap remove --revision --purge`

---

### `snaps.txt`
Arquivo de texto contendo a **lista de aplicações a serem instaladas**.

**Formato:**
- Uma aplicação por linha
- Suporta comentários (linhas começando com `#`)
- Linhas vazias são ignoradas

**Exemplo de conteúdo:**
```
aws-cli
bashtop
docker
drawio
firefox
intellij-idea-community
libreoffice
terraform
zoom-client
```

---

## 🚀 Quick Start

1. **Editar lista de aplicações:**
   ```bash
   nano snaps.txt
   ```

2. **Instalar todas as aplicações:**
   ```bash
   ./snaps-install.sh
   ```

3. **Limpar snaps desabilitados (após alguns usos):**
   ```bash
   ./snaps-uninstall-disable.sh
   ```

---

## 📝 Notas

- Ambos os scripts requerem permissões de `sudo` para executar operações com snap
- O `snaps-install.sh` instalará as aplicações de forma interativa, podendo pedir confirmação
- O `snaps-uninstall-disable.sh` verifica processos antes de remover, evitando remover snaps em uso
- Para mais informações sobre snap, visite: https://snapcraft.io/docs

