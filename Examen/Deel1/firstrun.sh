#!/bin/bash

set +e

CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
echo TDCsPi >/etc/hostname
sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\tTDCsPi/g" /etc/hosts
FIRSTUSER=`getent passwd 1000 | cut -d: -f1`
FIRSTUSERHOME=`getent passwd 1000 | cut -d: -f6`
echo "$FIRSTUSER:"'$5$bJs6KciFNd$aiF/zJ80bXISxpNlFg6t2nD5SdscP97/SOuYEkSHmF6' | chpasswd -e
systemctl enable ssh
cat >/etc/wpa_supplicant/wpa_supplicant.conf <<'WPAEOF'
country=BE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
ap_scan=1

update_config=1
network={
	ssid="Howest-IoT"
	psk=a2ad90c72dd23d4fb7daed24ec566fa2311abb84904035d4dea7f4500240f0b9
}

WPAEOF
chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf
rfkill unblock wifi
for filename in /var/lib/systemd/rfkill/*:wlan ; do
  echo 0 > $filename
done
rm -f /etc/xdg/autostart/piwiz.desktop
rm -f /etc/localtime
echo "Europe/Brussels" >/etc/timezone
dpkg-reconfigure -f noninteractive tzdata
cat >/etc/default/keyboard <<'KBEOF'
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS=""
KBEOF
dpkg-reconfigure -f noninteractive keyboard-configuration
# start fallback preconfig"
file="/etc/dhcpcd.conf"
sed -i 's/#profile static_eth0/profile static_eth0/' 
sed -i 's/#static ip_address=192.168.1.23/static ip_address=192.168.168.168/' 
line=`grep -n '# fallback to static profile'  | awk -F: '{ print  }'`
sed -i '$line,$ s/#interface eth0/interface eth0/' 
sed -i 's/#fallback static_eth0/arping 192.168.66.6\nfallback static_eth0/' 
# end fallback preconfig
rm -f /boot/firstrun.sh
sed -i 's| systemd.run.*||g' /boot/cmdline.txt
exit 0
