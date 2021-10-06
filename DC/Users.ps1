#errors
$path = "C:\Users\Administrator\Documents\NetworkScripting\NetworkScripting\OUStructuur\UserAccounts.csv"
Write-Host $path
$UserAccounts = Import-Csv -Path $path -Delimiter ";"

Foreach ($user in $UserAccounts) {
    $Name = $user.Name
    $SamAccountName = $user.SamAccountName
    $GivenName = $user.GivenName
    $Surname = $user.Surname
    $DisplayName = $user.DisplayName
    $Pswd = ConvertTo-SecureString $user.AccountPassword -AsPlainText -Force
    $HomeDrive = $user.HomeDrive
    $HomeDirectory = $user.HomeDirectory
    $ScriptPath = $user.ScriptPath
    $Path = $user.Path
    $HomeFolderPath = "\\Win06-MS\Home\$Name"
    
    New-Item -Path $HomeFolderPath -ItemType Directory
    Write-Host "Home folder for $Name created"

    $NewAcl = Get-Acl -Path $HomeFolderPath
    $NewAcl.SetAccessRule($false, $true)
    $accesRule = New-Object System.Security.AccessControl.FileSystemAccessRule($Name, "Modify", "ContainerInherit, objectInherit", "None", "Allow")
    Write-Host $accesRule
    $NewAcl.AddAccessRule($accesRule)
    Write-Host "Home Folder for $Name created"

    Set-Acl -Path $HomeFolderPath -AclObject $NewAcl

    #New-ADUser -Name $Name -SamAccountName $SamAccountName -GivenName $GivenName -Surname $Surname -DisplayName $DisplayName -AccountPassword $Pswd -HomeDrive $HomeDrive -HomeDirectory $HomeDirectory -ScriptPath $ScriptPath -Path $Path
    Write-Host "User $Name is created"
}