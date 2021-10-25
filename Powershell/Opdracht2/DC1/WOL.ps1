# poort 9 gebruiken
$port = 9
$wol = "D:\Tom\MCT\Semester 5\NetworkScripting\Powershell\Opdracht2\DC1\WOL\bin\wol.exe"

$filter = Read-Host "Do you want to wake all clients, filter on hostname or wake with mac? (a for all, h for hostanme, m for mac address)"

if ($filter -eq "a") {
    $addresses = Get-DhcpServerv4Lease -ComputerName "DC1.intranet.mijnschool.be" -ScopeId 192.168.1.0 | select IPAddress, ClientId, HostName
    foreach ($address in $addresses) {
        $hostname = $address.HostName
        $clientID = $address.ClientId.Replace("-",":")
        Write-Host "Hostname: $hostname, id: $clientID"
        & $wol -v -p $port $clientID
    }
}
elseif ($filter -eq "h") {
    $addresses = Get-DhcpServerv4Lease -ComputerName "DC1.intranet.mijnschool.be" -ScopeId 192.168.1.0 | select IPAddress, ClientId, HostName
    $hostname = Read-Host "Wich hosts should be waked up?"
    foreach ($address in $address) {
        $hostname = $address.HostName
        $clientID = $address.ClientId.Replace("-",":")
        if ($hostname -ccontains $hostname) {
            Write-Host "Hostname: $hostname, id: $clientID"
            & $wol -v -p $port $clientID
        }
    }
}
elseif ($filter -eq "m") {
    $macs = @()
    $newMAC = Read-Host "First MAC address seperated by : (q to quit): "
    while ($newMAC -ne "q") {
     $macs += $newMAC
     $newMAC = Read-Host "Next MAC address seperated by : (q to quit): "
    }
    foreach ($mac in $macs) {
        & $wol -v -p $port $mac
    }
}
else {
    Write-Host "Invalid option"
}