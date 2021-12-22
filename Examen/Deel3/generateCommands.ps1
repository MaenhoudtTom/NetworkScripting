$pathToFile = "D:\Tom\MCT\Semester_5\NetworkScripting\Examen\Deel3\LVL-2-POE-config.txt"



$nameFile = "$hostname-$ipVlan1.txt"
$pathToDestinationFile = "D:\Tom\MCT\Semester_5\NetworkScripting\Examen\Deel3\$nameFile"

foreach($line in [System.IO.File]::ReadLines($pathToFile))
{
    $array = $line.Split(" ");
    "vlan 999" >> $pathToDestinationFile
    "name VL.999" >> $pathToDestinationFile
    "interface vlan999" >> $pathToDestinationFile
    "description VL.999" >> $pathToDestinationFile
    'no ip address' >> $pathToDestinationFile
    'no shut' >> $pathToDestinationFile
}