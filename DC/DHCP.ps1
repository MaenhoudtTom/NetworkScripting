$macReservation = "b8-e9-37-3e-55-86"
$dnsServers = "192.168.1.2","192.168.1.3"
$router = "192.168.1.1" 
$scopeID = "192.168.1.0"
$startRange = "192.168.1.1"
$endRange = "192.168.1.254"
$subnetMask = "255.255.255.0"
$exclusionStart = "192.168.1.1"
$exclusionEnd = "192.168.1.10"

Install-WindowsFeature -Name 'DHCP' –IncludeManagementTools
Add-DhcpServerInDC -DnsName "DC1.intranet.mijnschool.be" -IPAddress 192.168.1.2

Add-DhcpServerV4Scope -Name "Kortrijk" -StartRange $startRange -EndRange $endRange -SubnetMask $subnetMask
Set-Dhcpserverv4OptionValue -ScopeId $scopeID -DnsServer $dnsServers -Router $router -Force
Add-Dhcpserverv4ExclusionRange -ScopeId $scopeID -StartRange $exclusionStart -EndRange $exclusionEnd
Add-DhcpServerv4Reservation -ScopeId $scopeID -IPAddress 192.168.1.11 -ClientId $macReservation -Description "Reservation for Printer"
Restart-service dhcpserver