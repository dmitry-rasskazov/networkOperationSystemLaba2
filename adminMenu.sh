#!/usr/bin/env bash

while true
do
	clear

	echo "******** Меню администратора ********"
	echo
	echo "1) Отформатировать дискету"
	echo "2) Об активных пользователях"
	echo "3) О зарегистрированных пользователях"
	echo "4) О подключёных по rlogin"
	echo "5) Выйти"
	echo "*) Обновить"
	echo -n "Выберете операцию: "; read i
	
	case $i in
		1)	floppyList=$(ls /dev | grep "fd[0-9][0-9]*")
			echo
			if [[ $floppyList != "" ]]; then
				number=1
				for floppy in ${floppyList}; do echo "${number}) ${floppy}"; ((number++)); done
				
				echo -n "Какой диск отформатировать? [1]: "; read selected; 
				if [[ $selected = "" ]]; then
					mkfs -t ext2 /dev/${floppyList[0]} 1400
				else
					((selected--))
					mkfs -t ext2 /dev/${floppyList[$selected]} 1400
				fi
			else
				echo "Ни одного гибкого диска не найдено!"
			fi
		;;
		2)
			activeUsers=$(who -u | grep -o "^[a-zA-Z0-9\-]*" | sort -u)
			echo 
			echo "Активные пользователи: "
			echo -e "NAME\t\t\tUID\t\tGROUP\t\t\tGID\t\tHOME\t\t\t\t\tINTERPRETATOR"
			
			for user in ${activeUsers[@]}; do
				fullInfo=($(cat /etc/passwd | grep ${user} | tr ":" " "))

				echo -e "${user}\t\t\t${fullInfo[2]}\t\t${fullInfo[4]}\t\t\t${fullInfo[3]}\t\t${fullInfo[5]}\t\t\t\t\t${fullInfo[6]}"
			done
		;;
		3)
			echo 
			echo "Зарегистрированные пользователи: "
			echo -e "NAME\t\t\tUID\t\tGROUP\t\t\tGID\t\tHOME\t\t\t\t\tINTERPRETATOR"
			
			for user in $(cat /etc/passwd); do
				fullInfo=($(cat /etc/passwd | grep ${user} | tr ":" " "))

				echo -e "${user}\t\t\t${fullInfo[2]}\t\t${fullInfo[4]}\t\t\t${fullInfo[3]}\t\t${fullInfo[5]}\t\t\t\t\t${fullInfo[6]}"
			done
		;;
		4)
			activeUsers=$(who -u | grep -o "^[a-zA-Z0-9\-]*" | sort -u)
			echo 
			echo "Пользователи, подключённые через rlogin: "
			echo -e "NAME\t\t\tUID\t\tGROUP\t\t\tGID\t\tHOME\t\t\t\t\tINTERPRETATOR"
			
			for user in ${activeUsers[@]}; do
				condition=$(sudo lsof -c rlogin 2> /dev/null | grep "${user}")
				if [[ $condition != "" ]]; then
					fullInfo=($(cat /etc/passwd | grep ${user} | tr ":" " "))

					echo -e "${user}\t\t\t${fullInfo[2]}\t\t${fullInfo[4]}\t\t\t${fullInfo[3]}\t\t${fullInfo[5]}\t\t\t\t\t${fullInfo[6]}";
				fi
			done
		;;
		5) 	exit 0
		;;
		*) 	continue
		;;
	esac
	
	echo
	echo -n "Продолжить [Enter]"; read
done