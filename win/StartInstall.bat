
REM https://superuser.com/questions/616106/set-executionpolicy-using-batch-file-powershell-script

@powerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList 'Set-ExecutionPolicy Unrestricted -Force -Scope CurrentUser' -Verb RunAs}"
@powershell -NoProfile -File .\Install-All.ps1