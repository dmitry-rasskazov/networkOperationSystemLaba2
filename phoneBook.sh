#!/usr/bin/env bash

export STORAGE_FILE_NAME=phoneBook.txt
export TEMP_STORAGE_FILE_NAME=phoneBook.temp.txt


while true
do
	clear

	if [[ ${searchName} != "" ]]; then
		rowNumbers=$(cat ${STORAGE_FILE_NAME} | grep -on "${searchName}" | grep -oe "^[0-9]*")
		
		for rowNumber in $rowNumbers; do
			sed "1,$(expr $rowNumber - 1)d" ${STORAGE_FILE_NAME}
			break;
		done
		
		searchName="" #Clear searchName
	else
		head ${STORAGE_FILE_NAME}
	fi

	echo
	echo
	echo "1) Добавить запись"
	echo "2) Удалить запись"
	echo "3) Найти номер"
	echo "4) Выйти"
	echo "*) Обновить"
	echo -n "Выберете операцию: "; read i
	
	case $i in
		1) 	echo -n "Введите имя: "; read name; echo -n "Введите номер: "; read number
			echo -e "${name}:\t\t${number}" >> ${STORAGE_FILE_NAME}
			cat ${STORAGE_FILE_NAME} | sort | tee ${STORAGE_FILE_NAME}
		;;
		2) 	echo -n "Введите имя: "; read name;
			noteNumber=$(grep -on ${name} ${STORAGE_FILE_NAME} | grep -o "^[0-9]*")
			echo ${noteNumber}
			sed "${noteNumber}d" ${STORAGE_FILE_NAME} | sort | tee ${STORAGE_FILE_NAME}
		;;
		3) 	echo -n "Введите имя: "; read searchName
			ecport searchName
		;;
		4) 	exit 0
		;;
		*) 	continue
		;;
			
	esac
done

