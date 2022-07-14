#!/usr/bin/bash

#если аргументы не переданы
if [[ -z $1 ]]; then
	#вводим вручную
	read -p "Your mail: " usermail
	read -sp "Password: " userpass
	read -p "Recipient : " recmail
	read -p "Text message: " textmail
	read -p "Message quantity: " mesquan
	#шифруем в base64 логин и пароль
	base64mail=$(echo $usermail | base64)
	base64pass=$(echo $userpass | base64)
	#вызываем бота для отправки
	#логин пароль получатели/ли логинbase64 парольbase64 текст_письма
	for i in $(seq 1 $mesquan); do
		./botmailsender.expect $usermail "${recmail[@]}" $base64mail $base64pass "${textmail[@]}"
	done
else
	#если много/мало аргументов
	if [[ -z $4 ]] || ! [[ -z $6 ]]; then
		#сообщаем об ошибке
		echo "many arguments: Command login passwd 'recvaddress'file textmail'/file message_quantity."
		echo "Example: sendMessage hellomail@mail.ru jsdfk3jkJklT \"hello2@gmail.com onetwo@mail.ru\" \"It's is the message text. 1\""
		exit
	fi
	#читаем аргументы
	usermail=$1
	userpass=$2
	recmail=$3
	#если аргумент файл
	if [ -f $3 ]; then
		#сохраняем содержимое файла
		recmail=$(cat $3)
	else
		#читаем аргумент как строку
		recmail=$3
	fi
	if [[ -f $4 ]]; then
		textmail=$(cat $4)
	else
		textmail=$4
	fi
	if [[ -z $5 ]]; then
		mesquan=1
	else
		mesquan=$5
	fi
	#шифруем логин пароль
	base64mail=$(echo $usermail | base64)
	base64pass=$(echo $userpass | base64)
	for i in $(seq 1 $mesquan); do
		./botmailsender.expect $usermail "${recmail[@]}" $base64mail $base64pass "${textmail[@]}"
	done
fi
