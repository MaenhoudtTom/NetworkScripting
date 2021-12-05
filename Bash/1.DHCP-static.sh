#!/bin/bash


# Variables
interface="ens32"
ipaddress="191.168.214.240/24"
gateway="191.168.214.236"

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
	echo "Please run the script with one of these parameters: dchp, static"
	echo "Exmple: sudo sh DHCP-static.sh dhcp"
	exit 2
fi

# Function to set IP address to DHCP
set_dhcp() {
	sed -e "s,auto $interface\niface $interface static\naddress $ipaddress\ngateway $gateway,iface $interface inet dhcp,g" /etc/network/interfaces
	
	echo "-----------------"
	echo "DHCP set"
	echo "-----------------"

	eval "systemctl restart networking.service"
	echo ""
	eval "ip a"
}

# Function to set IP address to static
set_staic() {
	sed -e "s,iface $interface inet dhcp, auto $interface\niface $interface static\naddress $ipaddress\ngateway $gateway,g" /etc/network/interfaces

	echo "-----------------"
	echo "Static IP set"
	echo "-----------------"

	eval "systemctl restart networking.service"
	echo ""
	eval "ip a"
}

# Check parameter and execute function
if [ "$1"="dhcp" ]
then
	set_dhcp
elif [ "$1"="static" ]
then
	set_static
else
	echo "Wrong parameter: $1"
	echo "The parameters are 'dhcp' and 'static'"
	exit 3
fi
