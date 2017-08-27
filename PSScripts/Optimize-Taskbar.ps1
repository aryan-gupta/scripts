
$shell = New-Object -ComObject Shell.Application
$folder = $shell.Namespace('C:\Program Files\Notepad++')
$item = $folder.ParseName('notepad++.exe')
$verb = $Item.Verbs() | ? {$_.Name -eq 'Pin to Tas&kbar'}
$verb.DoIt()