#errors
$domainCredential = "$env:USERDOMAIN\administrator"
$computer = "Win06-MS"
$path = "C:\Home"
New-PSSession -ComputerName $computer -Credential $domainCredential
Invoke-Command -ComputerName $computer -ScriptBlock {
    Write-Host $env:COMPUTERNAME
    New-Item -Path $path -ItemType Directory
    New-SmbShare -Name "Home" -Path $path -FullAccess "Everyone"

    $NewAcl = Get-Acl -Path $path
    $isProtected = $true
    $preserveInheritance = $true
    $NewAcl.SetAccessRuleProtection($isProtected, $preserveInheritance)
    Set-Acl -Path $path -AclObject $NewAcl
}
