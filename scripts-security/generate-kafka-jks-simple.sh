#!/bin/bash

set -e

# Diretório onde os arquivos .jks serão salvos
SECRETS_DIR="./secrets"

# Criar diretório se não existir
mkdir -p "$SECRETS_DIR"

echo "=== Script para gerar keystore e truststore para Kafka ==="

# Ler hostname (CN)
read -p "Digite o hostname do broker (ex: broker): " HOSTNAME
HOSTNAME=${HOSTNAME:-broker}

# Ler senhas
read -s -p "Digite a senha para o keystore: " KEYSTORE_PASS
echo
read -s -p "Digite a senha para a chave privada: " KEY_PASS
echo
read -s -p "Digite a senha para o truststore: " TRUSTSTORE_PASS
echo

# Nomes dos arquivos
KEYSTORE_FILE="$SECRETS_DIR/kafka.server.keystore.jks"
TRUSTSTORE_FILE="$SECRETS_DIR/kafka.server.truststore.jks"
CERT_FILE="$SECRETS_DIR/kafka-server.crt"

echo "Gerando keystore com chave privada e certificado autoassinado..."

keytool -genkeypair \
  -alias kafka-server \
  -keyalg RSA \
  -keysize 2048 \
  -validity 365 \
  -keystore "$KEYSTORE_FILE" \
  -dname "CN=$HOSTNAME, OU=Kafka, O=SuaEmpresa, L=SuaCidade, ST=SeuEstado, C=SeuPais" \
  -storepass "$KEYSTORE_PASS" \
  -keypass "$KEY_PASS"

echo "Exportando certificado do keystore..."

keytool -export \
  -alias kafka-server \
  -file "$CERT_FILE" \
  -keystore "$KEYSTORE_FILE" \
  -storepass "$KEYSTORE_PASS"

echo "Criando truststore e importando certificado..."

keytool -import \
  -alias kafka-server \
  -file "$CERT_FILE" \
  -keystore "$TRUSTSTORE_FILE" \
  -storepass "$TRUSTSTORE_PASS" \
  -noprompt

echo "Arquivos gerados com sucesso em $SECRETS_DIR:"
echo " - Keystore: $KEYSTORE_FILE"
echo " - Truststore: $TRUSTSTORE_FILE"
echo " - Certificado: $CERT_FILE"

echo
echo "Lembre-se de atualizar seu docker-compose.yml com as senhas usadas:"
echo "KAFKA_SSL_KEYSTORE_PASSWORD=$KEYSTORE_PASS"
echo "KAFKA_SSL_KEY_PASSWORD=$KEY_PASS"
echo "KAFKA_SSL_TRUSTSTORE_PASSWORD=$TRUSTSTORE_PASS"
