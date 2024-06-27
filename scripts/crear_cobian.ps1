$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://soporte.solinges.com.ar/cobian.lst'

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\cobian.lst" } else { "$env:TEMP\cobian.lst" }

try {
    Write-Host -BackgroundColor Black -ForegroundColor Black .
    Write-Host -BackgroundColor Black -ForegroundColor Green Descargando ((Invoke-WebRequest -Uri $DownloadURL -Method Head).Headers."Content-Length"/1024/1024).ToString("N2") MB
    Write-Host -BackgroundColor Black -ForegroundColor Black .
}
catch {
    <#Do this if a terminating exception happens#>
}

Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing

# Define the directories to search for version.dbf
$searchDirectories = @(
    'c:\Servidor\solinges\system',
    'c:\Servidor\Sistema\system',
    'c:\Servidor\Sistema\2000\system',
    'c:\Sistema\system',
    'c:\Sistema\2000\system'
)

$found = $false
$systemPath = ""

foreach ($dir in $searchDirectories) {
    if (Test-Path (Join-Path $dir 'version.dbf')) {
        $systemPath = $dir
        $found = $true
        break
    }
}

if (-not $found) {
    $solingesPath = Read-Host "Ingrese el path base (C:\Servidor\Solinges)"
    if ($solingesPath -eq "") {
        $solingesPath = "C:\Servidor\Solinges"
    }
    $systemPath = Join-Path $solingesPath "System"
}

$BackupPath = Join-Path $solingesPath "Backups"
$BackupPath = Read-Host "Ingrese el path del backup ($BackupPath)"
if ($BackupPath -eq "") {
    $BackupPath = Join-Path $solingesPath "Backups"
}

$Emp = Read-Host "Ingrese el nombre de la empresa para el backup (EMP)"
if ($Emp -eq "") {
    $Emp = "EMP"
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
$destino = Join-Path -Path $PWD.Path -ChildPath (Split-Path -Path $FilePath -Leaf)

if (Test-Path $destino) {
    Rename-Item -Path $destino -NewName ($destino + ".bak")
}

Copy-Item -Path $FilePath -Destination $destino
Rename-Item -Path $destino -NewName "cobian_original.lst"

# Guarda el contenido modificado en el archivo
$contenido | Set-Content $FilePath -Encoding Unicode

# Copiar el archivo al destino
if (Test-Path $destino) {
    Rename-Item -Path $destino -NewName ($destino + ".bak")
}
Copy-Item -Path $FilePath -Destination $destino
Rename-Item -Path $destino -NewName "cobian_$Emp.lst"

Write-Host "Resumen de directorios seteados:"
Write-Host "Ruta del sistema: $systemPath"
Write-Host "Ruta de backup: $BackupPath"
Write-Host "Ruta de deposito: $DepositoPath"
Write-Host "Ruta de backup diario: $DiarioPath"

Write-Host "El archivo se ha creado..."
