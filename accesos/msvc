$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://soporte.solinges.com.ar/vcredist_x86.exe'
write-host -back Black -fore Black .
write-host -back black -fore Green Descargando ((Invoke-WebRequest -Uri $DownloadURL -Method Head).Headers."Content-Length"/1024/1024).ToString("N2") MB
write-host -back Black -fore Black .

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\vcredist_x86.exe" } else { "$env:TEMP\vcredist_x86.exe" }


Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing

$ScriptArgs = " /passive "

Start-Process $FilePath $ScriptArgs -Wait

#$FilePaths = @("$env:TEMP\vcredist_x86.exe", "$env:SystemRoot\Temp\vcredist_x86.exe")
#foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }$content
write-host -back Black -fore Black .
write-host -back Black -fore Green Script terminado... 
write-host -back Black -fore Black .
write-host -back Black -fore Green Presione una tecla para cerrar el PowerShell 
$Key = [Console]::ReadKey($True)
exit


