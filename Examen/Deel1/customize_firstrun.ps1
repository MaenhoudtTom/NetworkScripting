# Get volume with label boot and get the drive letter of that label
$scriptDrive = Get-Volume -FileSystemLabel boot
$driveLetter = $scriptDrive.DriveLetter

# Get path to file with driveletter of that label, first path is on my local pc for testing
#$pathToFile = "D:\Tom\MCT\Semester_5\NetworkScripting\Examen\Deel1\firstrun.sh"
$pathToFile = "$driveLetter`:\firstrun.sh"

# Put all the contents in variable
$content = "`n# start fallback preconfig`"`n"
$content = $content + "file=`"/etc/dhcpcd.conf`"`n"
$content = $content + "sed -i 's/#profile static_eth0/profile static_eth0/' $file`n"
$content = $content + "sed -i 's/#static ip_address=192.168.1.23/static ip_address=192.168.168.168/' $file`n"
$content = $content + "line=``grep -n '# fallback to static profile' $file | awk -F: '{ print $1 }'```n"
$content = $content + "sed -i `'`$line,$ s/#interface eth0/interface eth0/`' $file`n"
$content = $content + "sed -i 's/#fallback static_eth0/arping 192.168.66.6\nfallback static_eth0/' $file`n"
$content = $content + "# end fallback preconfig"

# Get content of file
$fileContent = Get-Content $pathToFile

# Check line
$lineToCheck = $fileContent[39].Substring(0,1)
if($lineToCheck -ne "#")
{
# Add content
    $fileContent[38] += $content
}
#Add file content
$fileContent | Set-Content $pathToFile