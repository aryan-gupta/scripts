
Write-Host "Add Encrypt and Decrypt to right click Context Menu"

$path = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$name = "EncryptionContextMenu"
$type = "DWORD"
$val  = "1"

New-Item -Path $path -Force | Out-Null
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null
