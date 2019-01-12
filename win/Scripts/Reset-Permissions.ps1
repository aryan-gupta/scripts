$root = 'Z:\'

$Rule =  New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "Full", "ContainerInherit,ObjectInherit", "none", "Allow")

Set-Location $root

foreach ($Folder in (Get-ChildItem -recurse)) {
	Write-Host $Folder.FullName
	
	$ACL = Get-Acl $Folder.FullName
	$ACL.access | %{ $ACL.RemoveAccessRule($_) }  | Out-Null # Remove all permissions

	$ACL.AddAccessRule($Rule)

	Set-Acl -Path $Folder -AclObject $Acl
}