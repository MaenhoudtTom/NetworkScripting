# Read CSV file
$path = "C:\Users\Administrator\Documents\NetworkScripting\NetworkScripting\OUStructuur\Groups.csv"
$Groups = Import-Csv -Path $path -Delimiter ";"

# For loop for each object in file
Foreach ($Group in $Groups) {
    $Path = $Group.Path
    $Description = $Group.Description
    $GroupCategory = $Group.GroupCategory
    $GroupScope = $Group.GroupScope
    $Name = $Group.Name

    #Write-Host $Description

    # IF else to add DLG and GG to group names, adjust UserToGroup.ps1 if needed 
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

    # Create groups
    New-ADGroup -Path $Path -Description $Description -Name $Name -GroupCategory $GroupCategory -GroupScope $GroupScope
}