
Write-Host "Add 'Copy to' to the Right click Context menu"

$path = "Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To"
$name = "(Default)"
$type = "String"
$val  = "{C2FBB630-2971-11D1-A18C-00C04FD75D13}"

New-Item -Path $path -Force | Out-Null
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null

# ======

Write-Host "Add 'Move to' to the Right click Context menu"

$path = "Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To"
$name = "(Default)"
$type = "String"
$val  = "{C2FBB631-2971-11D1-A18C-00C04FD75D13}"

New-Item -Path $path -Force | Out-Null
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null
