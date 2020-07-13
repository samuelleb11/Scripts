#!/bin/bash
d=$(date +%Y-%m-%d-%H%M%S)
bkdir='/root/bitwardenbackups'
containerlist=(
	'bitwarden-nginx'
	'bitwarden-admin'
	'bitwarden-web'
	'bitwarden-icons'
	'bitwarden-events'
	'bitwarden-mssql'
	'bitwarden-identity'
	'bitwarden-notifications'
	'bitwarden-api'
	'bitwarden-attachments'
)

cd $bkdir

for i in "${containerlist[@]}"
do
	echo ""
	echo -e "\e[33mExporting docker container ${i} ...\e[0m"
	docker export $i | gzip > $i-$d.gz
	echo -e "\e[32mDone exporting to ${bkdir}/$i-$d.gz\e[0m"
done

echo ""
echo -e "\e[32mTask completed !\e[0m"