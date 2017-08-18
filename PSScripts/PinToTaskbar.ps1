
$shell = New-Object -ComObject Shell.Application
$folder = $shell.Namespace('C:\Program Files\Notepad++')
$item = $folder.ParseName('notepad++.exe')
$verb = item.Verbs() | ? {$_.Name -like 'pin to ta&kbar'}
if($verb) {$verb.DoIt()}