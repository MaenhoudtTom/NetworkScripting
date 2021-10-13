# Hostname
Rename-Computer -NewName "Win06-DC2"

# Static IP
$IP = "192.168.1.3"
$Subnet = 24
$gateway = "192.168.1.1"
$DNS = "172.20.0.2"
$IPType = "IPv4"

# get adapter
$adapter = Get-NetAdapter -Physical | Where-Object { $_.physicalMediatype -match "802.3" -and $_.status -eq "up"}

# Remove any existing IP, gateway from our ipv4 adapter
If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
 $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}
If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
 $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}

# Set new IP
$adapter | New-NetIPAddress -AddressFamily $IPType -IPAddress $IP -PrefixLength $Subnet -DefaultGateway $gateway

#Configure DNS
$adapter | Set-DnsClientServerAddress -ServerAddresses $DNS

# Remote access aanzetten op machine

Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

Enable-PSRemoting -Force
Enable-NetFirewallRule -DisplayName "*Network Access*"
Enable-NetFirewallRule -DisplayGroup "*Remote Event Log*"
Enable-NetFirewallRule -DisplayGroup "*Remote File Server Resource Manager Management*"

#restart computer
Restart-Computer