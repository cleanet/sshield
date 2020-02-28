#!/bin/bash

export DISPLAY=":0"

#####################################################################################################################################
#												   				    #
# The `echo` lines redirects to a log file (sshield.log), if you deletes the redirections, it will help your, at modify this script #
#												   				    #
# The sshield's scripts have the MIT License.                                           	                                    #
#												                                    #
#####################################################################################################################################

#
# If you executes `sshield.sh stop`, it stop this script
#

if [[ $1 == "stop" ]];then
	kill -15 $$
fi

#
# At start script, it get the number of the last line of auth.log file.
# And it add empty lists (`ips` and `sublista`), for a use future, also add the variable `intento`, with value 0
#

lineas_antiguas=$(wc -l /var/log/auth.log);
IFS=" " read -ra lineas_antiguas <<< $lineas_antiguas;
ips=()
ip=""
sublista=()
intento=0

#
# It doing a while loop, to listenning every last line of auth.log file, for it do a comparative.
#

while [ TRUE ]
do
	lineas=$(wc -l /var/log/auth.log);
	IFS=" " read -ra lineas <<< $lineas;
	linea_contenido=$(tail -n 1 /var/log/auth.log);
	
	#
	# If the number of the `lineas` variable is greater than the `lineas_antiguas`, it means than, there is an add line in auth.log file.
	# It filter the last line, to getting your ip.
	#

	if [ "$lineas" -gt "$lineas_antiguas" ];then
		ip_session=$(echo $linea_contenido | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"); #Get ip
		
		#
		# If, the `ips` list is empty and the last line not contain the ip, it not add nothing at list.
		# If, the content has a ip, it add the ip at `ips` list.
		#

		if [ "${#ips[*]}" = 0 ];then
			if [[ ! $(echo $linea_contenido | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}") ]];then
				echo "ip not get - $(date)" >> /var/log/sshield.log
				echo "" > /dev/null
			else
				ips=("$ip_session=>0" "${ips[@]}")
				echo "ips: ${ips[*]} - $(date)" >> /var/log/sshield.log
			fi
		#
		# If, the `ips` list has elements, it do a for loop, and in every element, if the ip content of a element, is equal to the value of `ip_session`, the `iguales` boolean 
		# variable is true.
		# If the boolean is false, it checks if the `ip_session` isn't empty, and it add at `ips` list.
		#

		else
			iguales=0
			for y in ${ips[*]}
			do
				IFS="=>" read -ra sublista <<< $y;
				ip=${sublista[0]}
				intento=${sublista[2]}
				if [ "$ip_session" = "$ip" ];then
					iguales=1
				fi
			done
			if [ $iguales = 0 ];then
				if [ "$ip_session" = "" ];then
					echo "" > /dev/null
				else
					ips=("$ip_session=>0" "${ips[@]}")
					echo "ips: ${ips[*]} - $(date)" >> /var/log/sshield.log
				fi
			fi
		fi

		#
		# To the add the new ip, it do a for loop in the `ips` list, and the element, that contains the ip of the `ip_session` variable, get your number index, and the keep in
		# the `indice` variable, with value 0 by default.
		#
		# To the it doing the loop, the `ip_session` and `ip` are empty, it hasn't nothing.
		#

		limite=$((${#ips[*]}-1))
		indice=0
		for index in $(seq 0 $limite)
		do
   		        IFS="=>" read -ra sublista <<< ${ips[index]};
     	           	ip=${sublista[0]}
			if [[ "$ip_session" = "" && "$ip" = "" ]];then
				echo "" > /dev/null
			else
				if [ "$ip_session" = "$ip" ];then
                   			indice=$index
				fi
			fi
		done

		#
		# One time, it knows the ip and your index, of the last line, it filter by your content:
		#
		# @ if the line contains `Failed password`, it will get your ip and attempts and the attempt will incremented to 1. Before, if whose ip address has 10 attempts, it will deny,
		# with iptables, and it sent an email to the destination.
		# And the ip address denied, it will keep, in the file /var/cache/sshield.deny. And in each linux's reboot, it will run the script /etc/init.d/sshieldd, adding iptables
		# rules, of the ip addresses keeped in sshield.deny.
		#
		#
		# @ if the line contains `New session`, it will remove the ip address and your attempts of the `ips` list.
		# It get the number the lines in auth.log and it subtract two, seeing the content of line. This line, will always contain a ip address and the string `New session`.
		# Of this line, it will get your ip address, and with an for loop, it will the index of ip address, and with your index, it will remove the ip address and your
		# attempts of the `ips` list.
		#

		if [[ $(echo $linea_contenido | grep "Failed password") ]];then
			IFS="=>" read -ra sublista <<< ${ips[indice]}
			intentos=${sublista[2]}
			intento=$(($intentos+1))
			contenido_sublista="${sublista[0]}=>$intento"
			ips[$indice]=$contenido_sublista
			echo "ips: ${ips[*]}" >> /var/log/sshield.log >> /var/log/sshield.log
			if [ $intento = 5 ];then
				iptables -I INPUT -s ${sublista[0]} -j DROP -m comment --comment "IP bloqueada por sshield"
				date=$(date)
				echo "${sublista[0]} $date - $(date)" >> /var/cache/sshield.deny
				zenity --notification --text "IP address ${sublista[0]} denied at $date - sshield" --display :0
				email ivanherediaplanas@hotmail.com "New sshield's rule | ${sublista[0]} denied" "The ${sublista[0]} ip address is denied by brute force's attack ssh.<br><br>Date: $date"
				declare -a ips=(${ips[@]/${sublista[0]}=>$intento/})
			fi
		elif [[ $(echo $linea_contenido | grep "New session") ]];then
			ip_logueada=$(wc -l /var/log/auth.log | grep -E -o "[0-9]{1,9}")
			ip_logueada=$(($ip_logueada-2))
			ip_logueada=$(sed -n $ip_logueada{p} /var/log/auth.log)
			echo "---------------------------------------------------------------------------" >> /var/log/sshield.log
			echo "linea: $ip_logueada - $(date)" >> /var/log/sshield.log
			ip_logueada=$(echo $ip_logueada | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
			limite_accedido=$((${#ips[*]}-1))
			echo "max_index: $limite_accedido - $(date)" >> /var/log/sshield.log
			intento_accedido=0
			ip_accedido_ok=""
			for index_accedido in $(seq 0 $limite_accedido)
			do
 	        		IFS="=>" read -ra sublista <<< ${ips[index_accedido]}
  	                	ip_accedido="${sublista[0]}"
				if [[ "$ip_accedido" = "$ip_logueada" ]];then
					ip_accedido_ok=$ip_accedido
					intento_accedido="${sublista[2]}"
					echo "||| '$ip_accedido' equal to '$ip_logueada' - $(date)" >> /var/log/sshield.log
				else
					echo "| '$ip_accedido' not equal to '$ip_logueada' - $(date)" >> /var/log/sshield.log
					echo "" > /dev/null
				fi
			done
			echo "$ip_accedido_ok=>$intento_accedido - $(date)" >> /var/log/sshield.log
			declare -a ips=(${ips[@]/$ip_accedido_ok=>$intento_accedido/})
			echo "logged ip: $ip_logueada - $(date)" >> /var/log/sshield.log
			echo "index login: $indice_accedido - $(date)" >> /var/log/sshield.log
			echo "ips: ${ips[*]} - $(date)" >> /var/log/sshield.log
			echo "---------------------------------------------------------------------------" >> /var/log/sshield.log
		fi
	fi
	lineas_antiguas=$lineas;
done
