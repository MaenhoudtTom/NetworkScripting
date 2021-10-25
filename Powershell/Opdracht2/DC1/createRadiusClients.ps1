#  this script is based of the syntax that is used when exporting a list of RADIUS clients from NPS.
# see file RadiusclientsSyntaxExample for syntax example

# path to file is the location where the file with RADIUS clients is stored.
$pathToFile = Read-Host -Prompt 'Path to file: ';

# sharedSecret is the secret that is used to authenticate the clients.
$sharedSecret = 'tgNTzUzrbi7cVQe';

Write-Host 'Creating radius clients';

# this for loop goes over each line in the file and creates the RADIUS clients.
foreach($line in [System.IO.File]::ReadLines($pathToFile))
{
    # split the line and make an array
    $array = $line.Split('`t');

    # get the name of the client
    $name = $array[0];

    # get the IP-address of the client
    $address = $array[1];
    
    # create the client with the params IP-address, name, sharedSecret.
    New-NpsRadiusClient -Address "$address" -Name "$name" -SharedSecret "sharedSecret"
}