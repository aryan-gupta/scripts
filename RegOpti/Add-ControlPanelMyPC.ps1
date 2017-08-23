
Write-Host "Add Control Panel to My PC in Explorer"

$path = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{645FF040-5081-101B-9F08-00AA002F954E}"
# $name = 
# $type = 
# $val  = 

New-Item -Path $path -Force | Out-Null
# New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null