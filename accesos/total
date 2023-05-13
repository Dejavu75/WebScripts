$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://totalcommander.ch/1052/tcmd1052x64.exe'

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\tcmd1052x64.exe" } else { "$env:TEMP\tcmd1052x64.exe" }


Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing

Start-Process $FilePath -Wait

