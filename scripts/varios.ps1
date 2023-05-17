write-host -back Black -fore Black .
write-host -back Black -fore Green Instalando TotalCommander
Invoke-RestMethod soporte.solinges.com.ar/total | Invoke-Expression

write-host -back Black -fore Black .
write-host -back Black -fore Green Instalando Office
Invoke-RestMethod soporte.solinges.com.ar/office64 | Invoke-Expression

write-host -back Black -fore Black .
write-host -back Black -fore Green Instalando Chrome
Invoke-RestMethod soporte.solinges.com.ar/chrome | Invoke-Expression

write-host -back Black -fore Black .
write-host -back Black -fore Green Instalando AutoInst
Invoke-RestMethod soporte.solinges.com.ar/autoinst | Invoke-Expression

write-host -back Black -fore Black .
write-host -back Black -fore Green Activando Office
Invoke-RestMethod soporte.solinges.com.ar/activar | Invoke-Expression

