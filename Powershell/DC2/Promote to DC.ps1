$Domain = "intranet.mijnschool.be"
# Install AD services
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName $Domain -InstallDNS