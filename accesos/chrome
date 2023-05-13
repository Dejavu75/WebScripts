$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BB9129725-553A-F531-AE59-319DC55213BA%7D%26lang%3Des%26browser%3D5%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26brand%3DYTUH%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe'

write-host -back Black -fore Black .
write-host -back black -fore Green Descargando ((Invoke-WebRequest -Uri $DownloadURL -Method Head).Headers."Content-Length"/1024/1024).ToString("N2") MB
write-host -back Black -fore Black .

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\ChromeSetup.exe" } else { "$env:TEMP\ChromeSetup.exe" }


Invoke-WebRequest -Uri $DownloadURL -OutFile $FilePath -UseBasicParsing

Start-Process $FilePath


