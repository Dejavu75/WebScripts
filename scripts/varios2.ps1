write-host -back Black -fore Black .
write-host -back Black -fore Instalando TotalCommander
Invoke-RestMethod soporte.solinges.com.ar/total | Invoke-Expression

write-host -back Black -fore Black .
write-host -back Black -fore Instalando Office
Invoke-RestMethod soporte.solinges.com.ar/office64 | Invoke-Expression

write-host -back Black -fore Black .
write-host -back Black -fore Instalando Chrome
Invoke-RestMethod soporte.solinges.com.ar/chrome | Invoke-Expression

write-host -back Black -fore Black .
write-host -back Black -fore Activando Office
Invoke-RestMethod soporte.solinges.com.ar/activar | Invoke-Expression