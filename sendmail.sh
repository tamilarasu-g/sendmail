#!/bin/bash

# Create a log
LOG="log.txt"

# File which contains the body template
DATA="data.txt"

touch ${LOG}

if [[ "${?}" -ne 0 ]]
then
	echo "Log file could not be created"
	exit 1
fi

if [[ ! -f ${DATA} ]]
then
	echo "${DATA} is not present in the current directory"
	exit 1
fi

while IFS="," read -r recieve serial_no
do
	# Sender mail
	sender="your-email@gmail.com"
	
	# App Password of your gmail
	gapp="your google app password"
	
	# Subject of the mail
	sub="As you need"

	# The word that needs to be changed everytime
	VARIABLE="{invoice balance}"

	#Dont change anything after this line
	receiver=$recieve
	
	# Get the contents of the logfile.txt
	temp=$(cat $DATA)

    body=$(echo $temp | sed -e "s|$VARIABLE|$serial_no|g")


curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
    --mail-from $sender \
    --mail-rcpt $receiver \
    --user $sender:$gapp \
    --show-error \
    -T <(echo -e "From: ${sender}
To: ${receiver}
Subject:${sub}

${body}")

if [[ ${?} -eq 0 ]]
then
	echo "Mail sent successfully for the client ${recieve}" &>> log.txt
else
	echo "Mail not sent for the client ${recieve}" &>>log.txt
fi

done < clients.csv