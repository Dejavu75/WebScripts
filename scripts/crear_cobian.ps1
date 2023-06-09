
$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://soporte.solinges.com.ar/cobian.lst'

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\cobian.lst" } else { "$env:TEMP\cobian.lst" }

try {
    write-host -back Black -fore Black .
    write-host -back black -fore Green Descargando ((Invoke-WebRequest -Uri $DownloadURL -Method Head).Headers."Content-Length"/1024/1024).ToString("N2") MB
    write-host -back Black -fore Black .       
}
catch {
    <#Do this if a terminating exception happens#>
}

Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing

# Definir la ruta de la carpeta raíz
$solingesPath = "C:\Servidor\Solinges"

# Definir la ruta de la carpeta System
$systemPath = Join-Path $solingesPath "System"
$BackupPath = Join-Path $solingesPath "Backup"

$DepositoPath = Join-Path $BackupPath "GES"
$DiarioPath = Join-Path $BackupPath $Emp 

# Lee el contenido del archivo
$contenido = Get-Content $FilePath

$contenido = $contenido -replace "c:\Sistema\Backups\AVI", $DiarioPath
$contenido = $contenido -replace "c:\Sistema\System", $systemPath
$contenido = $contenido -replace "c:\Sistema\Backups\GES", $DepositoPath


# Guarda el contenido modificado en el archivo
write-host $contenido
$contenido | Set-Content $FilePath

# Ruta de destino
$destino = Join-Path -Path $PWD.Path -ChildPath (Split-Path -Path $FilePath -Leaf)

# Copiar el archivo al destino
Copy-Item -Path $FilePath -Destination $destino

Write-Host "El archivo se ha creado..."