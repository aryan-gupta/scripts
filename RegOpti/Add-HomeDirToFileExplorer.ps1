
Write-Host "Add User Folder to Navagational Pane in File Explorer"

# Create the key if the hey hasnt been created before
$path = "Registry::HKEY_CLASSES_ROOT\CLSID\{8f82c18d-c7f8-47bb-8e87-8d281b5b0dac}"
New-Item -Path $path -Force | Out-Null

# Add the new Values for the Key
$name = "(Default)"
$type = "String"
$val  = "Aryan Home"
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null

$name = "DescriptionID"
$type = "DWORD"
$val  = "3"
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null

$name = "Infotip"
$type = "String"
$val  = "Home Folder"
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null

$name = "System.IsPinnedToNameSpaceTree"
$type = "DWORD"
$val  = "1"
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null

$name = "SortOrderIndex"
$type = "DWORD"
$val  = "30"
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null


# 
$path = "Registry::HKEY_CLASSES_ROOT\CLSID\{8f82c18d-c7f8-47bb-8e87-8d281b5b0dac}\DefaultIcon"
$name = "(Default)"
$type = "String"
$val  = "%SystemRoot%\\system32\\shell32.dll,160"
New-Item -Path $path -Force | Out-Null
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null


#
$path = "Registry::HKEY_CLASSES_ROOT\CLSID\{8f82c18d-c7f8-47bb-8e87-8d281b5b0dac}\InProcServer32"
$name = "(Default)"
$type = "Binary"
$val  = "25,00,73,00,79,00,73,00,74,00,65,00,6d,00,72,00,6f,00,6f,00,74,00,25,00,5c,00,73,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,73,00,68,00,65,00,6c,00,6c,00,33,00,32,00,2e,00,64,00,6c,00,6c,00,00,00"
New-Item -Path $path -Force | Out-Null
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null

