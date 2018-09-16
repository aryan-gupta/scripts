
function Add-RegistryEntry {
	[CmdletBinding()] 
	Param (
		[Parameter (Mandatory = $true, Position = 1)] [String] $Path,
		[Parameter (Mandatory = $true, Position = 2)] [String] $Name,
		[Parameter (Mandatory = $true, Position = 3)] [String] $Type,
		[Parameter (Mandatory = $true, Position = 4)] [String] $Value
	)
	
	# this will catch any values that are not registry key types
	# http://www.latkin.org/blog/2012/07/08/using-enums-in-powershell/
	# https://docs.microsoft.com/en-us/powershell/scripting/getting-started/cookbooks/working-with-registry-entries?view=powershell-6
	# $dummy = [Microsoft.Win32.RegistryValueKind] $Type
	
	# '-Force' will create all parent keys for us
	New-Item -Path $Path -Force | Out-Null
	New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
}


function ConvertFrom-RegFile {
	[CmdletBinding()] 
	Param (
		[Parameter (Mandatory = $true, Position = 1)] [String] $Path
	)
	
	$content = Get-Content -Path $Path
	
	$foundPath = $false
	$extendLine = $false
	foreach ($line in $content) {
		# Skip all comment lines
		if ($line.startsWith(';;')) {
			continue
		}
		
		# Skip all empty lines
		if ($line.replace(' ', '').replace('`t', '').replace('`n', '').length -eq 0) {
			continue
		}
		
		# We found a path, parse line as a key/value pair
		if ($foundPath) {
			# check for next path
			if ($line.startsWith('[')) {
				$foundPath = $false
			} else {
				# if we are extending the line, just add the line with the escape char
				#    It will be removed later
				# else parse the line as a key/value pair
				if ($extendLine) {
					$value += $line
				} else {
					# split by '=', left will be the key name right will be the value
					# if the value isnt a string then it will be in the format type:value
					$split = $line.split('=')
					$name = $split[0].replace('"','')
					
					# if our value isnt a string then split it by ':' to get 
					# the type and value
					if ($split[1].contains(':')) {
						$split = $split[1].split(':')
						$type = $split[0]
						$value = $split[1]
					} else {
						$type = 'String'
						$value = $split[1].replace('"', '')
					}
				}
				
				# if line has a newline escape char then set extendLine and remove it from
				#    the value
				# else create the key
				if ($line.endsWith('\')) {
					$extendLine = $true
					$value = $value.substring(0, $value.length - 1)
				} else {
					$extendLine = $false
					
					Write-Host $path
					Write-Host $name
					Write-Host $type
					Write-Host $value
				}
			}
		}
		
		# if ($line.startsWith('Windows Registry Editor Version 5.00')) {
			# continue
		# }
		
		# Found a path to a registry entry, set path and start parsing next lines
		# as key/value
		if ($line.startsWith('[')) {
			$path = $line.replace('[', '').replace(']', '')
			$foundPath = $true;
		}
	}
}