$newUpn = "mijnschool.be"
Get-ADForest | Set-ADForest -UPNSuffixes @{add= $newUpn}
Get-ADUser -Filter {UserPrincipalName -like '*intranet.mijnschool.be'} -Properties UserPrincipalName -ResultSetSize $null
$LocalUsers | foreach {$newUpn = $_.UserPrincipalName.Replace("intranet.mijnschool.be",$newUpn); $_ | Set-ADUser -UserPrincipalName $newUpn}