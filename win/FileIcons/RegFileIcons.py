

regfile = open('RegFileIcon_py.reg', 'w')

vlc      = r'@="\"C:\\Program Files (Portable)\\VLC\\vlc.exe\" \"%1\" %*"';
_7zip    = r'@="\"C:\\Program Files (Portable)\\7-Zip\\7zFM.exe\" \"%1\" %*"';
xnview   = r'@="\"C:\\Program Files (Portable)\\XnView\\xnview.exe\" \"%1\" %*"';
foxit    = r'@="\"C:\\Program Files (Portable)\\Foxit Reader\\FoxitReader.exe\" \"%1\" %*"';
chrome   = r'@="\"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\" \"%1\" %*"';
notepadpp= r'@="\"C:\\Program Files (Portable)\\Notepad++\\notepad++.exe\" \"%1\" %*"';


extData = [

	["7z"    ,"7-Zip Compressed File"              ,_7zip]    ,
	["avi"   ,"Audio Video Interleave File"        ,vlc]      ,
	["bak"   ,"Backup File"                        ,notepadpp],
	["bin"   ,"Generic Binary File"                ,notepadpp],
	["bmp"   ,"Bitmap Image File"                  ,xnview]   ,
	["class" ,"Java Class File"                    ,notepadpp],
	["css"   ,"Cascading Style Sheet File"         ,notepadpp],
	["dat"   ,"Data File"                          ,notepadpp],
	["flac"  ,"Free Lossless Audio Codec File"     ,vlc]      ,
	["flv"   ,"Animate Video File"                 ,vlc]      ,
	["gif"   ,"Graphical Interchange Format File"  ,xnview]   ,
	["gz"    ,"GNU Zipped Archive File"            ,_7zip]    ,
	["h"     ,"C/C++ Header File"                  ,notepadpp],
	["inf"   ,"Setup Information File"             ,notepadpp],
	["ini"   ,"Windows Initialization File"        ,notepadpp],
	["java"  ,"Java Source Code File"              ,notepadpp],
	["jpg"   ,"JPEG Image File"                    ,xnview]   ,
	["js"    ,"JavaScript Source File"             ,notepadpp],
	["mkv"   ,"Matroska Video File"                ,vlc]      ,
	["mov"   ,"Apple QuickTime Movie File"         ,vlc]      ,
	["mp3"   ,"MP3 Audio File"                     ,vlc]      ,
	["mp4"   ,"MPEG-4 Video File"                  ,vlc]      ,
	["mpeg"  ,"MPEG Movie File"                    ,vlc]      ,
	["o"     ,"Compiled Object File"               ,notepadpp],
	["php"   ,"PHP Source Code File"               ,notepadpp],
	["png"   ,"Portable Network Graphic Image File",xnview]   ,
	["py"    ,"Python Script File"                 ,notepadpp],
	["rar"   ,"WinRAR Compressed Archive File"     ,_7zip]    ,
	["rc"    ,"Resource Script File"               ,notepadpp],
	["swf"   ,"Shockwave Flash Movie File"         ,vlc]      ,
	["tar.gz","Compressed Tarball File"            ,_7zip]    ,
	["tmp"   ,"Temporary File"                     ,notepadpp],
	["txt"   ,"Plain Text File"                    ,notepadpp],
	["wav"   ,"WAVE Audio File"                    ,vlc]      ,
	["xml"   ,"XML File"                           ,notepadpp],
	["zip"   ,"Zipped File"                        ,_7zip]    ,
	
]

P_extData = [
	["html", "Hypertext Markup Language File", chrome],
	["pdf",  "Portable Document Format File",  foxit]
]

regfile.write("Windows Registry Editor Version 5.00" + "\n\n")

for data in extData: # Delete the file types
	regfile.write(	
		"; ====================================== DELETE " + data[0] + " =========================================" + "\n" +
		"[-HKEY_LOCAL_MACHINE\\Software\\Classes\\." + data[0] + "]" + "\n" +
		"[-HKEY_CURRENT_USER\\Software\\Classes\\." + data[0] + "]" + "\n" +
		"[-HKEY_CURRENT_USER\\Software\\Classes\\." + data[0] + "]" + "\n" +
		"[-HKEY_LOCAL_MACHINE\\Software\\Classes\\" + data[0] + "_FILE]" + "\n" +
		"[-HKEY_CURRENT_USER\\Software\\Classes\\" + data[0] + "_FILE]" + "\n" +
		"[-HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\." + data[0] + "]" + "\n" +
		"; =================================================================================================" + "\n\n"
	)

for data in P_extData: # Delete the protected file types
	regfile.write(
		"; ====================================== DELETE " + data[0] + " =========================================" + "\n" +
		"[-HKEY_LOCAL_MACHINE\\Software\\Classes\\Applications\\" + data[0] + "_FILE.bat]" + "\n" +
		"[-HKEY_CURRENT_USER\\Software\\Classes\\Applications\\" + data[0] + "_FILE.bat]" + "\n" +
		"[-HKEY_LOCAL_MACHINE\\Software\\Classes\\." + data[0] + "]" + "\n" +
		"[-HKEY_CURRENT_USER\\Software\\Classes\\." + data[0] + "]" + "\n" +
		"; =================================================================================================" + "\n\n"
	)
	
regfile.write( # Delete the unknown file type
	"; ====================================== DELETE " + "file" + " =========================================" + "\n" +
	"[-HKEY_LOCAL_MACHINE\\Software\\Classes\\Applications\\file_FILE]" + "\n" +
	"[-HKEY_CURRENT_USER\\Software\\Classes\\Applications\\file_FILE]" + "\n" +
	"[-HKEY_LOCAL_MACHINE\\Software\\Classes\\.]" + "\n" +
	"[-HKEY_CURRENT_USER\\Software\\Classes\\.]" + "\n" +
	"[-HKEY_LOCAL_MACHINE\\Software\\Classes\\file_FILE]" + "\n" +
	"[-HKEY_CURRENT_USER\\Software\\Classes\\file_FILE]" + "\n" +
	"[-HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\.]" + "\n" +
	"; =================================================================================================" + "\n\n"	
)

for data in extData:  # Created the associations for each extension
	regfile.write(
		"; ========================================= " + data[0] + " ============================================" + "\n" +
		"[HKEY_CURRENT_USER\\Software\\Classes\\" + data[0] + "_FILE]" + "\n" +
		"@=\"" + data[1] + "\"" + "\n" +
		"\"FriendlyTypeName\"=\"" + data[1] + "\"" + "\n" +
		"[HKEY_CLASSES_ROOT\\" + data[0] + "_FILE\\DefaultIcon]" + "\n" +
		"@=\"C:\\\\Windows\\\\personal\\\\ico\\\\" + data[0] + ".ico,0\"" + "\n" +
		"[HKEY_CLASSES_ROOT\\" + data[0] + "_FILE\\shell\\open\\command]" + "\n" +
		data[2] + "\n" +
		"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\." + data[0] + "\\OpenWithProgids]" + "\n" +
		"\"" + data[0] + "_FILE\"=hex(0):" + "\n" +
		"; =================================================================================================" + "\n\n"
	)
	
regfile.write( # Associate unknown files
	"; ============================================ file ===============================================" + "\n" +
	"[HKEY_CURRENT_USER\\Software\\Classes\\file_FILE]" + "\n" +
	"@=\"Unknown File\"" + "\n" +
	"\"FriendlyTypeName\"=\"Unknown File\"" + "\n" +
	"[HKEY_CLASSES_ROOT\\file_FILE\\DefaultIcon]" + "\n" +
	"@=\"C:\\\\Windows\\\\personal\\\\ico\\\\file.ico,0\"" + "\n" +
	"[HKEY_CLASSES_ROOT\\file_FILE\\shell\\open\\command]" + "\n" +
	notepadpp + "\n" +
	"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\.\\OpenWithProgids]" + "\n" +
	"\"file_FILE\"=hex(0):" + "\n" +
	"; =================================================================================================" + "\n\n"
)

for data in P_extData: # Associate protected exts
	regfile.write(
		"; ========================================= " + data[0] + " ============================================" + "\n" +
		"[HKEY_CURRENT_USER\\Software\\Classes\\Applications\\" + data[0] + "_FILE.bat]" + "\n" +
		"@=\"" + data[1] + "\"" + "\n" +
		"\"FriendlyTypeName\"=\"" + data[1] + "\"" + "\n" +
		"[HKEY_CLASSES_ROOT\\Applications\\" + data[0] + "_FILE.bat\\DefaultIcon]" + "\n" +
		"@=\"C:\\\\Windows\\\\personal\\\\ico\\\\" + data[0] + ".ico,0\"" + "\n" +
		"[HKEY_CLASSES_ROOT\\Applications\\" + data[0] + "_FILE.bat\\shell\\open\\command]" + "\n" +
		data[2] + "\n" +
		"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\." + data[0] + "\\OpenWithProgids]" + "\n" +
		"\"Applications\\\\" + data[0] + "_FILE.bat\"=hex(0):" + "\n" +
		"; =================================================================================================" + "\n\n"
	)
	
regfile.write( # ETC
	"; ========================================= " + "ADD CPP TO NEW MENU" + " ============================================" + "\n" +
	"[HKEY_LOCAL_MACHINE\\Software\\Classes\\.cpp]" + "\n" +
	"@=\"cpp_FILE\"" + "\n" +
	"[HKEY_LOCAL_MACHINE\\Software\\Classes\\.cpp\\ShellNew]" + "\n" +
	"\"NullFile\"=\"\"" + "\n" +
	"\"FileName\"=\"C:\\\\Windows\\\\personal\\\\Templates\\\\template.cpp\"" + "\n" +
	"[HKEY_LOCAL_MACHINE\\Software\\Classes\\cpp_FILE]" + "\n" +
	"@=\"C/C++ Code File\"" + "\n" +
	"; ========================================= " + "ADD H TO NEW MENU" + " ============================================" + "\n" +
	"[HKEY_LOCAL_MACHINE\\Software\\Classes\\.h]" + "\n" +
	"@=\"h_FILE\"" + "\n" +
	"[HKEY_LOCAL_MACHINE\\Software\\Classes\\.h\\ShellNew]" + "\n" +
	"\"NullFile\"=\"\"" + "\n" +
	"\"FileName\"=\"C:\\\\Windows\\\\personal\\\\Templates\\\\template.h\"" + "\n" +
	"[HKEY_LOCAL_MACHINE\\Software\\Classes\\h_FILE]" + "\n" +
	"@=\"C/C++ Header File\"" + "\n" +
	"; ========================================= " + "ADD EMPTY FILE TO NEW MENU" + " ============================================" + "\n" +
	"[HKEY_LOCAL_MACHINE\\Software\\Classes\\.]" + "\n" +
	"@=\"file_FILE\"" + "\n" +
	"[HKEY_LOCAL_MACHINE\\Software\\Classes\\.\\ShellNew]" + "\n" +
	"\"NullFile\"=\"\"" + "\n" +
	"[HKEY_LOCAL_MACHINE\\Software\\Classes\\file_FILE]" + "\n" +
	"@=\"Empty File\"" + "\n\n"
)