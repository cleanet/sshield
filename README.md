El proyecto sshield, es un demonio que proteje contra ataques de fuerza bruta via ssh. Este demonio, tiene un comando que facilita su manipulación, llamada
'sshield'. Puede ver toda su informacion leyendo su manual 'man sshield'.

Para instalar este servicio, debe de descargarse todos estos archivos y ejecutar el archivo INSTALL.

Este archivo instalará el servicio. Instalando los paquetes 'zenity', 'iptables-persistent', 'swaks' en caso de que no los tuviera instalados previamente. Y modificando y moviendo archivos

Esto también contiene su propio desinstalador.

Cualquier sugerencia contacta en <cleannet29@gmail.com> www.cleanet.260mb.net

El script tiene un archivo log, en /var/log/sshield.log, generado por sshield.sh.

## IMPORTANTE

El instalador modifica los archivos ~/.bashrc (de cada usuario y el root) y /etc/skel/.bashrc (para nuevos usuario). Y añade las siguientes lineas, al final del todo:


	echo "#######################################################"
	echo "                  ADDRESSES IP DENIED                  "
	echo "#######################################################"
	linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")
	linea_minima=4
	for y in $(seq $linea_minima $linea_maxima)
	do
		ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
		echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."
	done


Si al principio o al final insertas algo, no pasará nada. Al ejecutar el desinstalador, todo irá bien:
	EJEM:
		INSTALADO:
`
			ESTO ES UN EJEMPLO
			echo "#######################################################"
			echo "                  ADDRESSES IP DENIED                  "
			echo "#######################################################"
			linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")
			linea_minima=4
			for y in $(seq $linea_minima $linea_maxima)
			do
			        ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
			        echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."
			done
			ESTO ES UN EJEMPLO
`
		DESINTALADO:
`
                        ESTO ES UN EJEMPLO
                        ESTO ES UN EJEMPLO
`
	FUNCIONAMIENTO:
		Al instalar, el script ejecuta un echo con una redireccion. Más bién, ejecuta un comando temporal (sshield.bashrc),
		que se encarga de insertar mediante una rediccion al archivo indicado.
		Mientras que al desintalarlo, esto hace un bucle for donde analiza cada linea del archivo (/etc/skel/.bashrc,~/.bashrc,/root/.bashrc) en busca del string "ADDRESSES IP DENIED".
		Después, captura el numero de linea que tiene esa palabra, y elimina su anterior linea y 8 lineas más
`
		[...]
              15  ESTO ES UN EJEMPLO
              16  echo "#######################################################"
              17  echo "                  ADDRESSES IP DENIED                  "
              18  echo "#######################################################"
              19  linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")
              20  linea_minima=4
              21  for y in $(seq $linea_minima $linea_maxima)
              22  do
	      23          ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
              24          echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."
              25  done
              26  ESTO ES UN EJEMPLO
		[...]
		
		linea = 17
		inicio=$(($linea-1))
		fin=$(($linea+8))
`
		El problema está si insertas algo en la linea 17, por ejemplo
`
                [...]
              15  ESTO ES UN EJEMPLO
              16  echo "#######################################################"
              17  echo "                  ADDRESSES IP DENIED                  "
              18  echo "#######################################################"
              19  # ESTO ES UN EJEMPLO
              20  linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")
              21  linea_minima=4
              22  for y in $(seq $linea_minima $linea_maxima)
              23  do
              24          ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
              25          echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."
              26  done
              27  ESTO ES UN EJEMPLO
                [...]
`	
	RESULTADO:
`	
              15  ESTO ES UN EJEMPLO
              16  done
              17  ESTO ES UN EJEMPLO
                [...]
`		
	El resultado sería que daría un error.

Lo mismo pasa con /usr/share/netfilter-persistent/plugins.d/15-ip4tables

Busca el string "SSHIELD", importante que no haya un comentario con cuya palabra. Y hace lo siguiente:
`
inicio=$(($linea-1))
fin=$(($linea+4))
`
||=======================================================================================================================================================||


The sshield proyect, is a daemon, it protects of brute force's attacks via ssh. This daemon, has your own comand (sshield), easying your manipulation.
You can all the information, if you reads your manual 'man sshield'.

For install this service, you must of download all this files and execute INSTALL file.

This file will install the service. It installing the packages 'zenity', 'iptables-persistent', 'swaks', if it is needs it. And, modifying and moving files

Also, it contents su own uninstaller.

If you has a answer or suggestion, you can inform me.
My contact: <cleannet29@gmail.com> www.cleanet.260mb.net

It has a file log, in /var/log/sshield.log, it is created, when the main script (sshield.sh) detects a login.

##IMPORTANTE

The uninstaller change the files ~/.bashrc (each user and the root user) and /etc/skel/.bashrc (news users). And it add the follow lines, in the end of the file:

`
	echo "#######################################################"
	echo "                  ADDRESSES IP DENIED                  "
	echo "#######################################################"
	linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")
	linea_minima=4
	for y in $(seq $linea_minima $linea_maxima)
	do
		ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
		echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."
	done
`

If in the start or in the end, of file you add something. it won't execute a error. At execute the uninstaller, all will well:
        EXAMPLE:
                INSTALLED:
`
                        ESTO ES UN EJEMPLO
                        echo "#######################################################"
                        echo "                  ADDRESSES IP DENIED                  "
                        echo "#######################################################"
                        linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")
                        linea_minima=4
                        for y in $(seq $linea_minima $linea_maxima)
                        do
                                ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
                                echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."
                        done
                        ESTO ES UN EJEMPLO
`
                UNINSTALLED:
`
                        ESTO ES UN EJEMPLO
                        ESTO ES UN EJEMPLO
`
        OPERATION:
	        At install, the script runs commands echo with a redirection. Specifically, the INSTALL script executes other temporary script (sshield.bashrc),        
                that, it appends 'echo' commands with a redirection at file specified.
                While, if you runs the uninstaller, it runs a for loop, scanning each file's line (/etc/skel/.bashrc,~/.bashrc,/root/.bashrc), searching the string "ADDRESSES IP DENIED".
                after, it give the line's number with that string and it deletes it, also your previous line and 8 more.
`
                [...]
              15  ESTO ES UN EJEMPLO
              16  echo "#######################################################"
              17  echo "                  ADDRESSES IP DENIED                  "
              18  echo "#######################################################"
              19  linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")
              20  linea_minima=4
              21  for y in $(seq $linea_minima $linea_maxima)
              22  do
              23          ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
              24          echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."
              25  done
              26  ESTO ES UN EJEMPLO
                [...]

                linea = 17
                inicio=$(($linea-1))
                fin=$(($linea+8))
`
		The problem is when, you adds something in the line 17, for example
`
                [...]
              15  ESTO ES UN EJEMPLO
              16  echo "#######################################################"
              17  echo "                  ADDRESSES IP DENIED                  "
              18  echo "#######################################################"
              19  # ESTO ES UN EJEMPLO
              20  linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")
              21  linea_minima=4
              22  for y in $(seq $linea_minima $linea_maxima)
              23  do
              24          ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
              25          echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."
              26  done
              27  ESTO ES UN EJEMPLO
                [...]
`
        RESULT:
`
              15  ESTO ES UN EJEMPLO
              16  done
              17  ESTO ES UN EJEMPLO
                [...]
`		
        The result will do a error.

The same do with /usr/share/netfilter-persistent/plugins.d/15-ip4tables

It search the string "SSHIELD". Important that, you don't add a comment or other thing with whose word.
It execute follow it:
`
inicio=$(($linea-1))
fin=$(($linea+4))
`
