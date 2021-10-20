$domainCredential = "$env:USERDOMAIN\administrator"
$computer = "Win06-DC2"

# Connect to remote pc
New-PSSession -ComputerName $computer -Credential $domainCredential
Invoke-Command -ComputerName $computer -ScriptBlock {
$Site = "Kortrijk"
$domain = "intranet.mijnschool.be"

# Install AD services
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Credential($domainCredential)
Install-ADDSDomainController -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainName $domain -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoGlobalCatalog:$false -SiteName $Site -SysvolPath 'C:\Windows\SYSVOL' -NoRebootOnCompletion:$true -Force:$true -Credential (Get-Credential $domainCredential)
# Restart computer so changes can take place
Restart-Computer
} -ArgumentList $domainCredential