$path = "C:\Users\Administrator\Documents\NetworkScripting\NetworkScripting\OUStructuur\UserAccounts.csv"
$UserAccounts = Import-Csv -Path $path -Delimiter ";"

Foreach ($user in $UserAccounts) {
    $UPN = "mijnschool.be"
    $Name = $user.Name
    $SamAccountName = $user.SamAccountName
    $GivenName = $user.GivenName
    $Surname = $user.Surname
    $DisplayName = $user.DisplayName
    $Pswd = ConvertTo-SecureString $user.AccountPassword -AsPlainText -Force
    $HomeDrive = $user.HomeDrive
    $HomeDirectory = "\\win06-MS\Home\$Name"
    $ScriptPath = $user.ScriptPath
    $Path = $user.Path
    $HomeFolderPath = "\\Win06-MS\Home\$Name"

    New-ADUser -Name $Name -SamAccountName $SamAccountName -GivenName $GivenName -Surname $Surname -DisplayName $DisplayName -AccountPassword $Pswd -HomeDrive $HomeDrive -HomeDirectory $HomeDirectory -ScriptPath $ScriptPath -Path $Path -UserPrincipalName "$Name@$UPN"
    Enable-ADAccount -Identity $Name
    Write-Host "User $Name is created"

    New-Item -Path $HomeFolderPath -ItemType Directory
    Write-Host "Home folder for $Name created"

    $NewAcl = Get-Acl -Path $HomeFolderPath
    $NewAcl.SetAccessRuleProtection($false, $true)
    $accesRule = New-Object System.Security.AccessControl.FileSystemAccessRule($Name, "Modify", "ContainerInherit, objectInherit", "None", "Allow")
    $NewAcl.AddAccessRule($accesRule)

    Set-Acl -Path $HomeFolderPath -AclObject $NewAcl
    Write-Host "Home Folder for $Name created"
}