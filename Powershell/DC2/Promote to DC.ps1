$domainCredential = "$env:USERDOMAIN\administrator"
$computer = "Win06-DC2"
$domain = "intranet.mijnschool.be"

# Connect to remote pc
New-PSSession -ComputerName $computer -Credential $domainCredential
Invoke-Command -ComputerName $computer -ScriptBlock {
# Install AD services
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSDomainController -InstallDns -DomainName $domain
}