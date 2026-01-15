#!bin/sh

configuracaoInicial() {
  TIPOCONFIGURACAO=$( cat aws-parameter-config.properties |  grep tipo.configuracao | cut -d '=' -f 2)
#  APP=$(cat ../pom.xml | grep "<name>[a-zA-Z0-9]*" | sed "s/<name>//g" | sed "s/<\/name>//g" |  sed -e 's/^[ \t]*//')
  APP=$( cat aws-parameter-config.properties |  grep nome.aplicacao | cut -d '=' -f 2)

  ARQUIVO_PROPERTIES_DES="application-dev.properties"
  ARQUIVO_PROPERTIES_HOM="application-hom.properties"
  ARQUIVO_PROPERTIES_PROD="application-prod.properties"

  if [ ! -d "./env" ]; then
   mkdir ./env
  fi
}

executeAmbientes() {
  for AMBIENTE in $ARQUIVO_PROPERTIES_DES $ARQUIVO_PROPERTIES_HOM $ARQUIVO_PROPERTIES_PROD; do
    echo "===== AMBIENTE $AMBIENTE ======================"
    ARQUIVO_PROPERTIES=$AMBIENTE
    PROPERTIES=$(cat ./$ARQUIVO_PROPERTIES | grep [a-zA-Z0-9.-]*=[a-zA-Z0-9#@^~\/._-]*)
    criarArquivosEnv
  done
}

criarArquivosEnv() {

  echo "===== $ARQUIVO_PROPERTIES ======================"
  for PROPERTY in $PROPERTIES; do
    echo $PROPERTY
  done

  # Cria arquivo json para inserir propiedades em AWS Parameter
  touch ./env/$AMBIENTE.env
  PATH_CONFIGURATION_TFVAR="./env/${AMBIENTE}.env"

  #LIMPA ARQUIVO
  echo "" > ${PATH_CONFIGURATION_TFVAR}

  # criar chaves valor
  echo "=========GERANDO NOVO ARQUIVO $ARQUIVO_PROPERTIES ======="
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
      echo "${KEYPARAMETER}=${VALUE}"
      echo "${KEYPARAMETER}=${VALUE}" >> ${PATH_CONFIGURATION_TFVAR}
    fi

  done

  echo "" >> ${PATH_CONFIGURATION_TFVAR}

}

echo "===== BEGIN - GERAR ARQUIVOS .ENV======================================="
configuracaoInicial
executeAmbientes
echo "====== END - ARQUVOS .ENV CRIADOS==========================================="