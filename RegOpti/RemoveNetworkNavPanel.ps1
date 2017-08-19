# Remove Network from Navigation Panel
# Take Ownership of the Registry key - https://www.youtube.com/watch?v=M1l5ifYKefg

$regPath = "HKCR:\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder"
$name = "Attributes"
$type = DWORD
$val = 2962489444