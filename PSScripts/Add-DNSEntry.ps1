
$Name = 'test'
$IP = '192.186.0.7'
$Type = 'A'
$Force = $true

$DNS_SERVER = 'electron'
$DNS_ROOT   = 'Root'
$DNS_DIR    = 'Program Files\ISC BIND 9\etc\master\db'

$PS_DATA_DIR = "$ENV:Home\Documents\PSData"
$DRIVE_LTR = 'T'

$DNS_DB = 'db.gempi.re.test'
$DNS_REVDB = 'db.0.168.192.in-addr.arpa'

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
# the script starts parsing. If 

$fwddb = $DRIVE_LTR + ':\' + $DNS_DB
$start = $false # this bool variable states when we should start parsing the file
# the file starts of with TTL and Serial data that we want to skip
$exists = $false
$lastByteNew = [int]($IP.split('.')[3])
$dbcontent = Get-Content -Path $fwddb

# Prechecks
# checks that the new hostname doesnt already exists
# and checks if the new IP adress wont conflict with another entry
foreach ($line in $dbcontent) {	
	if ($start) { # we have started to parse the actual records
		$line = $line -replace '\s+', ' ' # we want to delete duplicate spaces
		$sline = $line.split() # Split by space
		
		$lastByteExisting = [int](($sline[3]).split('.')[3]) # Get ipadress from line
		# split it by period to get the last octet/byte then convert it to a int
		
		if ($lastByteExisting -eq $lastByteNew) { # Found same ip record
			if ($sline[0] -ne $Name) {
				# If the new IP address will conflict with another record then we want to output
				# an error
				Write-Error "IP Conflict found. Host $sline[0] will have same IP as new record"
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

foreach ($line in $dbcontent) {
	$sline = @('') # array of strings
	
	if ($start) {
		$linends = $line -replace '\s+', ' ' # we want to delete duplicate spaces
		$sline = $linends.split() # Split by space
		
		$lastByteExisting = [int](($sline[3]).split('.')[3]) # Get ipadress from line
		# split it by period to get the last octet/byte then convert it to a int
		
		if ($lastByteExisting -gt $lastByteNew) { #insert new record
			$newContent += $Name + '     IN      ' + $Type + '       ' + $IP + "`n"
			$start = $false
			$sline[0] = '' # this is so the if statement later doesn't break
			# this variable wont be updated anymore, so we need this so it doesnt skip
			# the rest of the entries
		}
	}
	
	if ($line -eq $splitStr) { $start = $true } # if its pre-text just skip it
	
	if ($exists) { # if it exists we also want to remove the old line
		if ($sline[0] -ne $Name) {
			$newContent += $line + "`n" # add other stuff, skip line with old host
		}
	} else {
		$newContent += $line + "`n"
	}
}

# add doesn't exist case
$newContent | Out-File $fwddb