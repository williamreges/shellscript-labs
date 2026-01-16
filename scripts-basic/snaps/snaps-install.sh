#!/bin/bash

# Script para instalar aplicações via snap do Ubuntu
# Lê a lista de aplicações do arquivo snaps.txt e instala cada uma

SNAP_LIST_FILE="snaps.txt"
INSTALLED_COUNT=0
FAILED_COUNT=0

# Verifica se o arquivo existe
if [ ! -f "$SNAP_LIST_FILE" ]; then
    echo "❌ Erro: Arquivo '$SNAP_LIST_FILE' não encontrado!"
    exit 1
fi

echo "🚀 Iniciando instalação de aplicações via snap..."
echo "================================================"

# Lê cada linha do arquivo
while IFS= read -r snap_app; do
    # Remove espaços em branco
    snap_app=$(echo "$snap_app" | xargs)
    
    # Ignora linhas vazias e comentários
    if [ -z "$snap_app" ] || [[ "$snap_app" =~ ^# ]]; then
        continue
    fi
    
    echo ""
    echo "📦 Instalando: $snap_app"
    
    # Tenta instalar o snap
    if sudo snap install "$snap_app" 2>/dev/null; then
        echo "✅ $snap_app instalado com sucesso!"
        ((INSTALLED_COUNT++))
    else
        echo "❌ Erro ao instalar $snap_app"
        ((FAILED_COUNT++))
    fi
done < "$SNAP_LIST_FILE"

echo ""
echo "================================================"
echo "📊 Resumo da instalação:"
echo "   ✅ Instalados com sucesso: $INSTALLED_COUNT"
echo "   ❌ Falharam: $FAILED_COUNT"
echo "================================================"

exit 0
