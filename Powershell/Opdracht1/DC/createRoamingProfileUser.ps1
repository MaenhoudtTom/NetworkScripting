$users = Get-ADGroupMember -Identity Secretariaat

foreach ($user in $users) {
$name = $user.SamAccountName
Set-ADUser -Identity $user -Profilepath "\\Win06-DC2\Profile$\$name"
}