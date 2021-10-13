# Read CSV
$GroupMembers = Import-Csv C:\Users\Administrator\Documents\NetworkScripting\NetworkScripting\OUStructuur\GroupMembers.csv -Delimiter ";"

ForEach($Member In $GroupMembers)
{
    $User = $Member.Member
    $Identity = $Member.Identity

    Write-Host "Adding $User to $Identity"

    # Add User to Group
    Add-ADGroupMember -Identity $Identity -Members $User
}