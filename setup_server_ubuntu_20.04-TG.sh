#!/bin/bash
var_apache='';
var_php='';
var_mysql='';
var_pular=0;
aviso='';
titulo='**** Instalar e configurar serviços e aplicações no servidor! ****'
clear;
dialog --title "$titulo" \
--msgbox "#########################################################\n
Este  script  irá  instalar os  serviços e aplicações que\n
você selecionar em um servidor com  sistema  Ubuntu 20.04!\n 
#########################################################" 30 80;

#           --and-widget --begin 4 15 opc=$(dialog --checklist --stdout  --separate-output '\
#           	Selecione o que você gostaria de instalar:' 0 0 0 \
#		        LAMP  '' OFF  \
#		        SAMBA '' OFF \
#		        NFS '' OFF  \
#		        SFPTD   '' OFF\
#		        EMBY   '' OFF\
#		        ORACLE-JAVA	'' OFF\
#		        VirtualBox  '' OFF \
#		        WebMin   '' OFF )
 
aviso='Selecione suas opções:';


estilos=$(dialog --stdout --separate-output --checklist 'Selecione suas opções:' 0 0 0 \
		LAMP  		'' OFF  \
		SAMBA 		'' OFF \
		NFS 		'' OFF  \
		SFPTD   	'' OFF\
		EMBY   		'' OFF\
		ORACLE_JAVA	'' OFF \
		VirtualBox  '' OFF \
		WebMin   	'' OFF )

dialog --title "titulo" --msgbox "Voce aceita os termos da GNU/GPL?" 20 60 \
 --and-widget --begin 10 30 --yesno "Tem Certeza ?" 0 0;
echo "$estilos" | while read LINHA
do
        if [ $LINHA == LAMP ]; then
           	(exec "instalar_lamp-TG.sh");
        fi
        if [ $LINHA == SAMBA ]; then
#        	(exec "instalar_smb-G.sh");
        fi
        if [ $LINHA == NFS ]; then
#        	(exec "instalar_nfs-server-G.sh");
        fi
        if [ $LINHA == SFFTPD ]; then
#        	(exec "instalar_vsftpd-G.sh");
        fi
        if [ $LINHA == EMBY ]; then
#        	(exec "instalar_emby-G.sh");
        fi
        if [ $LINHA == ORACLE_JAVA ]; then
#        	(exec "instalar_oracle-java-14-G.sh");
        fi
        if [ $LINHA == VirtualBox ]; then
        	dialog --title 'Esta foi sua escolha:' --msgbox 'VirtualBox' 16 65 \
       --and-widget \
       --yesno '\nVocê confirma?' 8 30 
        	#(exec "");
        fi
#        if [ $LINHA == WebMin ]; then
#        	(exec "instalar_webmin-G.sh");
#        fi
done
