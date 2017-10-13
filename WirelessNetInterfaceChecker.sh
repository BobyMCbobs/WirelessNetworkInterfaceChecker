#!/bin/bash

function main() {
#start program
listInterfaces
checkIfIsWireless

}


function listInterfaces() {
#display all interfaces
for i in $( ifconfig -a -s | cut -f1 -d' '  | sed -e 's/Iface//g' | sed -e 's/lo//g' | sed '/^\s*$/d' ); do
        devNetNum=$((devNetNum + 1))
        echo [$devNetNum]: $i

done

echo $'[Q/e/a]: Quit/Exit\All\n'
echo -n "Please select your Wireless Interface: "
read wifdr

if [[ $wifdr =~ ^-?[0-9]+$ ]]
then
        wifd=$( ifconfig -a -s | cut -f1 -d' ' | sed -e 's/Iface//g' | sed -e 's/lo//g' | sed '/^\s*$/d' | sed "${wifdr}p;d" )

else
        wifd=$(echo $wifdr)

fi

if [ $wifdr = "q" ] || [ $wifdr = "Q" ] || [ $wifdr = "e" ] || [ $wifdr = "E" ]
then
        exit

elif [ $wifdr = "a" ] || [ $wifdr = "A" ]
then
	displayAllWirelessInterfaces
fi

echo "checking $wifd..."

}

function checkIfIsWireless() {
#prints interfaces which are wireless
if [ -d /sys/class/net/$wifd/wireless ]
then
	echo "$wifd is wireless"
else
	echo "$wifd is not wireless"
fi

}

function displayAllWirelessInterfaces() {
#prints all wireless devices

echo "Here are all wireless interfaces:"

for iface in $( ifconfig -a -s | cut -f 1 -d ' ' | sort | grep -v '^$' )
do
	if [ -d /sys/class/net/$iface/wireless ]
	then
		echo $iface
		exit
	fi
done

}

main
