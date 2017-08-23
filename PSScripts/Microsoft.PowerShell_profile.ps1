# https://stackoverflow.com/questions/24914589/how-to-create-permanent-powershell-aliases

# Set alias so edit opens npp
New-Alias npp "C:\Program Files\Notepad++\notepad++.exe"

# Change working directory to C:\WORKING\
function Set-LocationToWorking { Set-Location "C:\WORKING\" }
New-Alias work Set-LocationToWorking
