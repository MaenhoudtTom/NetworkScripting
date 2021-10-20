# Read CSV
$path = "C:\Users\Administrator\Documents\NetworkScripting\NetworkScripting\OUStructuur\OUs.csv"

$OUs = Import-Csv -Path $path -Delimiter ";"
#Write-Host $OUs

Foreach ($OU in $OUs) {
    $DisplayName = $OU.'Display Name'
    $Name = $OU.Name
    $Description = $OU.Description
    $Path = $OU.Path

    # Create OU
    New-ADOrganizationalUnit -DisplayName $DisplayName -Name $Name -Description $Description -Path $Path
    Write-Host "OU $Name is created"
}