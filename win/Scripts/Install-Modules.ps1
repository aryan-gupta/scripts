Param(
	[Parameter(Position=0)] [String] $Module,
	[Switch] $All
)

# Get PSModulePath variable, split it by ;, Find the one that is in the User profile, Then select the first on (in the array)
$ModulePath = (($env:PSModulePath).split(';') -like "$env:USERPROFILE\*")[0]

# If there are no parameters then default all to be true
if ($Module -eq "") {
	$All = $true
}


if ($All -eq $true) {
	Copy-Item .\Modules\* $ModulePath -Recurse
}