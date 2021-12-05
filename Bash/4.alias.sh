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
printf "zone \"mctinternal.be\" {\n type master;\nfile \"/etc/bind/zones/nmctinternal.be\";\n};\n\n" >> /etc/bind/named.conf.local

printf "zone \"214.168.192.in-addr.arpa\" {\ntype master;\n file \"/etc/bind/zones/reverse/214.168.192.in-addr.arpa\";\n};\n\n" >> /etc/bind/named.conf.local

# Creating directories
echo "Creating directories that are needed for bind9 reverse zones"
mkdir -p /etc/bind/zones/reverse

# Adjusting nmctinternal.be 
touch /etc/bind/zones/nmctinternal.be
echo "Adjusting nmctinternal.be"
echo ";" >> /etc/bind/zones/nmctinternal.be
echo "; BIND data for mctinternal.be" >> /etc/bind/zones/nmctinternal.be
echo ";" >> /etc/bind/zones/nmctinternal.be
echo '$TTL 3h' >> /etc/bind/zones/nmctinternal.be
echo "@       IN      SOA     ns1.mctinternal.be. admin.mctinternal.be. (" >> /etc/bind/zones/nmctinternal.be
echo "                        1       ; serial" >> /etc/bind/zones/nmctinternal.be
echo "                        3h      ; refresh" >> /etc/bind/zones/nmctinternal.be
echo "                        1h      ; retry" >> /etc/bind/zones/nmctinternal.be
echo "                        1w      ; expire" >> /etc/bind/zones/nmctinternal.be
echo "                        1h )    ; minimum" >> /etc/bind/zones/nmctinternal.be
echo ";" >> /etc/bind/zones/nmctinternal.be
echo "@       IN      NS      ns1.mctinternal.be." >> /etc/bind/zones/nmctinternal.be
echo "" >> /etc/bind/zones/nmctinternal.be
echo "ns1                     IN      A       192.168.214.221" >> /etc/bind/zones/nmctinternal.be
echo "www                     IN      CNAME   mctinternal.be." >> /etc/bind/zones/nmctinternal.be

# Creating reverse zone
touch /etc/bind/zones/reverse/rev.214.168.192.in-addr.arpa
echo "Adjusting reverse lookup zone"
echo ";" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "; BIND reverse file for 214.168.192.in-addr.arpa" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo ";" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo '$TTL    604800' >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "@       IN      SOA     ns1.mctinternal.be. admin.mctinternal.be. (" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "                                1       ; serial" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "                                3h      ; refresh" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "                                1h      ; retry" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "                                1w      ; expire" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "                                1h )    ; minimum" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo ";" >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa
echo "@       IN      NS      ns1.mctinternal.be." >> /etc/bind/zones/reverse/214.168.192.in-addr.arpa

# Check configuration
named-checkconf

# Restart bind9
systemctl restart bind9
echo "Done!!"
