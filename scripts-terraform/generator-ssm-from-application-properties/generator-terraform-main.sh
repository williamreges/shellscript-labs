#!bin/sh

criarpastas() {
  if [ ! -d "./terraform" ]; then
    mkdir ./terraform
  fi
}

criarMain() {

 # CRIA ARQUIVO MAIN.TF
  echo "CRIANDO ARQUIVIO MAIN.TF"
  echo '' > ./terraform/main.tf
  echo 'terraform {
          required_providers {
            aws = {
              source  = "hashicorp/aws"
              version = "~> 5.0"
            }
          }
        }' >> ./terraform/main.tf

  echo 'provider "aws" {
          profile = var.profile
        }' >> ./terraform/main.tf

  #CRIANDO RESOUCE DE AWS PAREMETER STORE
  echo 'resource "aws_ssm_parameter" "parametersstore" {
          count = length(var.parametros)

          name  = var.parametros[count.index].name
          value = var.parametros[count.index].value
          type  = "String"
        }' >> ./terraform/main.tf

  # CRIA ARQUIVO VARIABLES.TF
  echo "CRIANDO ARQUIVIO VARIABLES.TF"
  echo '' > ./terraform/variables.tf
  echo 'variable "parametros" {
          type = list(object({
            name             = string
            value            = string
            microservicename = string
          }))
        }' >> ./terraform/variables.tf

   echo 'variable profile {
           type = string
         }' >> ./terraform/variables.tf

}

echo "===== BEGIN TERRAFORM PARAMETER STORE======================================="
criarpastas
criarMain
echo "======END TERRAFORM PARAMETER STORE==========================================="