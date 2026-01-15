#!bin/sh

configuracaoInicial() {
  TIPOCONFIGURACAO=$( cat aws-parameter-config.properties |  grep tipo.configuracao | cut -d '=' -f 2)
#  APP=$(cat ../pom.xml | grep "<name>[a-zA-Z0-9]*" | sed "s/<name>//g" | sed "s/<\/name>//g" |  sed -e 's/^[ \t]*//')
  APP=$( cat aws-parameter-config.properties |  grep nome.aplicacao | cut -d '=' -f 2)

  ARQUIVO_PROPERTIES_DES="application-dev.properties"
  ARQUIVO_PROPERTIES_HOM="application-hom.properties"
  ARQUIVO_PROPERTIES_PROD="application-prod.properties"

  if [ ! -d "./terraform" ]; then
    mkdir ./terraform
  fi

  if [ ! -d "./terraform/inventories" ]; then
    mkdir ./terraform/inventories
  fi
}

executeAmbientes() {
  for AMBIENTE in $ARQUIVO_PROPERTIES_DES $ARQUIVO_PROPERTIES_HOM $ARQUIVO_PROPERTIES_PROD; do
    echo "===== AMBIENTE $AMBIENTE ======================"
    ARQUIVO_PROPERTIES=$AMBIENTE
    INVENTORIE=$(echo $AMBIENTE | sed "s/application-//g" | sed "s/.properties//g")
    PROPERTIES=$(cat ./$ARQUIVO_PROPERTIES | grep [a-zA-Z0-9.-]*=[a-zA-Z0-9#@^~\/._-]*)
    criarArquivoTerraformAwsParameter
  done
}

criarArquivoTerraformAwsParameter() {

  echo "=====VIEW DE $ARQUIVO_PROPERTIES ======================"
  for PROPERTY in $PROPERTIES; do
    echo $PROPERTY
  done

  if [ ! -d "./terraform/inventories/$INVENTORIE" ]; then
    mkdir ./terraform/inventories/$INVENTORIE
  fi

  PATH_CONFIGURATION_TFVAR="./terraform/inventories/$INVENTORIE/terraform.tfvars"

  #LIMPA ARQUIVO
  echo "parametros = [" > ${PATH_CONFIGURATION_TFVAR}

  # criar chaves valor
  echo "=========SALVANDO $ARQUIVO_PROPERTIES NO AWS PARAMETER======="
  for PROPERTY in $PROPERTIES; do
    KEY=$(echo $PROPERTY | cut -d "=" -f 1)
    VALUE=$(echo $PROPERTY | cut -d "=" -f 2)

      if [ $VALUE ]; then

        # IGNORA VARIAVEIS DE AMBIENTE NO PROPETIES
        if [[ $VALUE =~ ^\$\{[a-zA-Z0-9.-]*\} ]]; then
          echo "IGNORANDO VARIAVEL  $VALUE DO PROPERTIES $KEY"
          continue
        fi

        NAME="/$TIPOCONFIGURACAO/$APP/$KEY"
       echo '{
       name="'${NAME}'"
       value="'${VALUE}'"
       microservicename="'${APP}'"
       }'
  #
       echo '{
       name="'${NAME}'"
       value="'${VALUE}'"
       microservicename="'${APP}'"
       },' >> ${PATH_CONFIGURATION_TFVAR}
      fi

  done

  sed -i '$ s/.$//' ${PATH_CONFIGURATION_TFVAR}

  echo "]" >> ${PATH_CONFIGURATION_TFVAR}

}

echo "===== BEGIN - TERRAFORM PARAMETER STORE======================================="
configuracaoInicial
executeAmbientes
echo "======END - TERRAFORM PARAMETER STORE==========================================="