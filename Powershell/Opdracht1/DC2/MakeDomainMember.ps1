$domainCredential = "$env:USERDOMAIN\administrator"
$computer = "Win06-DC2"

# Connect to remote pc
New-PSSession -ComputerName $computer -Credential $domainCredential
Invoke-Command -ComputerName $computer -ScriptBlock {
    # Join domain
    Add-Computer -DomainName intranet.mijnschool.be -Restart
}