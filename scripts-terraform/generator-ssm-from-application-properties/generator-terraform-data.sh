#!bin/sh

configuracaoInicial() {
  TIPOCONFIGURACAO=$( cat aws-parameter-config.properties |  grep tipo.configuracao | cut -d '=' -f 2)
#  APP=$(cat ../pom.xml | grep "<name>[a-zA-Z0-9]*" | sed "s/<name>//g" | sed "s/<\/name>//g" |  sed -e 's/^[ \t]*//')
  APP=$( cat aws-parameter-config.properties |  grep nome.aplicacao | cut -d '=' -f 2)
  ARQUIVO_PROPERTIES="application-dev.properties"

  if [ ! -d "./terraform" ]; then
    mkdir ./terraform
  fi
}

# ===== ESSES PROPERTIES DEVEM SER INFORMADOS MANUALMENTE
executeAmbientes() {
  PROPERTIES=$(cat ./$ARQUIVO_PROPERTIES | grep [a-zA-Z0-9.-]*=[a-zA-Z0-9#@^~\/._-]*)
  criarTerraformData
}

criarTerraformData() {

    echo "===== $ARQUIVO_PROPERTIES ======================"
    for PROPERTY in $PROPERTIES; do
      echo $PROPERTY
    done

    # Cria arquivo json para inserir propiedades em AWS Parameter
    touch ./terraform/data.tf
    PATH_CONFIGURATION_TFVAR="./terraform/data.tf"

    #LIMPA ARQUIVO
    echo "" > ${PATH_CONFIGURATION_TFVAR}

    # criar chaves valor
    echo "=========SALVANDO $ARQUIVO_PROPERTIES NO AWS PARAMETER======="
    for PROPERTY in $PROPERTIES; do
      KEY=$(echo $PROPERTY | cut -d "=" -f 1)
      VALUE=$(echo $PROPERTY | cut -d "=" -f 2)

      # IGNORA VARIAVEIS DE AMBIENTE NO PROPETIES
      if [[ $VALUE =~ ^\$\{[a-zA-Z0-9.-]*\} ]]; then
        echo "IGNORANDO VARIAVEL  $VALUE DO PROPERTIES $KEY"
        continue
      fi

      KEYPARAMETER=$(echo $KEY | sed "s/-/_/g" | sed "s/\./_/g" | tr "[:lower:]" "[:upper:]")
        if [ $VALUE ]; then
          NAME="/$TIPOCONFIGURACAO/$APP/$KEY"
          echo 'data "aws_ssm_parameter" "'${KEYPARAMETER}'" {
          name="'${NAME}'"
          }'

          echo 'data "aws_ssm_parameter" "'${KEYPARAMETER}'" {
                   name="'${NAME}'"
                   }' >> ${PATH_CONFIGURATION_TFVAR}
        fi

    done

    echo "" >> ${PATH_CONFIGURATION_TFVAR}

}

echo "===== BEGIN TERRAFORM DATA.TF======================================="
configuracaoInicial
executeAmbientes
echo "======END TERRAFORM DATA.TF==========================================="