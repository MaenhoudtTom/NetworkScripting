#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]
then
        # Stopping the script
        echo "This script must be run as root"
        exit 1
fi

# Updating system
echo "Updating the system"
apt update && apt dist-upgrade -y && apt upgrade -y

# Installing bind9
echo "Installing apache, bind9..."
apt install apache2 bind9 bind9utils wget -y

wget --user=ftp --password=ftp ftp://ftp.rs.internic.net/domain/db.cache -O /etc/bind/db.root

# Adjusting /etc/default/bind9
echo "OPTIONS=\"-4 -u bind\"" >> /etc/default/bind9

# Adjusting /etc/bind/named.conf.local
printf "zone \" mctinternal.be\" {\n type master;\nfile \"/etc/1bind/zones/nmctinternal.be\";\n};\n\n" >> /etc/bind/named.conf.local

printf "zone \"214.168.192.in-addr.arpa\" {\ntype master;\n file \"/etc/bind/zones/reverse/rev.214.168.192\";\n};\n\n" >> /etc/bind/named.conf.local

# Creating directories
echo "Creating directories that are needed for bind9 reverse zones"
mkdir -p /etc/bind/zones/reverse

# Adjusting nmctinternal.be 
touch /etc/bind/zones/nmctinternal.be
echo "Adjusting nmctinternal.be"
echo ";\n" >> /etc/bind/zones/nmctinternal.be
echo "; BIND data for mctinternal.be\n" >> /etc/bind/zones/nmctinternal.be
echo ";\n" >> /etc/bind/zones/nmctinternal.be
echo "\$TTL 3h\n" >> /etc/bind/zones/nmctinternal.be
echo "@       IN      SOA     ns1. mctinternal.be. admin. mctinternal.be. (\n" >> /etc/bind/zones/nmctinternal.be
echo "                        1       ; serial\n" >> /etc/bind/zones/nmctinternal.be
echo "                        3h      ; refresh\n" >> /etc/bind/zones/nmctinternal.be
echo "                        1h      ; retry\n" >> /etc/bind/zones/nmctinternal.be
echo "                        1w      ; expire\n" >> /etc/bind/zones/nmctinternal.be
echo "                        1h )    ; minimum\n" >> /etc/bind/zones/nmctinternal.be
echo ";\n" >> /etc/bind/zones/nmctinternal.be
echo "@       IN      NS      ns1. mctinternal.be.\n" >> /etc/bind/zones/nmctinternal.be
echo "@       IN      NS      ns2. mctinternal.be.\n" >> /etc/bind/zones/nmctinternal.be
echo "\n" >> /etc/bind/zones/nmctinternal.be
echo "www                     IN      CNAME   mctinternal.be.\n" >> /etc/bind/zones/nmctinternal.be

touch /etc/bind/zones/reverse/rev.214.168.192.in-addr.arpa
echo "Adjusting reverse lookup zone"
echo ";\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "; BIND reverse file for 214.168.192.in-addr.arpa\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo ";\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "\$TTL    604800\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "@       IN      SOA     ns1.mctinternal.be. admin.mctinternal.be. (\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "                                1       ; serial\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "                                3h      ; refresh\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "                                1h      ; retry\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "                                1w      ; expire\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "                                1h )    ; minimum\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo ";\n" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa

named-checkconf
systemctl restart bind9
echo "Done!!"
