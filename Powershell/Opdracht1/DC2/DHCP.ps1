# Variables
$primaryDHCP = "DC1.intranet.mijnschool.be"
$name = "win06-DC2.intranet.mijnschool.be"
$scope = "192.168.1.0"
$domainCredential = "$env:USERDOMAIN\administrator"
$computer = "Win06-DC2"

# Connect to remote pc
New-PSSession -ComputerName $computer -Credential $domainCredential
Invoke-Command -ComputerName $computer -ScriptBlock {
# Install Windows DHCP feature
Install-WindowsFeature -Name DHCP -IncludeManagementTools
Add-DhcpServerInDC -IPAddress 192.168.1.3 -DnsName $name
}
# Set Registerkey so warning is gone in server manager
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
# Add DHCP failover
Add-DhcpServerv4Failover -ComputerName $primaryDHCP -Name "DHCP-FailoverDC2" -PartnerServer $name -ScopeId $scope -SharedSecret "P@ssw0rd"