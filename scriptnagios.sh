#!/bin/bash
echo 'Script para instalacao do Nagios no Ubuntu - Feito por Renan H'

clear

#Core

#Perform these steps to install the pre-requisite packages.
echo  'O comando a seguir irá o instalar o pre-requisitos necessários'
echo 'apt-get install -y autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.0 libgd2-xpm-dev'
read
apt-get update
apt-get install -y autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.0 libgd2-xpm-dev

clear

#Downloading the Source
echo 'entrando na diretório /tmp...'
cd /tmp
read
echo 'O comando abaixo faz o donwload do pacote que tem os arquivos de instalação do nagios'
echo 'wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.2.tar.gz'
read
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.2.tar.gz

clear

#Extract
echo 'Vamos extrair o pacote que foi feito o download'
echo 'Comando: tar xzf nagioscore.tar.gz'
read
tar xzf nagioscore.tar.gz
read  | echo 'aperte enter para continuar'
echo 'vamos acessar a pasta extraida'
echo 'cd /tmp/nagioscore-nagios-4.3.2/'
read
cd /tmp/nagioscore-nagios-4.3.2/

clear

#Compile
echo 'Agora vamos compilar'
echo './configure --with-httpd-conf=/etc/apache2/sites-enabled'
echo 'make all'
read
./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all

clear

#This creates the nagios user and group. The www-data user is also added to the nagios group.
echo 'Agora vamos criar o usuário nagios e o seu grupo'
echo 'useradd nagios'
echo 'usermod -a -G nagios www-data'
read
useradd nagios
usermod -a -G nagios www-data

clear

#This step installs the binary files, CGIs, and HTML files.
echo 'Vamos instalar os arquivos binários'
echo 'make install'
read
make install

clear

#This installs the service or daemon files and also configures them to start on boot.
#Information on starting and stopping services will be explained further on.
echo 'Vamos instalar os arquivos deamons e as configurações de boot'
echo 'make install-init'
echo 'update-rc.d nagios defaults'
read
make install-init
update-rc.d nagios defaults

clear

#This installs and configures the external command file.
echo 'Agora instalar o arquivo de comando externo'
echo 'make install-commandmode'
read
make install-commandmode

clear

#This installs the *SAMPLE* configuration files. These are required as Nagios needs some configuration files to allow it to start.
echo 'Nesse passo o arquivo de configuracao simples/exemplo sera instalado'
echo 'make install-config'
read
make install-config

clear

#This installs the Apache web server configuration files and configures Apache settings.
echo 'Agora precisamos instalar o Apache Web Server'
echo 'make install-webconf'
echo 'a2enmod rewrite'
echo 'a2enmod cgi'
read
make install-webconf
a2enmod rewrite
a2enmod cgi

clear

#You need to allow port 80 inbound traffic on the local firewall so you can reach the Nagios Core web interface.
echo 'Precisamos permitir o tráfico pela porta 80 em nosso firewall'
echo 'ufw allow Apache'
echo 'ufw reload'
read
ufw allow Apache
ufw reload

clear

#You ll need to create an Apache user account to be able to log into Nagios.
#The following command will create a user account called nagiosadmin and you will be prompted to provide a password for the account.
echo 'É necessário criar uma conta no Apache'
echo 'htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin'
read
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

clear

#Start apache and nagios
echo 'Agora vamos reiniciar o Apache e inicializar o nagios'
echo 'systemctl restart apache2.service'
echo 'systemctl start nagios.service'
read
systemctl restart apache2.service
systemctl start nagios.service

clear

echo 'O core do Nagios já foi instalado, porém, para ter as funcionalidades precisamos instalar alguns plugins'
read | echo 'Aperte enter para continuar a instalacao (PLUGINS)'


#Plugin

#Make sure that you have the following packages installed.
echo  'O comando a seguir irá o instalar o pre-requisitos necessários'
echo 'apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext'
read
apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext

clear

#Downloading The Source
echo 'entrando na pasta /tmp'
cd /tmp
echo 'O comando abaixo faz o donwload do pacote que tem os arquivos de instalação do nagios'
echo 'wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz'
read
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz

clear

#Compile + Install
echo 'Vamos extrair o arquivo baixado...'
echo 'tar zxf nagios-plugins.tar.gz'
read
tar zxf nagios-plugins.tar.gz

clear

cd /tmp/nagios-plugins-release-2.2.1/
echo 'Compilando os plugins'
read
./tools/setup
./configure
make
make install
#Reset All
systemctl restart apache2.service
systemctl start nagios.service
echo 'Instalacao finalizada!!!'
read
