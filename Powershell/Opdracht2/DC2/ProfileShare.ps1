$domainCredential = "$env:USERDOMAIN\administrator"
$computer = "Win06-DC2"

# Connect to remote pc
New-PSSession -ComputerName $computer -Credential $domainCredential
Invoke-Command -ComputerName $computer -ScriptBlock {
    $path = "C:\Profile"
    # Create Home directory
    New-Item -Path $path -ItemType Directory
    # Share the folder with fullAccess to everyone
    New-SmbShare -Name 'Profile$' -Path $path -FullAccess "Everyone"

    # Set NTFS rules
    $NewAcl = Get-Acl -Path $path
    $isProtected = $true
    $preserveInheritance = $false
    $NewAcl.SetAccessRuleProtection($isProtected, $preserveInheritance)

    $accesRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit, objectInherit", "None", "Allow")
    $NewAcl.AddAccessRule($accesRule)
    $accesRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users", "Modify", "None", "None", "Allow")
    $NewAcl.AddAccessRule($accesRule)

    Set-Acl -Path $path -AclObject $NewAcl
}