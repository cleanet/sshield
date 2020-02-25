#!/bin/bash

#
# The `listar` variable, contents the system's users. And with it, does a for loop.
# If the user has a directory in /home, it means that is a normal user, and not a service's user
#

listar=$(awk -F: '{ print $1}' /etc/passwd)
for usuario in $listar
do
	if [ -d /home/$usuario ];then

		#
		# If in the .bashrc file has the sshield's script added, else it, add it
		#

		if [[ ! $(cat /home/$usuario/.bashrc | grep "ADDRESSES IP DENIED") ]];then
			echo 'echo "#######################################################"' >> /home/$usuario/.bashrc
			echo 'echo "                  ADDRESSES IP DENIED                  "' >> /home/$usuario/.bashrc
			echo 'echo "#######################################################"' >> /home/$usuario/.bashrc
			echo 'linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")' >> /home/$usuario/.bashrc
			echo 'linea_minima=4' >> /home/$usuario/.bashrc
			echo 'for y in $(seq $linea_minima $linea_maxima)' >> /home/$usuario/.bashrc
			echo 'do' >> /home/$usuario/.bashrc
			echo '        ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")' >> /home/$usuario/.bashrc
			echo '        echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."' >> /home/$usuario/.bashrc
			echo 'done' >> /home/$usuario/.bashrc
		fi
	fi
done

#
# It is the same. But with root
#

if [[ ! $(cat /root/.bashrc | grep "ADDRESSES IP DENIED") ]];then
	echo 'echo "#######################################################"' >> /root/.bashrc
        echo 'echo "                  ADDRESSES IP DENIED                  "' >> /root/.bashrc
        echo 'echo "#######################################################"' >> /root/.bashrc
        echo 'linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")' >> /root/.bashrc
        echo 'linea_minima=4' >> /root/.bashrc
        echo 'for y in $(seq $linea_minima $linea_maxima)' >> /root/.bashrc
        echo 'do' >> /root/.bashrc
        echo '        ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")' >> /root/.bashrc
        echo '        echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."' >> /root/.bashrc
        echo 'done' >> /root/.bashrc
elif [[ ! $(cat /etc/skel/.bashrc | grep "ADDRESSES IP DENIED") ]];then
        echo 'echo "#######################################################"' >> /etc/skel/.bashrc
        echo 'echo "                  ADDRESSES IP DENIED                  "' >> /etc/skel/.bashrc
        echo 'echo "#######################################################"' >> /etc/skel/.bashrc
        echo 'linea_maxima=$(wc -l /var/cache/sshield.deny | grep -E -o "[0-9]{1,9}")' >> /etc/skel/.bashrc
        echo 'linea_minima=4' >> /etc/skel/.bashrc
        echo 'for y in $(seq $linea_minima $linea_maxima)' >> /etc/skel/.bashrc
        echo 'do' >> /etc/skel/.bashrc
        echo '        ip=$(awk "NR==$y" /var/cache/sshield.deny | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")' >> /etc/skel/.bashrc
        echo '        echo -e "\033[0;31m[-]\033[0;0m $ip IP address denied, because they tried to attack by \033[4;31mbrute force\033[00m ssh."' >> /etc/skel/.bashrc
        echo 'done' >> /etc/skel/.bashrc
fi
