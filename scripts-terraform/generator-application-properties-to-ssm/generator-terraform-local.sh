#!bin/sh

configuracaoInicial() {
  TIPOCONFIGURACAO=$( cat aws-parameter-config.properties |  grep tipo.configuracao | cut -d '=' -f 2)
  APP=$(cat ../pom.xml | grep "<name>[a-zA-Z0-9]*" | sed "s/<name>//g" | sed "s/<\/name>//g" |  sed -e 's/^[ \t]*//')
  ARQUIVO_PROPERTIES="application-dev.properties"

  if [ ! -d "./terraform" ]; then
    mkdir ./terraform
  fi
}

# ===== ESSES PROPERTIES DEVEM SER INFORMADOS MANUALMENTE
executeAmbientes() {
  PROPERTIES=$(cat ./$ARQUIVO_PROPERTIES | grep [a-zA-Z0-9.-]*=*)
  criarArquivoTerraformLocal
}

criarArquivoTerraformLocal() {

    echo "===== $ARQUIVO_PROPERTIES ======================"
    for PROPERTY in $PROPERTIES; do
      echo $PROPERTY
    done

    # Cria arquivo json para inserir propiedades em AWS Parameter
    touch ./terraform/locals.tf
    PATH_CONFIGURATION_TFVAR="./terraform/locals.tf"

    #LIMPA ARQUIVO
    echo "locals {
    task_env_vars = [" > ${PATH_CONFIGURATION_TFVAR}

    # criar chaves valor
    echo "=========SALVANDO $ARQUIVO_PROPERTIES NO AWS PARAMETER======="
    for PROPERTY in $PROPERTIES; do
      KEY=$(echo $PROPERTY | cut -d "=" -f 1)
      VALUE=$(echo $PROPERTY | cut -d "=" -f 2)

      if [[ $VALUE =~ ^\$\{[a-zA-Z0-9.-]*\} ]]; then
        echo "IGNORANDO VARIAVEL  $VALUE DO PROPERTIES $KEY"
        continue
      fi

      KEYPARAMETER=$(echo $KEY | sed "s/-/_/g" | sed "s/\./_/g" | tr "[:lower:]" "[:upper:]")

        if [ $VALUE ]; then
          NAME="/$TIPOCONFIGURACAO/$APP/$KEY"
          echo '{
          name: "'${KEYPARAMETER}'",
          value: data.aws_ssm_parameter.'${KEYPARAMETER}'.value
                  }'

          echo '{
          name: "'${KEYPARAMETER}'",
          value: data.aws_ssm_parameter.'${KEYPARAMETER}'.value
                  },' >> ${PATH_CONFIGURATION_TFVAR}
        fi

    done

    sed -i '$ s/.$//' ${PATH_CONFIGURATION_TFVAR}

    echo "] }" >> ${PATH_CONFIGURATION_TFVAR}

}

echo "===== BEGIN TERRAFORM LOCAL.TF= ======================================="
configuracaoInicial
executeAmbientes
echo "======END TERRAFORM LOCAL.TF============================================"