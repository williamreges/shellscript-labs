#!/bin/bash

#===== atualização do sistema operacional =======
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt autoclean && sudo apt clean && sudo apt list --upgradable


#======= Instalação do google chrome =============
#sudo apt-get purge google-chrome-stable 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads && sudo apt install ~/Downloads/google-chrome-stable_current_amd64.deb -y && rm ~/Downloads/google-chrome-stable_current_amd64.deb


#======= Criando pastas padrao das ferramentas ====
sudo mkdir -p ~/Documentos/Ferramentas && sudo chmod 777 ~/Documentos/Ferramentas


#============ Ferramentas de Versão e Dependencia ===============
#instalação do Git:
#sudo apt-get purge git 
sudo apt install git -y

#Instalando Maven
sudo wget https://www-eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz -P ~/Downloads &&  sudo tar -xzvf ~/Downloads/apache-maven-3.6.0-bin.tar.gz -C ~/Documentos/Ferramentas && sudo chmod 777 ~/Documentos/Ferramentas/apache-maven-3.6.0 && sudo rm -rf ~/Downloads/apache-maven-3.6.0-bin.tar.gz


#===========  Instalando Java 8 Oracle =============
#sudo apt-get purge oracle-java8-installer 
#sudo add-apt-repository ppa:webupd8team/java -y && sudo apt update && sudo apt install oracle-java8-installer -y

#instalando jdk8
#sudo apt-get purge openjdk-8-jdk -y
sudo add-apt-repository ppa:openjdk-r/ppa && sudo apt-get update && sudo apt-get install openjdk-8-jdk -y


#==== Dowload das ferramentas de desenvolvimento ========
#Intelij
sudo wget https://download.jetbrains.com/idea/ideaIC-2018.3.2.tar.gz -P ~/Downloads && tar -vzxf ~/Downloads/ideaIC-2018.3.2.tar.gz -C ~/Documentos/Ferramentas && sudo  rm -rf ~/Downloads/ideaIC-2018.3.2.tar.gz


#Instalando Smartgit
sudo wget https://www.syntevo.com/downloads/smartgit/smartgit-linux-18_2_3.tar.gz -P ~/Downloads && sudo tar -zvxf ~/Downloads/smartgit-linux-18_2_3.tar.gz -C ~/Documentos/Ferramentas/ && ~/Documentos/Ferramentas/smartgit/bin/add-menuitem.sh && sudo chmod 777 ~/Documentos/Ferramentas/smartgit && sudo rm -rf ~/Downloads/smartgit*.tar.gz

#Dbeaver
wget https://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb -P ~/Downloads && sudo apt-get install ~/Downloads/dbeaver-ce_latest_amd64.deb -y && rm ~/Downloads/dbeaver-ce_latest_amd64.deb

#Postman
sudo wget https://dl.pstmn.io/download/latest/linux64 -P ~/Downloads && sudo tar -vzxf ~/Downloads/linux64 -C ~/Documentos/Ferramentas && sudo chmod 777 ~/Documentos/Ferramentas/Postman && sudo rm -rf ~/Downloads/linux64

#Instalando Visual Studio
sudo wget https://az764295.vo.msecnd.net/stable/dea8705087adb1b5e5ae1d9123278e178656186a/code_1.30.1-1545156774_amd64.deb -P ~/Downloads && sudo chmod 777 ~/Downloads/code_1.30.1-1545156774_amd64.deb && sudo apt-get install ~/Downloads/code_1.30.1-1545156774_amd64.deb && rm -rf ~/Downloads/code_1.30.1-1545156774_amd64.deb

#Node Js
sudo apt-get install nodejs

#NPM
sudo apt-get install npm

#Instalando Yarn
sudo apt-get update && sudo apt-get install yarn

#Instalação do Slack
sudo wget https://downloads.slack-edge.com/linux_releases/slack-desktop-3.3.3-amd64.deb -P ~/Downloads/ && sudo chmod 777 ~/Downloads/slack-desktop-3.3.3-amd64.deb&& sudo apt-get install ~/Downloads/slack-desktop-3.3.3-amd64.deb && sudo rm -rf ~/Downloads/slack-desktop-3.3.3-amd64.deb

#Instalando Terminal Tilix
sudo add-apt-repository ppa:webupd8team/terminix -y && sudo apt update && sudo apt install tilix -y

#Instalando Alacarte para criar Icone desktop
sudo apt install alacarte -y

#Instalando Maven 3.5.3
sudo wget https://www-eu.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz -P ~/Downloads &&  sudo tar -xzvf ~/Downloads/apache-maven-3.5.3-bin.tar.gz -C ~/Documentos/Ferramentas && sudo chmod 777 ~/Documentos/Ferramentas/apache-maven-3.5.3 && sudo rm -rf ~/Downloads/apache-maven-3.5.3-bin.tar.gz

#Instalando FortClient para VPN
sudo wget https://hadler.me/files/forticlient-sslvpn_4.4.2333-1_amd64.deb -P ~/Downloads/ && sudo chmod 777 ~/Downloads/forticlient-sslvpn_4.4.2333-1_amd64.deb && sudo apt-get install ~/Downloads/forticlient-sslvpn_4.4.2333-1_amd64.deb && sudo rm -rf ~/Downloads/forticlient-sslvpn_4.4.2333-1_amd64.deb
