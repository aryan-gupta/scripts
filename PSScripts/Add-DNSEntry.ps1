
[CmdletBinding()]
Param (
	[Parameter (Mandatory = $true, Position = 1)]
	[string] $Name,
	
	[Parameter (Mandatory = $true, Position = 2)]
	[IPAddress] $IP,
	
	[string] $Type = 'A',
	[switch] $Force
)

$DNS_SERVER = 'electron'
$DNS_ROOT   = 'Root'
$DNS_DIR    = 'Program Files\ISC BIND 9\etc\master\db'

$PS_DATA_DIR = "$ENV:Home\Documents\PSData"
$DRIVE_LTR = 'T'

$DNS_DB = 'gempi.re.db'
$DNS_REVDB = '0.168.192.in-addr.arpa.db'

$DOMAIN_SUFFIX = 'gempi.re'

. "$PS_DATA_DIR\$DNS_SERVER.ps1" # dot source our credentials

$server_cred = Get-Variable -Name $DNS_SERVER -ValueOnly
$password = $server_cred.Password | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($server_cred.Username, $password)

$root = '\\' + $DNS_SERVER + '.' + $DOMAIN_SUFFIX + '\' + $DNS_ROOT + '\' + $DNS_DIR
New-PSDrive -Name $DRIVE_LTR -PSProvider Filesystem -Root $root -Credential $credential | Out-Null

$splitStr = '; other computers'

# The DNS records are split into 2 parts the pre-text wich includes the current zone
# and the actual recods for the domains. The first part of the foreach loop goes through
# skipping all the pre-text. Once it finds the first record (by setting $start high) then
# the script starts parsing.

$fwddb = $DRIVE_LTR + ':\' + $DNS_DB
$start = $false # this bool variable states when we should start parsing the file
# the file starts of with TTL and Serial data that we want to skip
$exists = $false
$lastByteNew = $IP.getAddressBytes()[3]
$dbcontent = Get-Content -Path $fwddb

# Prechecks
# checks that the new hostname doesnt already exists
# and checks if the new IP adress wont conflict with another entry
foreach ($line in $dbcontent) {	
	if ($line -eq '') { continue } # skip empty lines
	
	if ($start) { # we have started to parse the actual records
		$line = $line -replace '\s+', ' ' # we want to delete duplicate spaces
		$sline = $line.split() # Split by space
		
		$lastByteExisting = [int](($sline[3]).split('.')[3]) # Get ipadress from line
		# split it by period to get the last octet/byte then convert it to a int
		
		if ($lastByteExisting -eq $lastByteNew) { # Found same ip record
			if ($sline[0] -ne $Name) {
				# If the new IP address will conflict with another record then we want to output
				# an error
				Write-Error "IP Conflict found. Host '$($sline[0])' will have same IP as new record: '$($sline[3])'"
				Exit
			} else {
				Write-Host 'Record already exists, exiting...'
				Exit
			}			
		}
		
		if ($sline[0] -eq $Name) { # the hostname already exists
			if ($Force) {
				$exists = $true;
				break
			} else {
				Write-Error 'This hostname already exists. If you would like to force edit this host, please use the -Force switch'
				Exit
			}
		}
	}
	
	if ($line -eq $splitStr) { $start = $true } # if its pre-text just skip it
}

$start = $false
$newContent = '' # I want to organize the entries by increasing ip number
# so Im doing going to insert it rather than append it
$added = $false

foreach ($line in $dbcontent) {
	$sline = @('') # array of strings
	
	if ($start -and ($line -ne '')) { # skip parsing blank lines
		$linends = $line -replace '\s+', ' ' # we want to delete duplicate spaces
		$sline = $linends.split() # Split by space
		
		$lastByteExisting = [int](($sline[3]).split('.')[3]) # Get ipadress from line
		# split it by period to get the last octet/byte then convert it to a int
		
		if ($lastByteExisting -gt $lastByteNew) { #insert new record
			$newContent += $Name + '     IN      ' + $Type + '       ' + $IP.toString() + "`r`n"
			$start = $false
			$sline[0] = '' # this is so the if statement later doesn't break
			# this variable wont be updated anymore, so we need this so it doesnt skip
			# the rest of the entries
			$added = $true
		}
	}
	
	if ($line -eq $splitStr) { $start = $true } # if its pre-text just skip it
	
	if ($exists) { # if it exists we also want to remove the old line
		if ($sline[0] -ne $Name) {
			$newContent += $line + "`r`n" # add other stuff, skip line with old host
		}
	} else {
		$newContent += $line + "`r`n"
	}
}

if (-not $added) { $newContent += $Name + '     IN      ' + $Type + '       ' + $IP.toString() + "`r`n" }

# $newContent | Write-Host
# https://stackoverflow.com/questions/5596982/using-powershell-to-write-a-file-in-utf-8-without-the-bom
 $newContent | Out-File $fwddb -Encoding ASCII # This writes the file in UTF8-BOM
# [System.IO.File]::WriteAllLines($fwddb, $newContent)

# we just added our forward dns info, now reverse dns

$revdb = $DRIVE_LTR + ':\' + $DNS_REVDB
$dbcontent = Get-Content -Path $revdb
$start = $false
$newContent = '' # I want to organize the entries by increasing ip number
# so Im doing going to insert it rather than append it
$added = $false

foreach ($line in $dbcontent) {
	$sline = @('') # array of strings
	
	if ($start -and ($line -ne '')) { # skip parsing blank lines
		$linends = $line -replace '\s+', ' ' # we want to delete duplicate spaces
		$sline = $linends.split() # Split by space
		
		$lastByteExisting = [int]($sline[0]) # Get ipadress from line
		# split it by period to get the last octet/byte then convert it to a int
		
		if ($lastByteExisting -gt $lastByteNew) { #insert new record
			$newContent += [string]($IP.getAddressBytes()[3]) + '     IN      PTR        ' + ($Name + '.' + $DOMAIN_SUFFIX + '.') + "`r`n"
			$start = $false
			$sline[0] = '' # this is so the if statement later doesn't break
			# this variable wont be updated anymore, so we need this so it doesnt skip
			# the rest of the entries
			$added = $true
		}
	}
	
	if ($line -eq $splitStr) { $start = $true } # if its pre-text just skip it
	
	if ($exists) { # if it exists we also want to remove the old line
		if ($sline[0] -ne $Name) {
			$newContent += $line + "`r`n" # add other stuff, skip line with old host
		}
	} else {
		$newContent += $line + "`r`n"
	}
}

if (-not $added) { $newContent += [string]($IP.getAddressBytes()[3]) + '     IN      PTR        ' + ($Name + '.' + $DOMAIN_SUFFIX + '.') + "`r`n" }

$newContent | Out-File $revdb -Encoding ASCII
# [System.IO.File]::WriteAllLines($revdb, $newContent);

Invoke-Command -ComputerName $($DNS_SERVER + '.' + $DOMAIN_SUFFIX) -Command { Restart-Service -Name 'ISC BIND' } -Credential $credential