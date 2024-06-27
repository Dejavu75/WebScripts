$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://soporte.solinges.com.ar/cobian.lst'

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\cobian.lst" } else { "$env:TEMP\cobian.lst" }

Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing

$Emp = Read-Host "Ingrese el nombre de la empresa para el backup (EMP)"
if ($Emp -eq "") {
    $Emp = "EMP"
}
# Define the directories to search for version.dbf
$searchDirectories = @(
    'c:\Servidor\solinges\system',
    'c:\Servidor\Sistema\system',
    'c:\Servidor\Sistema\2000\system',
    'c:\Sistema\system',
    'c:\Sistema\2000\system'
    'd:\Servidor\solinges\system',
    'd:\Servidor\Sistema\system',
    'd:\Servidor\Sistema\2000\system',
    'd:\Sistema\system',
    'd:\Sistema\2000\system'    
)

$found = $false
$systemPath2 = ""

foreach ($dir in $searchDirectories) {
    if (Test-Path (Join-Path $dir 'version.dbf')) {
        $systemPath2 = $dir
        $found = $true
        break
    }
}

if ($found) {
    $solingesPath2 = Split-Path $systemPath2 -Parent
} else {
    $solingesPath2 = "C:\Servidor\Solinges"
}

$solingesPath = Read-Host "Ingrese el path base ($solingesPath2)"
if ($solingesPath -eq "") {
    $solingesPath = $solingesPath2
}
if (-not $found) {
    $systemPath2 = Join-Path $solingesPath "System"
}
$systemPath = Read-Host "Ingrese el path de System ($systemPath2)"
if ($systemPath -eq "") {
    $systemPath = $systemPath2
}

$BackupPath2 = Join-Path $solingesPath "Backups"
$BackupPath = Read-Host "Ingrese el path del backup ($BackupPath2)"
if ($BackupPath -eq "") {
    $BackupPath =$BackupPath2
}



$DepositoPath = Join-Path $BackupPath "GES"
$DiarioPath = Join-Path $BackupPath $Emp

$DefaDiario="%DefaDiario%"      # "c:\Sistema\Backups\AVI"
$DefaSystem="%DefaSystem%"      # "c:\Sistema\System"
$DefaDeposito="%DefaDeposito%"  # "c:\Sistema\Backups\GES"

# Lee el contenido del archivo
$contenido = Get-Content $FilePath

$contenido = $contenido -replace $DefaDiario, $DiarioPath
$contenido = $contenido -replace $DefaSystem, $systemPath
$contenido = $contenido -replace $DefaDeposito, $DepositoPath

# Ruta de destino
$destino = Join-Path -Path $solingesPath -ChildPath (Split-Path -Path $FilePath -Leaf)

# Ruta del archivo modificado
$modificadoDestino = Join-Path $solingesPath "cobian_original.lst"
# Eliminar el archivo modificado si ya existe antes de copiar y renombrar
if (Test-Path $modificadoDestino) {
    Remove-Item -Path $modificadoDestino -Force
}

# Copiar y renombrar el archivo original si ya existe
if (Test-Path $destino) {
    Remove-Item -Path $destino -Force
}

Copy-Item -Path $FilePath -Destination $destino -Force
Rename-Item -Path $destino -NewName "cobian_original.lst"



# Guarda el contenido modificado en el archivo
$contenido | Set-Content $FilePath -Encoding Unicode

# Copiar y renombrar el archivo modificado si ya existe
if (Test-Path $destino) {
    Remove-Item -Path $destino -Force
}


# Ruta del archivo modificado
$modificadoDestino = Join-Path $solingesPath "cobian_$Emp.lst"
# Eliminar el archivo modificado si ya existe antes de copiar y renombrar
if (Test-Path $modificadoDestino) {
    Remove-Item -Path $modificadoDestino -Force
}

Copy-Item -Path $FilePath -Destination $destino -Force
Rename-Item -Path $destino -NewName "cobian_$Emp.lst"

Write-Host "Resumen de directorios seteados:"
Write-Host "Ruta del sistema: $systemPath"
Write-Host "Ruta de backup: $BackupPath"
Write-Host "Ruta de deposito: $DepositoPath"
Write-Host "Ruta de backup diario: $DiarioPath"

Write-Host "El archivo se ha creado..."
