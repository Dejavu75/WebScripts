

$usuario = "Everyone"

# Definir la ruta de la carpeta raíz
$rootPath = Read-Host "Ingrese el path base (C:\Servidor)"
if ($rootPath -eq "") {
    $rootPath = "C:\Servidor"
}


# Definir la ruta de la carpeta System
$solingesPath = Join-Path $rootPath "Solinges"
$systemPath = Join-Path $solingesPath "System"

# Crear la carpeta System si no existe
if (-not (Test-Path $systemPath)) {
    New-Item -ItemType Directory -Path $systemPath -Force | Out-Null
    write-host -back black -fore Green Creando $systemPath
}

write-host -back black -fore Green Compartiendo $systemPath
# Compartir la carpeta System con el nombre de recurso GES$

# Verificar si el recurso compartido GES$ existe y eliminarlo si es necesario
if (Get-SmbShare -Name "GES$" -ErrorAction SilentlyContinue) {
    Remove-SmbShare -Name "GES$" -Force
}


write-host -back black -fore Green Intentando con $usuario
New-SmbShare -Name "GES$" -Path $systemPath -FullAccess $usuario -ErrorAction SilentlyContinue  | Out-Null
if (!$?) {
    $usuario = "Todos"
    write-host -back black -fore Green Dio error, pasando a $usuario
    New-SmbShare -Name "GES$" -Path $systemPath -FullAccess $usuario | Out-Null
}


# Asignar permisos NFTS para modificación a todos los usuarios en la carpeta System
write-host -back black -fore Green Asignando permisos a $systemPath
$systemAcl = Get-Acl $rootPath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($usuario, "Modify", "Allow")
$systemAcl.SetAccessRule($rule)
Set-Acl $rootPath $systemAcl 



write-host -back black -fore Green Creando carpetas adicionales... 
# Crear la carpeta Soporte si no existe

$supportPath = Join-Path $rootPath "Soporte"
if (-not (Test-Path $supportPath)) {
    New-Item -ItemType Directory -Path $supportPath -Force | Out-Null
    New-SmbShare -Name "Soporte" -Path $supportPath -FullAccess $usuario | Out-Null
}

# Crear la carpeta Backups si no existe
$backupsPath = Join-Path $solingesPath "Backups"
if (-not (Test-Path $backupsPath)) {
    New-Item -ItemType Directory -Path $backupsPath -Force | Out-Null
}

# Crear la carpeta GES dentro de Backups si no existe
$gesPath = Join-Path $backupsPath "GES"
if (-not (Test-Path $gesPath)) {
    New-Item -ItemType Directory -Path $gesPath -Force | Out-Null
}

# Pedir al usuario el nombre de la subcarpeta Backups\EMP
$subfolderName = Read-Host "Ingrese el nombre de la empresa para el backup (EMP)"
if ($subfolderName -eq "") {
    $subfolderName = "EMP"
}
# Crear la subcarpeta EMP dentro de Backups si no existe
$empPath = Join-Path $backupsPath $subfolderName
if (-not (Test-Path $empPath)) {
    New-Item -ItemType Directory -Path $empPath -Force | Out-Null
}

$pfdsPath = Join-Path $rootPath "PDFs"
if (-not (Test-Path $pfdsPath)) {
    New-Item -ItemType Directory -Path $pfdsPath -Force | Out-Null
    New-SmbShare -Name "PDFs" -Path $pfdsPath -FullAccess $usuario | Out-Null
}

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://soporte.solinges.com.ar/autoinstv48.zip'
$FilePath = ($supportPath+"\autoinstv48.zip")

write-host -back Black -fore Black .
write-host -back black -fore Green Descargando ((Invoke-WebRequest -Uri $DownloadURL -Method Head).Headers."Content-Length"/1024/1024).ToString("N2") MB
write-host -back Black -fore Black .
Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing

Expand-Archive -Path $FilePath -DestinationPath $supportPath

$DownloadURL = 'https://soporte.solinges.com.ar/cobian.zip'
$FilePath = ($supportPath+"\cobian.zip")

write-host -back Black -fore Black .
write-host -back black -fore Green Descargando ((Invoke-WebRequest -Uri $DownloadURL -Method Head).Headers."Content-Length"/1024/1024).ToString("N2") MB
write-host -back Black -fore Black .
Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing

Expand-Archive -Path $FilePath -DestinationPath $supportPath

Set-Location $rootPat
$AutoInst = Join-Path $rootPath "AutoInstv48\Instalar.bat"
Start-Process $AutoInst -Wait