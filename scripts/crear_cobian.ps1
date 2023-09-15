
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

Copy-Item -Path $FilePath -Destination $destino

$DefaDiario="%DefaDiario%"      # "c:\Sistema\Backups\AVI"
$DefaSystem="%DefaSystem%"      # "c:\Sistema\System"
$DefaDeposito="%DefaDeposito%"  # "c:\Sistema\Backups\GES"


$Emp = Read-Host "Ingrese el nombre de la empresa para el backup (EMP)"
# Definir la ruta de la carpeta raíz
$solingesPath = "C:\Servidor\Solinges"

# Definir la ruta de la carpeta System
$systemPath = Join-Path $solingesPath "System"
$BackupPath = Join-Path $solingesPath "Backup"

$DepositoPath = Join-Path $BackupPath "GES"
$DiarioPath = Join-Path $BackupPath $Emp 

# Lee el contenido del archivo
$contenido = Get-Content $FilePath

$contenido = $contenido -replace $DefaDiario, $DiarioPath
$contenido = $contenido -replace $DefaSystem, $systemPath
$contenido = $contenido -replace $DefaDeposito, $DepositoPath

# Ruta de destino
$destino = Join-Path -Path $PWD.Path -ChildPath (Split-Path -Path $FilePath -Leaf)

Copy-Item -Path $FilePath -Destination $destino
Rename-Item -Path $destino -NewName "cobian_original.lst"

# Guarda el contenido modificado en el archivo
#write-host $contenido
$contenido | Set-Content $FilePath -Encoding Unicode  


# Copiar el archivo al destino
Copy-Item -Path $FilePath -Destination $destino
Rename-Item -Path $destino -NewName "cobian_$Emp.lst"

Write-Host "El archivo se ha creado..."