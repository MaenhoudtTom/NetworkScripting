$path = "\\DC1\NETLOGON\login.bat"

# Create Home directory
New-Item -Path $path -ItemType File -Value "@echo off `nnet use P: \\win06-ms\Public"