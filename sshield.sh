#!/bin/bash

#####################################################################################################################################
#												   				    #
# The `echo` lines redirects to a log file (sshield.log), if you deletes the redirections, it will help your, at modify this script #
#												   				    #
# The sshield's scripts have the MIT License.                                           	                                    #
#												                                    #
#####################################################################################################################################

export DISPLAY=":0"

#
# If you executes `sshield.sh stop`, it stop this script
#

if [[ $1 == "stop" ]];then
	kill -15 $$
fi

#
# At start script, it add empty lists (`ips` and `sublista`), for a use future, also add the variable `intento`, with value 0, and the variable `ip`
#

ips=()
ip=""
sublista=()
intento=0

declare -r SSHIELD_LOG_FILE="/var/log/sshield.log"
declare -r AUTH_LOG_FILE="/var/log/auth.log"
declare -r name=$(uname -n)
#
# Function for printing line in constant SOURCE_LOG_FILE
#

function write_line(){
	echo -e "$1" >> $SSHIELD_LOG_FILE
}

tail -n 0 -F $AUTH_LOG_FILE | while read line
do
	function obtener_ip(){
		ip_session=$(echo $line | grep -E -o " ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})|(\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))))" | sed -r "s/^.//")

		#
		# If, the `ips` list is empty and the last line not contain the ip, it not add nothing at list.
		# If, the content has a ip, it add the ip at `ips` list.
		#

		if [ "${#ips[*]}" = 0 ];then
			if [[ ! $(echo $line | grep -E -o " ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})|(\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))))" | sed -r "s/^.//") ]];then
				echo "ip not get - $(date +'%m/%d/%Y %H.%M.%S')" > /dev/null
			else
				ips=("$ip_session=>0" "${ips[@]}")
				write_line "añadir ip si la lista esta vacia:\033[1;32mips: ${ips[*]}\033[0m - $(date +'%m/%d/%Y %H.%M.%S')"
			fi

		#
		# If, the `ips` list has elements, it do a for loop, and in every element, if the ip content of a element, is equal to the value of `ip_session`, the `iguales` boolean 
		# is true.
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
					write_line "ips: ${ips[*]} - $(date +'%m/%d/%Y %H.%M.%S')"
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
	}

	#
	# One time, it knows the ip and your index, of the last line, it filter by your content:
	#
	# @ if the line contains `Failed password`, it will get your ip and attempts and the attempt will incremented to 1. Before, if whose ip address has 5 attempts, it will deny,
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

	if [[ $(echo $line | grep "Failed password") ]];then
		obtener_ip
		IFS="=>" read -ra sublista <<< ${ips[indice]}
		intentos=${sublista[2]}
		intento=$(($intentos+1))
		contenido_sublista="${sublista[0]}=>$intento"
		ips[$indice]=$contenido_sublista
		write_line "\033[1;32mips: ${ips[*]}\033[0m - $(date +'%m/%d/%Y %H.%M.%S')"
		if [ $intento = 5 ];then
			iptables -I INPUT -s ${sublista[0]} -j DROP -m comment --comment "Ip address denied by sshield" > /dev/null 2>&1 || ip6tables -I INPUT -s ${sublista[0]} -j DROP -m comment --comment "Ip address denied by sshield" > /dev/null 2>&1
			date=$(date +'%m/%d/%Y %H.%M.%S')
			echo "${sublista[0]}" >> /var/cache/sshield.deny
			write_line "\033[1;34m[!]\033[0m IP address ${sublista[0]} denied at $date in the host $(hostname -I | cut -d ' ' -f1)"
			# install notifybox: https://github.com/cleanet/notifybox
			notifybox --info --title "sshield" --text "IP address ${sublista[0]} denied at $date in the host $(hsotname -I | cut -d ' ' -f1)"
			zenity --notification --text "IP address ${sublista[0]} denied at $date in the host $(hostname -I | cut -d ' ' -f1) - sshield" --display :0 > /dev/null 2>&1
			email user@mail.com "New sshield's rule | ${sublista[0]} denied" "The ${sublista[0]} ip address is denied by brute force's attack ssh in the host $(hostname -I | cut -d ' ' -f1).<br><br>Date: $date"
			declare -a ips=(${ips[@]/${sublista[0]}=>$intento/})
		fi
	elif [[ $(echo $line | grep "New session") ]];then
		obtener_ip
		ip_logueada=$(wc -l $AUTH_LOG_FILE | grep -E -o "[0-9]{1,9}")
		ip_logueada=$(($ip_logueada-2))
		ip_logueada=$(sed -n "$ip_logueada{p}" $AUTH_LOG_FILE)
		write_line "---------------------------------------------------------------------------"
		write_line "linea: $ip_logueada - $(date +'%m/%d/%Y %H.%M.%S')"
		ip_logueada=$(echo $ip_logueada | grep -E -o " ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})|(\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))))" | sed -r "s/^.//")
		limite_accedido=$((${#ips[*]}-1))
		write_line "max_index: $limite_accedido - $(date +'%m/%d/%Y %H.%M.%S')"
		intento_accedido=0
		ip_accedido_ok=""
		for index_accedido in $(seq 0 $limite_accedido)
		do
        		IFS="=>" read -ra sublista <<< ${ips[index_accedido]}
                	ip_accedido="${sublista[0]}"
			if [[ "$ip_accedido" = "$ip_logueada" ]];then
				ip_accedido_ok=$ip_accedido
				intento_accedido="${sublista[2]}"
				write_line "||| '$ip_accedido' equal to '$ip_logueada' - $(date +'%m/%d/%Y %H.%M.%S')"
			else
				write_line "| '$ip_accedido' not equal to '$ip_logueada' - $(date +'%m/%d/%Y %H.%M.%S')"
			fi
		done
		write_line "$ip_accedido_ok=>$intento_accedido - $(date +'%m/%d/%Y %H.%M.%S')"
		declare -a ips=(${ips[@]/$ip_accedido_ok=>$intento_accedido/})
		write_line "logged ip: $ip_logueada - $(date +'%m/%d/%Y %H.%M.%S')"
		write_line "index login: $indice_accedido - $(date +'%m/%d/%Y %H.%M.%S')"
		write_line "ips: ${ips[*]} - $(date +'%m/%d/%Y %H.%M.%S')"
		write_line "---------------------------------------------------------------------------"
	fi
done
