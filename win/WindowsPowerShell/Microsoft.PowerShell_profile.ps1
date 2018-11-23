Import-Module posh-git

function Global:prompt {
	$location = $PWD.tostring()
	$location = $location.
		replace("C:\Users\Aryan", "@").
		replace("@\Projects", "#")
	Write-VcsStatus
	Write-Host $location -ForegroundColor Blue
	Write-Host "PS>" -NoNewLine
	return " "
}

New-Alias npp "C:\Program Files (x86)\Notepad++\notepad++.exe"
$env:path += "C:\Users\Aryan\Projects\PATH"

# [console]::ForegroundColor = "White"
# [console]::BackgroundColor = "Black"
# Clear-Host



### WSL pass-through functions ###
function Global:g++         { &'C:\WINDOWS\system32\wsl.exe' $MyInvocation.MyCommand $args.replace('\', '/') }
function Global:objdump     { &'C:\WINDOWS\system32\wsl.exe' $MyInvocation.MyCommand $args.replace('\', '/') }
function Global:gcc         { &'C:\WINDOWS\system32\wsl.exe' $MyInvocation.MyCommand $args.replace('\', '/') }
function Global:make        { &'C:\WINDOWS\system32\wsl.exe' $MyInvocation.MyCommand $args.replace('\', '/') }
function Global:gdb         { &'C:\WINDOWS\system32\wsl.exe' $MyInvocation.MyCommand $args.replace('\', '/') }
