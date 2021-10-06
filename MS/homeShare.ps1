$domainCredential = "$env:USERDOMAIN\administrator"
$computer = "Win06-MS"

New-PSSession -ComputerName $computer -Credential $domainCredential
Invoke-Command -ComputerName $computer -ScriptBlock {
    $path = "C:\Home"
    Write-Host $env:COMPUTERNAME
    Write-Host $path
    New-Item -Path $path -ItemType Directory
    New-SmbShare -Name "Home" -Path $path -FullAccess "Everyone"

    $NewAcl = Get-Acl -Path $path
    $isProtected = $true
    $preserveInheritance = $false
    $NewAcl.SetAccessRuleProtection($isProtected, $preserveInheritance)

    $accesRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit, objectInherit", "None", "Allow")
    $NewAcl.AddAccessRule($accesRule)
    $accesRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users", "ReadAndExecute", "None", "None", "Allow")
    $NewAcl.AddAccessRule($accesRule)

    Set-Acl -Path $path -AclObject $NewAcl
}