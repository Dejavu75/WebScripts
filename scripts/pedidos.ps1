$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://soporte.solinges.com.ar/pedidos_setup.exe'

write-host -back Black -fore Black .
write-host -back black -fore Green Descargando ((Invoke-WebRequest -Uri $DownloadURL -Method Head).Headers."Content-Length"/1024/1024).ToString("N2") MB
write-host -back Black -fore Black .

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\pedidos_setup.exe" } else { "$env:TEMP\pedidos_setup.exe" }


Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing
copy $filePath C:\Soporte\pedidos_setup.exe
Start-Process C:\Soporte\pedidos_setup.exe /silent -Wait
write-host -back Black -fore Black .
write-host -back Black -fore Green Script terminado... 
write-host -back Black -fore Black .
write-host -back Black -fore Green Presione una tecla para cerrar el PowerShell 
$Key = [Console]::ReadKey($True)
exit