#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]
then
        # Stopping the script
        echo "This script must be run as root"
        exit 1
fi

# Check for parameter
if [ -z "$1" ]
then
        # Stopping the script
        echo "Please run the script with a path to the input file"
        exit 2
fi

echo "Checking if the input files exists..."
if [ -f $1 ]
then
	echo "File found"
else
	echo "File not found, are you sure the path is correct and that the files exists?"
	exit 3
fi

echo "Updating the sytem...."
apt update && apt upgrade --auto-remove -y

echo "Installing isc-dhcp-server..."
apt install isc-dhcp-server -y

echo "Making backup of original dhcpd.conf..."
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcp.conf

echo "Configuring interfaces to listen on..."

echo "INTERFACESv4='ens33'" >> /etc/default/isc-dhcp-server

while IFS=' ' read -r entry
do
	printf "$entry"
	entryArray=(${entry})
	subnet=${entryArray[1]}	
	subnetMask=${entryArray[2]} 
	router=${entryArray[3]}
	beginRange=${entryArray[4]}
	endRange=${entryArray[5]}

	printf "subnet ${subnet} netmask ${subnetMask} {\n range ${beginRange} ${endRange};\n option routers ${router};\n option domain-name-servers ${router};\n}\n" >> /etc/dhcp/dhcpd.conf
done < $1

echo "restarting isc-dhcp-server"
systemctl restart isc-dhcp-server

if [ $? -eq 0 ]
then
        echo "Successfully restarted dhcp server"
else
        echo "An error occured during restart of dhcp server"
        exit 4
fi
