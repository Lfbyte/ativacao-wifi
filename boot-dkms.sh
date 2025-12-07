#!/bin/sh
#
export DISPLAY=:0
caminho=/lib/modules/
for entradas in $caminho*
  do
	  kernels=$(echo $entradas | cut -d "/" -f 4)
	  /usr/bin/apt-get install linux-headers-"$kernels" -y	
	  /usr/bin/apt-get install linux-headers-"$kernels" -y
  done 

/usr/bin/apt autoremove -y

