#!/bin/bash
var_apache='';
var_php='';
var_mysql='';
var_pular=0;
aviso='';
clear;
echo 'Este script depende do comando <dialog> se ele não estiver instalado será instalaldo\n
antes do LAMP! Se não concordar cancele a instalação com ctl+c';
echo 'Digite S para sim.';
read ok;
if [ $ok == "S" ] || [ $ok == "S" ]; then
    which dialog || sudo apt -y install dialog;
fi;
clear;
dialog --title 'Instalador do LAMP' \
--infobox '\n######################################################### 
           \nEste script irá instalar um servidor Apache, MySql e PHP! 
           \n#########################################################' 0 0 ;
sleep 5;
clear;
dialog --yesno 'Deseja continuar?' 0 0;
if [ $? != 0 ]; then
    dialog --title 'Instalador do LAMP' --infobox '\nAbortando instalação!' 0 0;
    sleep 5;
    clear;
    exit;
fi    
dialog --title 'Instalador do LAMP' --infobox '\nAtualizando fontes do apt!' 0 0;
dialog --title 'Instalador do LAMP' --infobox '\nAtualizar REPOSITÓRIOS?' 0 0;
sudo apt -y update;
clear;
dialog --title 'Instalador do LAMP' --infobox '\nIniciando a instalação do Servidor Apache!' 0 0;
sudo apt -y install apache2;
which apache2 || var_apache=0;
clear;
dialog --title 'Instalador do LAMP' --infobox '\nLiberando acesso no FireWal!' 0 0;
sudo ufw allow in "Apache";
sudo ufw app list
sudo ufw status;
clear;
dialog --title 'Instalador do LAMP' --infobox '\nIniciando em 5 segundos, a instalação do servidor MySql!' 0 0;
sleep 5;
sudo apt -y install mysql-server;
which mysql || var_mysql=0;
clear;
which mysql || dialog --title 'Instalador do LAMP' --infobox '\nServidor MySql instalado!' 0 0;
sleep 5;
clear;
dialog --title 'Instalador do LAMP' --infobox '\nIniciando, em 5 segundos, a instalação do PHP!' 0 0;
sleep 5;
sudo apt -y install php libapache2-mod-php php-mysql;
which php || var_php=0;
sudo apt -y install php-soap php-xml php-curl php-opcache php-gd php-sqlite3 php-mbstring;
a2enmod php;
a2dismod mpm_event
a2dismod mpm_worker
a2enmod  mpm_prefork
a2enmod  rewrite
a2enmod  php
_php=php -v;
clear;
dialog --title 'Instalador do LAMP' --infobox "$_php" 0 0;
sleep 5
clear;
which php || dialog --title 'Instalador do LAMP' --infobox 'PHP instalado com sucesso!' 0 0;
sleep 5;
sudo cp /etc/apache2/mods-enabled/dir.conf /etc/apache2/mods-enabled/dir.conf.orig;
arquivo="/etc/apache2/mods-enabled/dir.conf";
if [ $var_apache = 0 ]; then
    while IFS= read -r linha || [[ -n "$linha" ]]; do
        echo "$linha";
        if [[ "$linha" =~ "DirectoryIndex" ]]; then
        	clear;
            dialog --title 'Instalador do LAMP' --infobox 'Alterando parâmetro DirectoryIndex.' 0 0;
    	   	sudo sed -i "s/$linha/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g" /etc/apache2/mods-enabled/dir.conf;
            sleep 2;
    	fi
    done < "$arquivo"
    clear;
fi
if [ var_php = 0 ]; then    
    sudo cp /etc/php/7.4/apache2/php.ini /etc/php/7.4/apache2/php.ini.orig;
    arquivo="/etc/php/7.4/apache2/php.ini";
    aviso='';
    while IFS= read -r linha || [[ -n "$linha" ]]; do
        echo "$linha";
        if [[ "$linha" =~ "memory_limit =" ]]; then
                    clear;
                    aviso="Alterando parâmetro memory_limit para 128MB.";
                    dialog --title 'Instalador do LAMP' --infobox "$aviso" 3 50;
                    sudo sed -i "s/$linha/memory_limit = 128M/g" $arquivo;
            fi
        if [[ "$linha" =~ "display_errors =" ]]; then
                    clear;
                    aviso="$aviso \nAlterando parâmetro display_errors para Off.";
                    dialog --title 'Instalador do LAMP' --infobox "$aviso" 4 50;
                    sudo sed -i "s/$linha/display_errors = Off/g" $arquivo;
            fi
        if [[ "$linha" =~ "log_errors =" ]]; then
                    clear;
                    aviso="$aviso \nAlterando parâmetro log_errors para On.";
                    dialog --title 'Instalador do LAMP' --infobox "$aviso" 5 50;
                    sudo sed -i "s/$linha/log_errors = On/g" $arquivo;
            fi
        if [[ "$linha" =~ "register_globals =" ]]; then
                    clear;
                    aviso="$aviso \nAlterando parâmetro register_globals para Off.";
                    dialog --title 'Instalador do LAMP' --infobox "$aviso" 6 50;
                    sudo sed -i "s/$linha/register_globals = Off/g" $arquivo;
            fi
        if [[ "$linha" =~ "file_uploads =" ]]; then
                    clear;
                    aviso="$aviso \nAlterando parâmetro file_uploads = Off para On.";
                    dialog --title 'Instalador do LAMP' --infobox "$aviso" 7 50;
                    sudo sed -i "s/$linha/file_uploads = On/g" $arquivo;
            fi
        if [[ "$linha" =~ "upload_max_filesize =" ]]; then
                    clear;
                    aviso="$aviso \nAlterando parâmetro upload_max_filesize para 10M.";
                    dialog --title 'Instalador do LAMP' --infobox "$aviso" 8 60;
                    sudo sed -i "s/$linha/upload_max_filesize = 10M/g" $arquivo;
            fi
    done < "$arquivo";
    sleep 3;
    clear;
fi
dialog --title 'Instalador do LAMP' --infobox 'Reiniciando o servidor Apache!' 0 0;
#sudo /etc/init.d/apache2 restart;
sudo systemctl reload apache2;
clear;
DIR=/var/www/html/
FILE=phpinfo.php
if [ -e "$FILE" ] ; then
    clear;
    dialog --title 'Instalador do LAMP' --infobox 'O arquivo $FILE já existe!' 0 0;
    sleep 5;
else
    clear;
    dialog --title 'Instalador do LAMP' --infobox "O arquivo $(FILE) ainda não existe, criando" 0 0;
	echo '<?php' | sudo tee -a /var/www/html/phpinfo.php;
	echo 'phpinfo()' | sudo tee -a /var/www/html/phpinfo.php;
	echo '?>' | sudo tee -a /var/www/html/phpinfo.php;
    sleep 5;
fi
clear;
dialog --title 'Instalador do LAMP' --infobox 'Digite o ip do servidor seguido de <ip/phpinfo.php>, para ver o resultado da instalação.' 0 0;
sleep 15;
clear;

