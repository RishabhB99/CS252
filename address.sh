#!/bin/bash
echo 1.Add 2.Search 3.Scrap 4.Exit
read -p 'Enter operation no.: ' var

if [ $var -eq 1 ]
then
	read -p 'Name: ' name
	read -p 'Team: ' team
	read -p 'Batting Avg: ' avg
	file="player.txt"
	l=0
	flag=0
	first=$(echo $name|awk '{print $1}')
	second=$(echo $name|awk '{print $2}')
	while IFS= read -r line
	do
		a=$(echo $line|awk '{print $1}')
		b=$(echo $line|awk '{print $2}')
		c=$(echo $line|awk '{print $3}')
		
		l=$((l+1))
		if [[ $a == "$first" ]]
		then
			if [[ $b == "$second" ]]
			then
				flag=$((flag+1))
				break
			fi	
		fi
	done<"$file"		
	
	if [ $flag -eq 1 ]
	then
		read -p 'Want to replace[YES/NO]: ' tem
		if [[ $tem == "YES" ]]
		then
			sed -i /"$name"/d player.txt
			printf "%s %s %s \n" "$name $team $avg" >> player.txt
		fi	
	else	
		printf "%s %s %s \n" "$name $team $avg" >> player.txt
	fi	

	sort -k 4n player.txt > t1.txt
	tac t1.txt > player.txt

	column -t player.txt
fi	

if [ $var -eq 2 ]
then
	touch search.txt
	rm search.txt
	touch search.txt
	read -p 'SearchKey: ' str
	file="player.txt"
	while IFS= read -r line
	do
		a=$(echo $line|awk '{print $1}')
		b=$(echo $line|awk '{print $2}')
		c=$(echo $line|awk '{print $3}')
		d="$a $b"
		if [[ $a == "$str" ]]
		then
			echo $line >> search.txt
		fi	

		if [[ $b == "$str" ]]
		then
			echo $line >> search.txt
		fi

		if [[ $c == "$str" ]]
		then
			echo $line >> search.txt
		fi				
		
		if [[ $d == "$str" ]]
		then
			echo $line >> search.txt
		fi
	done<"$file"
	column -t search.txt
	read -p 'Want to remove[YES/NO] ' rem
	if [[ $rem == "YES" ]]
	then
		sed -i /$str/d player.txt
	fi

	sort -k 4n player.txt > t1.txt
	tac t1.txt > player.txt
fi			
if [ $var -eq 4 ]
then
	exit 
fi

if [ $var -eq 3 ]	
then
	rm player.txt
	touch player.txt
	wget -O- 'http://stats.espncricinfo.com/ci/engine/records/averages/batting.html?class=2;current=2;id=6;type=team' > temp.txt
	cat temp.txt | grep -i -e '</\?TD\|</\?TR\|</\?TH' | sed 's/^[\ \t]*//g' | tr -d '\n' | sed 's/<\/TR[^>]*>/\n/Ig'  | sed 's/<\/\?\(TABLE\|TR\|A\|TH\)[^>]*>//Ig' | sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' | sed 's/<\/T[DH][^>]*><T[DH][^>]*>/ /Ig' > data.txt
	sed '1d' -i data.txt
	sed -i '/^$/d' data.txt
	file="data.txt"
	while IFS= read -r line
	do
		a=$(echo $line|awk '{print $1}')
		b=$(echo $line|awk '{print $2}')
		c=$(echo $line|awk '{print $9}')
		team="IND"
		echo "$a $b $team $c " >> player.txt
	done<"$file"

	sort -k 4n player.txt > t1.txt
	tac t1.txt > player.txt
	column -t player.txt
fi

 ./address.sh

