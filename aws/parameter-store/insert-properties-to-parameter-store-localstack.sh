#!bin/sh

configureEnvironmentAWSFunction() {
  TIPOCONFIGURACAO=$( cat aws-parameter-config.properties |  grep tipo.configuracao | cut -d '=' -f 2)
  APP=$( cat aws-parameter-config.properties |  grep nome.projeto | cut -d '=' -f 2)
  ARQUIVO_PROPERTIES=$(cat aws-parameter-config.properties |  grep nome.arquivo.properties | cut -d '=' -f 2)
}

# ===== ESSES PROPERTIES DEVEM SER INFORMADOS MANUALMENTE
getApplicationPropertiesFunction() {
  PROPERTIES=$(cat ./$ARQUIVO_PROPERTIES | grep [a-zA-Z0-9.-]*=*)
}

executeInsertAwsParameterFunction() {

    echo "===== $ARQUIVO_PROPERTIES ======================"
    for PROPERTY in $PROPERTIES; do
      echo $PROPERTY
    done

    # Insere propiedades em AWS Parameter
    echo "=========SALVANDO $ARQUIVO_PROPERTIES NO AWS PARAMETER======="
    for PROPERTY in $PROPERTIES; do
      KEY=$(echo $PROPERTY | cut -d "=" -f 1)
      VALUE=$(echo $PROPERTY | cut -d "=" -f 2)

  if [ $VALUE ]; then

      # Tipo de config + Nome do app + chave do properties
        NAME="/$TIPOCONFIGURACAO/$APP/$KEY"
        echo "Insert Parameter: ${NAME}"

        # Insere Parametro no AWS Parameter na conta AWS
        aws ssm put-parameter \
        --cli-input-json '{"Name": "'${NAME}'", "Value": "'${VALUE}'", "Type": "String"}' \
        --overwrite \
        --endpoint-url=http://localhost:4566

        # Visualizar Parametro no AWS Parameter na conta AWS
         aws ssm get-parameter \
         --cli-input-json '{"Name": "'${NAME}'"}' \
         --endpoint-url=http://localhost:4566

  fi

done

}

echo "===== BEGIN ======================================="

configureEnvironmentAWSFunction

getApplicationPropertiesFunction

executeInsertAwsParameterFunction

echo "======END==========================================="
