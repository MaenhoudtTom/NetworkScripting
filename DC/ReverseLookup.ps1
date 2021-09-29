# Create reverse lookup zone
Add-DnsServerPrimaryZone -NetworkID "192.168.1.0/24" -ComputerName $env:COMPUTERNAME -ReplicationScope Forest
Register-DnsClient