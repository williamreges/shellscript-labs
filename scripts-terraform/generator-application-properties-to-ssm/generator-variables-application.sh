#!bin/sh

configuracaoInicial() {
  TIPOCONFIGURACAO=$( cat aws-parameter-config.properties |  grep tipo.configuracao | cut -d '=' -f 2)
  APP=$(cat ../pom.xml | grep "<name>[a-zA-Z0-9]*" | sed "s/<name>//g" | sed "s/<\/name>//g" |  sed -e 's/^[ \t]*//')
  ARQUIVO_PROPERTIES="application-dev.properties"

  if [ ! -d "./env" ]; then
    mkdir ./env
  fi
}

# ===== ESSES PROPERTIES DEVEM SER INFORMADOS MANUALMENTE
executeAmbientes() {
  PROPERTIES=$(cat ./$ARQUIVO_PROPERTIES | grep [a-zA-Z0-9.-]*=*)
  criarApplicationPropertiesComVariaveis
}

criarApplicationPropertiesComVariaveis() {

    echo "===== $ARQUIVO_PROPERTIES ======================"
    for PROPERTY in $PROPERTIES; do
      echo $PROPERTY
    done

    # Cria arquivo json para inserir propiedades em AWS Parameter
    touch ./env/application.properties
    PATH_CONFIGURATION_TFVAR="./env/application.properties"

    #LIMPA ARQUIVO
    echo "" > ${PATH_CONFIGURATION_TFVAR}

    # criar chaves valor
    echo "=========GERANDO NOVO ARQUIVO $ARQUIVO_PROPERTIES ======="
    for PROPERTY in $PROPERTIES; do
      KEY=$(echo $PROPERTY | cut -d "=" -f 1)
      VALUE=$(echo $PROPERTY | cut -d "=" -f 2)

      KEYPARAMETER=""

      # VALIDA SE A VARIAVEL É UMA VARIAVEL DE AMBIENTE DO PROPERTIES
      if [[ $VALUE =~ ^\$\{[a-zA-Z0-9.-]*\} ]]; then
         KEYPARAMETER=$VALUE
      else
         KEYPARAMETER="\${$(echo $KEY | sed "s/-/_/g" | sed "s/\./_/g" | tr "[:lower:]" "[:upper:]")}"
      fi

      if [ $VALUE ]; then
        echo "${KEY}=${KEYPARAMETER}"
        echo "${KEY}=${KEYPARAMETER}" >> ${PATH_CONFIGURATION_TFVAR}
      fi

    done

    echo "" >> ${PATH_CONFIGURATION_TFVAR}

}

echo "===== BEGIN - Criar Applicaiton.properties com Environment======================================="
configuracaoInicial
executeAmbientes
echo "====== END - Applicaiton.properties com Environment criado==========================================="