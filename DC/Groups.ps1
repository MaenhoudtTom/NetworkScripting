$path = "C:\Users\Administrator\Documents\NetworkScripting\NetworkScripting\OUStructuur\Groups.csv"
$Groups = Import-Csv -Path $path -Delimiter ";"

Foreach ($Group in $Groups) {
    $Path = $Group.Path
    $Description = $Group.Description
    $GroupCategory = $Group.GroupCategory
    $GroupScope = $Group.GroupScope
    $Name = $Group.Name

    #Write-Host $Description

    #if ($GroupScope -eq "DomainLocal")
    #{
    #    $Name = "DLG_$Name"
    #}
    #elseif($GroupScope -eq "Global")
    #{
    #    $Name = "GG_$Name"
    #}

    #Write-Host "Name: $Name"
    #Write-Host ""

    New-ADGroup -Path $Path -Description $Description -Name $Name -GroupCategory $GroupCategory -GroupScope $GroupScope
}