mkdir "%UserProfile%\Desktop\.{ED7BA470-8E54-465E-825C-99712043E01C}"

.\Tools\SetACL.exe -on "HKEY_CLASSES_ROOT\CLSID\{ED7BA470-8E54-465E-825C-99712043E01C}" -ot reg -actn setowner -ownr "n:Administrators"
.\Tools\SetACL.exe -on "HKEY_CLASSES_ROOT\CLSID\{ED7BA470-8E54-465E-825C-99712043E01C}" -ot reg -actn ace -ace "n:Administrators;p:full"
regedit.exe /s RemoveGodModeExtension.reg

