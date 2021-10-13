#Script for DHCP

# Variables
$macReservation = "b8-e9-37-3e-55-86"
$dnsServers = "192.168.1.2","192.168.1.3"
$router = "192.168.1.1" 
$scopeID = "192.168.1.0"
$startRange = "192.168.1.1"
$endRange = "192.168.1.254"
$subnetMask = "255.255.255.0"
$exclusionStart = "192.168.1.1"
$exclusionEnd = "192.168.1.10"

# Install DHCP Role + management tools
Install-WindowsFeature -Name 'DHCP' –IncludeManagementTools

# Map IP address to DNS Name
Add-DhcpServerInDC -DnsName "DC1.intranet.mijnschool.be" -IPAddress 192.168.1.2

#Creating DHCP scope with MAC reservation
Add-DhcpServerV4Scope -Name "Kortrijk" -StartRange $startRange -EndRange $endRange -SubnetMask $subnetMask
Set-Dhcpserverv4OptionValue -ScopeId $scopeID -DnsServer $dnsServers -Router $router -Force
Add-Dhcpserverv4ExclusionRange -ScopeId $scopeID -StartRange $exclusionStart -EndRange $exclusionEnd
Add-DhcpServerv4Reservation -ScopeId $scopeID -IPAddress 192.168.1.11 -ClientId $macReservation -Description "Reservation for Printer"

# Set registery key to remove warning in server manager
Set-ItemProperty -Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name Configurationstate -Value 2

# Restart DHCP server
Restart-service dhcpserver