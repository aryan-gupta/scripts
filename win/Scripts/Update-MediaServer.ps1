

$EX_EXT = @(
	'iso'
	'exe'
	'png'
	'jpg'
	'jpeg'
	'txt'
	'url'
)

$SIZE_FILTER = 50mb

$MOVIE_FOLDER = 'Z:\Users\Nayra\Downloads\Torrents\Finished'
$MEDIA_SVR_DIR = 'Z:\Users\Nayra\Downloads\Torrents\Server'

# Selects all files larger then 50mb (rules out all sample files and all extra data)
$files = Get-ChildItem -Path $MOVIE_FOLDER -Recurse -File | Where-Object { $_.Length -gt $SIZE_FILTER } 

$filesFilterd = @()

foreach ($file in $files) {
	$fileExt = $file.extension
	$add = $true
	foreach ($ext in $EX_EXT) {
		if ($fileExt -eq (".$ext")) {
			$add = $false
			break
		}
	}
	
	if ($add) { $filesFilterd += $file }
}

$filesFilterd | Select-Object -Property 'Name' | Write-Host

# ni -Type SymbolicLink -Target .\Jumanji.Welcome.to.the.Jungle.2017.1080p.WEB+DL.DD5.1.H264+FGT.mp4 -Name ..\Server\Jum2.mp4
# ni -Type HardLink -Target .\Jumanji.Welcome.to.the.Jungle.2017.1080p.WEB+DL.DD5.1.H264+FGT.mp4 -Name ..\Server\Jum.mp4
# $files | Move-Item -Destination $MEDIA_SVR_DIR