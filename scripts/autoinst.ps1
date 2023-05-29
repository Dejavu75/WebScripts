$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://soporte.solinges.com.ar/autoinstv47.zip'

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\autoinstv47.zip" } else { "$env:TEMP\autoinstv47.zip" }

try {
    write-host -back Black -fore Black .
    write-host -back black -fore Green Descargando ((Invoke-WebRequest -Uri $DownloadURL -Method Head).Headers."Content-Length"/1024/1024).ToString("N2") MB
    write-host -back Black -fore Black .       
}
catch {
    <#Do this if a terminating exception happens#>
}

Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing

Expand-Archive -Path $FilePath -DestinationPath C:\Soporte

Start-Process C:\Soporte\AutoInstv47\Instalar.bat -Wait
write-host -back Black -fore Black .
write-host -back Black -fore Green Script terminado... 
write-host -back Black -fore Black .
write-host -back Black -fore Green Presione una tecla para cerrar el PowerShell 
 = [Console]::ReadKey($True)
exit

