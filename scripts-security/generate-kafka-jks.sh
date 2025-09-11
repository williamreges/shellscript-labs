#!/bin/bash

set -e

SECRETS_DIR="./secrets"
mkdir -p "$SECRETS_DIR"

echo "=== Script para gerar keystores e truststores para Kafka Broker e Cliente ==="

# Entrada de dados para broker
read -p "Digite o hostname do broker (ex: broker): " BROKER_HOSTNAME
BROKER_HOSTNAME=${BROKER_HOSTNAME:-broker}

read -s -p "Digite a senha para o keystore do broker: " BROKER_KEYSTORE_PASS
echo
read -s -p "Digite a senha para a chave privada do broker: " BROKER_KEY_PASS
echo
read -s -p "Digite a senha para o truststore do broker: " BROKER_TRUSTSTORE_PASS
echo

# Entrada de dados para cliente
read -p "Digite o nome do cliente (ex: kafka-client): " CLIENT_NAME
CLIENT_NAME=${CLIENT_NAME:-kafka-client}

read -s -p "Digite a senha para o keystore do cliente: " CLIENT_KEYSTORE_PASS
echo
read -s -p "Digite a senha para a chave privada do cliente: " CLIENT_KEY_PASS
echo
read -s -p "Digite a senha para o truststore do cliente: " CLIENT_TRUSTSTORE_PASS
echo

# Arquivos do broker
BROKER_KEYSTORE="$SECRETS_DIR/kafka.server.keystore.jks"
BROKER_TRUSTSTORE="$SECRETS_DIR/kafka.server.truststore.jks"
BROKER_CERT="$SECRETS_DIR/kafka-server.crt"

# Arquivos do cliente
CLIENT_KEYSTORE="$SECRETS_DIR/$CLIENT_NAME.keystore.jks"
CLIENT_TRUSTSTORE="$SECRETS_DIR/$CLIENT_NAME.truststore.jks"
CLIENT_CERT="$SECRETS_DIR/$CLIENT_NAME.crt"

echo "Gerando keystore do broker com chave privada e certificado autoassinado..."

keytool -genkeypair \
  -alias kafka-server \
  -keyalg RSA \
  -keysize 2048 \
  -validity 365 \
  -keystore "$BROKER_KEYSTORE" \
  -storepass "$BROKER_KEYSTORE_PASS" \
  -dname "CN=$BROKER_HOSTNAME, OU=Kafka, O=SuaEmpresa, L=SuaCidade, ST=SeuEstado, C=SeuPais" \
  -keypass "$BROKER_KEY_PASS"

echo "Exportando certificado do broker..."

keytool -export \
  -alias kafka-server \
  -file "$BROKER_CERT" \
  -keystore "$BROKER_KEYSTORE" \
  -storepass "$BROKER_KEYSTORE_PASS"

echo "Gerando keystore do cliente com chave privada e certificado autoassinado..."

keytool -genkeypair \
  -alias $CLIENT_NAME \
  -keyalg RSA \
  -keysize 2048 \
  -validity 365 \
  -keystore "$CLIENT_KEYSTORE" \
  -storepass "$CLIENT_KEYSTORE_PASS" \
  -dname "CN=$CLIENT_NAME, OU=Kafka, O=SuaEmpresa, L=SuaCidade, ST=SeuEstado, C=SeuPais" \
  -keypass "$CLIENT_KEY_PASS"

echo "Exportando certificado do cliente..."
keytool -export \
  -alias $CLIENT_NAME \
  -file "$CLIENT_CERT" \
  -keystore "$CLIENT_KEYSTORE" \
  -storepass "$CLIENT_KEYSTORE_PASS"

echo "Criando truststore do broker e importando certificado do cliente..."
keytool -import \
  -alias $CLIENT_NAME \
  -file "$CLIENT_CERT" \
  -keystore "$BROKER_TRUSTSTORE" \
  -storepass "$BROKER_TRUSTSTORE_PASS" \
  -noprompt

echo "Criando truststore do cliente e importando certificado do broker..."
keytool -import \
  -alias kafka-server \
  -file "$BROKER_CERT" \
  -keystore "$CLIENT_TRUSTSTORE" \
  -storepass "$CLIENT_TRUSTSTORE_PASS" \
  -noprompt

echo
echo "Arquivos gerados em $SECRETS_DIR:"
echo "Broker:"
echo " - Keystore: $BROKER_KEYSTORE"
echo " - Truststore: $BROKER_TRUSTSTORE"
echo " - Certificado: $BROKER_CERT"
echo
echo "Cliente:"
echo " - Keystore: $CLIENT_KEYSTORE"
echo " - Truststore: $CLIENT_TRUSTSTORE"
echo " - Certificado: $CLIENT_CERT"
echo
echo "Lembre-se de configurar as variáveis de ambiente no docker-compose para o broker:"
echo "KAFKA_SSL_KEYSTORE_LOCATION=/etc/security/tls/kafka.server.keystore.jks"
echo "KAFKA_SSL_KEYSTORE_PASSWORD=$BROKER_KEYSTORE_PASS"
echo "KAFKA_SSL_KEY_PASSWORD=$BROKER_KEY_PASS"
echo "KAFKA_SSL_TRUSTSTORE_LOCATION=/etc/security/tls/kafka.server.truststore.jks"
echo "KAFKA_SSL_TRUSTSTORE_PASSWORD=$BROKER_TRUSTSTORE_PASS"
echo "KAFKA_SSL_CLIENT_AUTH=required"
echo
echo "E para o cliente, configure o keystore e truststore correspondentes com as senhas usadas."
