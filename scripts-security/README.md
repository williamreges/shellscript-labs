#  🔐 Gerar Keystore e Truststore para Broker Kafka e Cliente para Docker Compose

Para gerar os arquivos .jks (Java KeyStore) necessários para a configuração do Kafka SSL no seu serviço, 
você precisa criar um armazenamento de chaves e uma truststore para seu Docker Compose. Esses arquivos contêm a chave privada e o certificado do 
servidor (keystore) e os certificados confiáveis (truststore), respectivamente.

## Explicação rápida do que o script faz:
- Gera um keystore e certificado autoassinado para o broker.
- Gera um keystore e certificado autoassinado para o cliente.
- Exporta os certificados públicos.
- Importa o certificado do cliente no truststore do broker (para que o broker confie no cliente).
- Importa o certificado do broker no truststore do cliente (para que o cliente confie no broker).
- Assim, a autenticação mútua SSL pode funcionar corretamente.
---

## 1. Explicação do Bash

Aqui está uma versão detalhada do script Bash [generate-kafka-jks.sh](generate-kafka-jks.sh) que automatiza a geração dos keystores e
truststores para o broker Kafka **e** para um cliente Kafka, incluindo certificados autoassinados para ambos. O
script gera:
- Keystore e truststore do broker
- Keystore e truststore do cliente
- Importa os certificados adequadamente para permitir autenticação mútua SSL


```bash
#!/bin/bash
set -e
SECRETS_DIR="./secrets"
mkdir -p "$SECRETS_DIR"
echo "=== Script para gerar keystores e truststores para Kafka Broker e Cliente ==="
````

### 1.1. Entrada de dados para broker

```bash
read -p "Digite o hostname do broker (ex: broker): " BROKER_HOSTNAME
BROKER_HOSTNAME=${BROKER_HOSTNAME:-broker}
read -s -p "Digite a senha para o keystore do broker: " BROKER_KEYSTORE_PASS
echo
read -s -p "Digite a senha para a chave privada do broker: " BROKER_KEY_PASS
echo
read -s -p "Digite a senha para o truststore do broker: " BROKER_TRUSTSTORE_PASS
echo
```

### 1.2 Entrada de dados para cliente

```bash
read -p "Digite o nome do cliente (ex: kafka-client): " CLIENT_NAME
CLIENT_NAME=${CLIENT_NAME:-kafka-client}
read -s -p "Digite a senha para o keystore do cliente: " CLIENT_KEYSTORE_PASS
echo
read -s -p "Digite a senha para a chave privada do cliente: " CLIENT_KEY_PASS
echo
read -s -p "Digite a senha para o truststore do cliente: " CLIENT_TRUSTSTORE_PASS
echo
```

### 1.3 Arquivos do broker

```bash
BROKER_KEYSTORE="$SECRETS_DIR/kafka.server.keystore.jks"
BROKER_TRUSTSTORE="$SECRETS_DIR/kafka.server.truststore.jks"
BROKER_CERT="$SECRETS_DIR/kafka-server.crt"
```

### 1.4 Arquivos do cliente

```bash
CLIENT_KEYSTORE="$SECRETS_DIR/$CLIENT_NAME.keystore.jks"
CLIENT_TRUSTSTORE="$SECRETS_DIR/$CLIENT_NAME.truststore.jks"
CLIENT_CERT="$SECRETS_DIR/$CLIENT_NAME.crt"
```

### 1.5 Gerando keystore do broker com chave privada e certificado autoassinado
```bash
keytool -genkeypair \
-alias kafka-server \
-keyalg RSA \
-keysize 2048 \
-validity 365 \
-keystore "$BROKER_KEYSTORE" \
-dname "CN=$BROKER_HOSTNAME, OU=Kafka, O=SuaEmpresa, L=SuaCidade, ST=SeuEstado, C=SeuPais" \
-storepass "$BROKER_KEYSTORE_PASS" \
-keypass "$BROKER_KEY_PASS"
```

### 1.5 Exportando certificado do broker
```bash
keytool -export \
-alias kafka-server \
-file "$BROKER_CERT" \
-keystore "$BROKER_KEYSTORE" \
-storepass "$BROKER_KEYSTORE_PASS"
```

### 1.6 Gerando keystore do cliente com chave privada e certificado autoassinado

```bash
keytool -genkeypair \
-alias $CLIENT_NAME \
-keyalg RSA \
-keysize 2048 \
-validity 365 \
-keystore "$CLIENT_KEYSTORE" \
-dname "CN=$CLIENT_NAME, OU=Kafka, O=SuaEmpresa, L=SuaCidade, ST=SeuEstado, C=SeuPais" \
-storepass "$CLIENT_KEYSTORE_PASS" \
-keypass "$CLIENT_KEY_PASS"
```

### 1.7 Exportando certificado do cliente
```bash
keytool -export \
-alias $CLIENT_NAME \
-file "$CLIENT_CERT" \
-keystore "$CLIENT_KEYSTORE" \
-storepass "$CLIENT_KEYSTORE_PASS"
```

### 1.8 Criando truststore do broker e importando certificado do cliente
```bash
keytool -import \
-alias $CLIENT_NAME \
-file "$CLIENT_CERT" \
-keystore "$BROKER_TRUSTSTORE" \
-storepass "$BROKER_TRUSTSTORE_PASS" \
-noprompt
```

### 1.9 Criando truststore do cliente e importando certificado do broker
```bash
keytool -import \
-alias kafka-server \
-file "$BROKER_CERT" \
-keystore "$CLIENT_TRUSTSTORE" \
-storepass "$CLIENT_TRUSTSTORE_PASS" \
-noprompt
```
### 1.10 Informações de Variávies para colocar o Docker Compose
```bash
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
```

## Como usar
1. Salve o script acima como `generate-kafka-jks.sh`.
2. Dê permissão de execução: `chmod +x generate-kafka-jks.sh`
3. Execute o script:
   `./generate-kafka-jks.sh`
4. Informe os dados solicitados (hostnames, nomes e senhas).
5. Os arquivos `.jks` e `.crt` serão gerados na pasta `./secrets`.
6. Monte essa pasta no container Kafka conforme seu `docker-compose.yml`.
7. Configure o cliente Kafka para usar seu keystore e truststore para autenticação SSL.


```docker
environment
    KAFKA_SSL_KEYSTORE_LOCATION=/etc/security/tls/kafka.server.keystore.jks
    KAFKA_SSL_KEYSTORE_PASSWORD=123456
    KAFKA_SSL_KEY_PASSWORD=123456
    KAFKA_SSL_TRUSTSTORE_LOCATION=/etc/security/tls/kafka.server.truststore.jks
    KAFKA_SSL_TRUSTSTORE_PASSWORD=123456
    KAFKA_SSL_CLIENT_AUTH=required
```

#  🔐 2. Configuração de Clientes KAFKA

---
##  Pré-requisitos
- Você já possui os arquivos `.jks` do cliente:
- **Keystore do cliente** (contém a chave privada e certificado do cliente): `client.keystore.jks`
- **Truststore do cliente** (contém o certificado do broker para confiar nele): `client.truststore.jks`
- O broker Kafka está configurado para SSL e autenticação mútua, conforme seu `docker-compose.yml`.
---
##  Configuração do cliente Kafka Java
No cliente Java, você deve configurar as propriedades SSL para que o cliente use os arquivos `.jks` para
autenticação e para confiar no broker.
Exemplo de configuração em código Java (usando `Properties`):

```java
Properties props = new Properties();
props.put("bootstrap.servers", "broker:9093"); // Porta SSL do broker
props.put("security.protocol", "SSL");
// Configurações do keystore do cliente (contém chave privada e certificado)
props.put("ssl.keystore.location", "/caminho/para/client.keystore.jks");
props.put("ssl.keystore.password", "senha_keystore_cliente");
props.put("ssl.key.password", "senha_chave_privada_cliente");
// Configurações do truststore do cliente (contém certificado do broker)
props.put("ssl.truststore.location", "/caminho/para/client.truststore.jks");
props.put("ssl.truststore.password", "senha_truststore_cliente");
// Outras configurações do consumidor ou produtor
props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
// Exemplo para produtor
KafkaProducer<String, String> producer = new KafkaProducer<>(props);
```

---
##  Configuração do cliente Kafka via arquivo `client.properties`
Você pode criar um arquivo `client.properties` para usar com ferramentas Kafka (como `kafka-console-producer.sh`
ou `kafka-console-consumer.sh`):

```properties
bootstrap.servers=broker:9093
security.protocol=SSL
ssl.keystore.location=/caminho/para/client.keystore.jks
ssl.keystore.password=senha_keystore_cliente
ssl.key.password=senha_chave_privada_cliente
ssl.truststore.location=/caminho/para/client.truststore.jks
ssl.truststore.password=senha_truststore_cliente

```

Exemplo de uso com `kafka-console-producer.sh`:

```bash
kafka-console-producer.sh --broker-list broker:9093 --topic seu-topico --producer.config client.properties
```

> ## Observações importantes
> - **Caminhos dos arquivos**: Certifique-se de que os arquivos `.jks` estejam acessíveis no cliente, e os caminhos
  estejam corretos.
> - **Senhas**: Use as mesmas senhas que você definiu ao gerar os keystores e truststores.
> - **Segurança**: Nunca exponha senhas em texto puro em produção; use variáveis de ambiente ou gerenciadores
 de segredo.
> - **Hostname e CN**: O `CN` do certificado do broker deve corresponder ao hostname usado na conexão (`broker`
  no exemplo).
> - **Porta SSL**: Use a porta configurada para SSL no broker (`9093` no seu caso).
---
## Exemplo completo de propriedades para cliente Java

```properties
bootstrap.servers=broker:9093
security.protocol=SSL
ssl.keystore.location=/home/usuario/secrets/client.keystore.jks
ssl.keystore.password=clientKeystorePass
ssl.key.password=clientKeyPass
ssl.truststore.location=/home/usuario/secrets/client.truststore.jks
ssl.truststore.password=clientTruststorePass

```
---