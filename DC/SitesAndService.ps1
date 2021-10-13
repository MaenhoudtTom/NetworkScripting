# Rename first site
$FirstSiteName = "Kortrijk"
$SecondSiteName = "Brugge"

$FirstSubnet = "192.168.1.0/24"
$SecondSubnet = "192.168.2.0/24"

# Rename Default first site
Get-ADReplicationSite Default-First-Site-Name | Rename-ADObject -NewName $FirstSiteName
Get-ADReplicationSite $FirstSiteName | Set-ADReplicationSite -Description $FirstSiteName
New-ADReplicationSubnet -Name $FirstSubnet -Location $FirstSiteName -Description $FirstSiteName -Site $FirstSiteName

# Create second site
New-ADReplicationSite $SecondSiteName -Description $SecondSiteName
New-ADReplicationSubnet -Name $SecondSubnet -Description $SecondSiteName -Site $SecondSiteName -Location $SecondSiteName