#!bin/sh

init() {
    bash generator-terraform-main.sh
    bash generator-terraform-data.sh
    bash generator-terraform-local.sh
    bash generator-terraform-parameter-store.sh
    bash generator-variables-application.sh
    bash generator-variables-env.sh

}
echo '=========== INICIANDO CRIAÇÃO RECURSOS======================================='

init

echo '=========== FIM DE CRIAÇÃO DE RECURSOS======================================='