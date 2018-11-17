
$home = $ENV:Home
$newHome = 'Z:\Users\Nayra'
$directories = @(
	'3D Objects'
	'Contacts'
	'Desktop'
	'Documents'
	'Downloads'
	'Favorites'
	'Links'
	'Music'
	'OneDrive'
	'Pictures'
	'Projects'
	'Saved Games'
	'Searches'
	'Videos'
)

foreach ($dir in $directories) {
	New-Item -Type Junction -Path ($home + $dir) -Value ($newHome + $dir)
}