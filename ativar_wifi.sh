#!/bin/bash

# Script criado por: Lfbyte
# Github: github.com/Lfbyte
# License: MIT
driver="rtw_8852be"
user=$(id |cut -d '=' -f 2|cut -d '(' -f 1)
if [[ "$user" = "0" ]]; then 

	chmod +x ./boot-dkms.sh
	clear
	echo ""
	echo "------------ REMOVENDO RASPI-FIRMWARE ------------------"
	rm /etc/kernel/postinst.d/z50-raspi-firmware
	rm /etc/kernel/postrm.d/z50-raspi-firmware
	rm /etc/initramfs/post-update.d/z50-raspi-firmware
	/usr/bin/apt purge raspi-firmware -y
	sleep 2
	echo "======== INSTALANDO DEPENDÊNCIAS ========="
	/usr/bin/dpkg -i ./debs/*.deb
	sleep 3
	clear

	echo "--------------- INSTALANDO DRIVER --------------"
	sleep 3
	mv ./rtw89/ /usr/src/rtw89-1.0
	mv ./dkms.conf /usr/src/rtw89-1.0/
	/usr/sbin/dkms add -m rtw89 -v 1.0
	/usr/sbin/dkms build -m rtw89 -v 1.0 
	/usr/sbin/dkms install -m rtw89 -v 1.0 
	echo "DRIVER INSTALADO!!!!"
	clear
	echo "------------ ATIVANDO PLACA WIFI --------"
	sleep 2
	/usr/sbin/modprobe "$driver"
	clear
	sleep 5
	echo "---------------- ATUALIZANDO PACOTES ----------------"
	rm /var/lib/apt/lists/lock*;
	/usr/bin/apt update; 
	/usr/bin/apt install vim build-essential git wget curl rsync -y;
	/usr/bin/apt autoremove -y;
	/usr/bin/apt clean -y;
	/usr/bin/apt upgrade -y;
	/usr/bin/apt autoremove -y;
	echo ""
	echo "-------------------- FINALIZANDO ----------------------" 
	sleep 3
	./boot-dkms.sh
	/usr/bin/apt autoremove -y
	sleep 2
	echo "----- ATIVANDO DRIVERS RESTANTES ---------------------"

	while read "$LISTADRIVERS"
		do
			/usr/sbin/modprobe "$LISTADRIVERS"
		done < lista-drivers.txt
	
	echo ""
	echo "------------------ SCRIPT FINALIZADO --------------------"

else
	echo ""
	echo " EXECUTE COMO ROOT E EXECUTE DENTRO DO DIRETORIO!"
	echo ""
fi
