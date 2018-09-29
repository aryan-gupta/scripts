
#include <iostream>
#include <string>

using std::cout;
using std::endl;

int main() {
//PROGRAMS:

	std::string vlc			= R"(@="\"C:\\Program Files (Portable)\\VLC\\vlc.exe\" \"%1\" %*")";
	std::string _7zip		= R"(@="\"C:\\Program Files (Portable)\\7-Zip\\7zFM.exe\" \"%1\" %*")";
	std::string xnview		= R"(@="\"C:\\Program Files (Portable)\\XnView\\xnview.exe\" \"%1\" %*")";
	std::string foxit		= R"(@="\"C:\\Program Files (Portable)\\Foxit Reader\\FoxitReader.exe\" \"%1\" %*")";
	std::string chrome		= R"(@="\"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\" \"%1\" %*")";
	std::string notepadpp	= R"(@="\"C:\\Program Files (Portable)\\Notepad++\\notepad++.exe\" \"%1\" %*")";

	std::string fileExt[] = {
// =================================================================		NOTEPAD++		=================================================================
 "bak", 	"Backup File",								notepadpp,
 "bin", 	"Generic Binary File",						notepadpp,
 "class", 	"Java Class File",							notepadpp,
 "cpp", 	"C++ Source Code File",						notepadpp,
 "css", 	"Cascading Style Sheet File",				notepadpp,
 "dat", 	"Data File",								notepadpp,
// "file", 	"Unknown File",								notepadpp,
 "h", 		"C/C++ Header File",						notepadpp,
 "inf", 	"Setup Information File",					notepadpp,
 "ini", 	"Windows Initialization File",				notepadpp,
 "java", 	"Java Source Code File",					notepadpp,
 "js", 		"JavaScript Source File",					notepadpp,
 "o", 		"Compiled Object File",						notepadpp,
 "php", 	"PHP Source Code File",						notepadpp,
 "py", 		"Python Script File",						notepadpp,
 "tmp", 	"Temporary File",							notepadpp,
 "txt", 	"Plain Text File",							notepadpp,
 "rc", 		"Resource Script File",						notepadpp,
 "xml", 	"XML File",									notepadpp,
 
// =================================================================		  VLC	  		=================================================================
 "mkv", 	"Matroska Video File",						vlc,
 "mov", 	"Apple QuickTime Movie File",				vlc,
 "mp3", 	"MP3 Audio File",							vlc,
 "mp4", 	"MPEG-4 Video File",						vlc,
 "mpeg", 	"MPEG Movie File",							vlc,
 "flac", 	"Free Lossless Audio Codec File",			vlc,
 "flv", 	"Animate Video File",						vlc,
 "avi", 	"Audio Video Interleave File",				vlc,
 "swf", 	"Shockwave Flash Movie File",				vlc,
 "wav", 	"WAVE Audio File",							vlc,

// =================================================================		   7-ZIP		=================================================================
 "rar", 	"WinRAR Compressed Archive File",			_7zip,
 "7z", 		"7-Zip Compressed File",					_7zip,
 "tar.gz", 	"Compressed Tarball File",					_7zip,
 "gz", 		"GNU Zipped Archive File",					_7zip,
 "zip", 	"Zipped File",								_7zip,

// =================================================================		   XnView		=================================================================
 "bmp", 	"Bitmap Image File",						xnview,
 "png", 	"Portable Network Graphic Image File",		xnview,
 "jpg", 	"JPEG Image File",							xnview,
 "gif", 	"Graphical Interchange Format File",		xnview,
 
 "\0"};
 
 	std::string protectedFileExt[] = {
// =================================================================		   Chrome		=================================================================
 "html",	"Hypertext Markup Language File",			chrome,

// =================================================================		   FoxIt		=================================================================
 "pdf", 	"Portable Document Format File",			foxit,
  
 "\0"};

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//std::string fileExt[] = {"7z"};
	cout << "Windows Registry Editor Version 5.00" << endl << endl;
	
	//* DELETE =========================================================================================================================
	//		   =========================================================================================================================
	for(int i = 0; fileExt[i] != "\0"; i = i + 3) {
		cout << "; ====================================== DELETE " << fileExt[i] << " =========================================" << endl;
		//cout << "[-HKEY_LOCAL_MACHINE\\Software\\Classes\\Applications\\" << fileExt[i] << "_FILE]" << endl;
		//cout << "[-HKEY_CURRENT_USER\\Software\\Classes\\Applications\\" << fileExt[i] << "_FILE]" << endl;
		cout << "[-HKEY_LOCAL_MACHINE\\Software\\Classes\\." << fileExt[i] << "]" << endl;
		cout << "[-HKEY_CURRENT_USER\\Software\\Classes\\." << fileExt[i] << "]" << endl;
		cout << "[-HKEY_LOCAL_MACHINE\\Software\\Classes\\" << fileExt[i] << "_FILE]" << endl;
		cout << "[-HKEY_CURRENT_USER\\Software\\Classes\\" << fileExt[i] << "_FILE]" << endl;
		cout << "[-HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\." << fileExt[i] << "]" << endl;
		cout << "; =================================================================================================" << endl;
		cout << endl;
	}
	
	//* DELETE PROTECTED =========================================================================================================================
	//		   =========================================================================================================================
	for(int i = 0; protectedFileExt[i] != "\0"; i = i + 3) {
		cout << "; ====================================== DELETE " << protectedFileExt[i] << " =========================================" << endl;
		cout << "[-HKEY_LOCAL_MACHINE\\Software\\Classes\\Applications\\" << protectedFileExt[i] << "_FILE.bat]" << endl;
		cout << "[-HKEY_CURRENT_USER\\Software\\Classes\\Applications\\" << protectedFileExt[i] << "_FILE.bat]" << endl;
		cout << "[-HKEY_LOCAL_MACHINE\\Software\\Classes\\." << protectedFileExt[i] << "]" << endl;
		cout << "[-HKEY_CURRENT_USER\\Software\\Classes\\." << protectedFileExt[i] << "]" << endl;
		//cout << "[-HKEY_LOCAL_MACHINE\\Software\\Classes\\" << protectedFileExt[i] << "_FILE.bat]" << endl;
		//cout << "[-HKEY_CURRENT_USER\\Software\\Classes\\" << protectedFileExt[i] << "_FILE.bat]" << endl;
		//cout << "[-HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\." << protectedFileExt[i] << "]" << endl;
		cout << "; =================================================================================================" << endl;
		cout << endl;
	}
	//*/ DELETE UNKNOWN FILE ===========================================================================================================
	//		               ===========================================================================================================
		cout << "; ====================================== DELETE " << "file" << " =========================================" << endl;
		cout << "[-HKEY_LOCAL_MACHINE\\Software\\Classes\\Applications\\file_FILE]" << endl;
		cout << "[-HKEY_CURRENT_USER\\Software\\Classes\\Applications\\file_FILE]" << endl;
		cout << "[-HKEY_LOCAL_MACHINE\\Software\\Classes\\.]" << endl;
		cout << "[-HKEY_CURRENT_USER\\Software\\Classes\\.]" << endl;
		cout << "[-HKEY_LOCAL_MACHINE\\Software\\Classes\\file_FILE]" << endl;
		cout << "[-HKEY_CURRENT_USER\\Software\\Classes\\file_FILE]" << endl;
		cout << "[-HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\.]" << endl;
		cout << "; =================================================================================================" << endl;
		cout << endl;
		
	//* UNPROTECTED =========================================================================================================================
	//		        =========================================================================================================================
	for(int i = 0; fileExt[i] != "\0"; i = i + 3) {
		cout << "; ========================================= " << fileExt[i] << " ============================================" << endl;
		cout << endl;
		cout << "[HKEY_CURRENT_USER\\Software\\Classes\\" << fileExt[i] << "_FILE]" << endl;
		cout << "@=\"" << fileExt[i + 1] << "\"" << endl;
		cout << "\"FriendlyTypeName\"=\"" << fileExt[i + 1] << "\"" << endl;
		cout << "[HKEY_CLASSES_ROOT\\" << fileExt[i] << "_FILE\\DefaultIcon]" << endl;
		cout << "@=\"C:\\\\Windows\\\\personal\\\\ico\\\\" << fileExt[i] << ".ico,0\"" << endl;
		cout << "[HKEY_CLASSES_ROOT\\" << fileExt[i] << "_FILE\\shell\\open\\command]" << endl;
		cout << fileExt[i + 2] << endl; //"@=\"\\\"C:\\\\Program Files\\\\7-Zip\\\\7zFM.exe\\\" \\\"%1\\\"\"" << endl;
		cout << endl;
		cout << "[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\." << fileExt[i] << "\\OpenWithProgids]" << endl;
		cout << "\"" << fileExt[i] << "_FILE\"=hex(0):" << endl;
		// cout << "[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\." << fileExt[i] << "\\OpenWithList]" << endl;
		// cout << "\"a\"=\"" << fileExt[i] << "_FILE\"" << endl;
		// cout << "\"MRUList\"=\"a\"" << endl;
		cout << "; =================================================================================================" << endl;
		cout << endl;
		cout << endl;
		cout << endl;
	}
	//*/
	
	//* UNKNOWN FILE =========================================================================================================================
	//		         =========================================================================================================================
		cout << "; ============================================ file ===============================================" << endl;
		cout << endl;
		cout << "[HKEY_CURRENT_USER\\Software\\Classes\\file_FILE]" << endl;
		cout << "@=\"Unknown File\"" << endl;
		cout << "\"FriendlyTypeName\"=\"Unknown File\"" << endl;
		cout << "[HKEY_CLASSES_ROOT\\file_FILE\\DefaultIcon]" << endl;
		cout << "@=\"C:\\\\Windows\\\\personal\\\\ico\\\\file.ico,0\"" << endl;
		cout << "[HKEY_CLASSES_ROOT\\file_FILE\\shell\\open\\command]" << endl;
		cout << notepadpp << endl; //"@=\"\\\"C:\\\\Program Files\\\\7-Zip\\\\7zFM.exe\\\" \\\"%1\\\"\"" << endl;
		cout << endl;
		cout << "[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\.\\OpenWithProgids]" << endl;
		cout << "\"file_FILE\"=hex(0):" << endl;
		// cout << "[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\." << fileExt[i] << "\\OpenWithList]" << endl;
		// cout << "\"a\"=\"" << fileExt[i] << "_FILE\"" << endl;
		// cout << "\"MRUList\"=\"a\"" << endl;
		cout << "; =================================================================================================" << endl;
		cout << endl;
		cout << endl;
		cout << endl;
	//*/
	
	//* PROTECTED =========================================================================================================================
	//		      =========================================================================================================================
	for(int i = 0; protectedFileExt[i] != "\0"; i = i + 3) {
		cout << "; ========================================= " << protectedFileExt[i] << " ============================================" << endl;
		cout << endl;
		cout << "[HKEY_CURRENT_USER\\Software\\Classes\\Applications\\" << protectedFileExt[i] << "_FILE.bat]" << endl;
		cout << "@=\"" << protectedFileExt[i + 1] << "\"" << endl;
		cout << "\"FriendlyTypeName\"=\"" << protectedFileExt[i + 1] << "\"" << endl;
		cout << "[HKEY_CLASSES_ROOT\\Applications\\" << protectedFileExt[i] << "_FILE.bat\\DefaultIcon]" << endl;
		cout << "@=\"C:\\\\Windows\\\\personal\\\\ico\\\\" << protectedFileExt[i] << ".ico,0\"" << endl;
		cout << "[HKEY_CLASSES_ROOT\\Applications\\" << protectedFileExt[i] << "_FILE.bat\\shell\\open\\command]" << endl;
		cout << protectedFileExt[i + 2] << endl; //"@=\"\\\"C:\\\\Program Files\\\\7-Zip\\\\7zFM.exe\\\" \\\"%1\\\"\"" << endl;
		cout << endl;
		cout << "[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\." << protectedFileExt[i] << "\\OpenWithProgids]" << endl;
		cout << "\"Applications\\\\" << protectedFileExt[i] << "_FILE.bat\"=hex(0):" << endl;
		// cout << "[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\." << protectedFileExt[i] << "\\OpenWithList]" << endl;
		// cout << "\"a\"=\"" << protectedFileExt[i] << "_FILE\"" << endl;
		// cout << "\"MRUList\"=\"a\"" << endl;
		cout << "; =================================================================================================" << endl;
		cout << endl;
		cout << endl;
		cout << endl;
	}
	//*/
	
	
	
	//* OTHER STUFF =========================================================================================================================
	//		        =========================================================================================================================
	// Add New in Context Menu
		cout << "; ========================================= " << "ADD CPP TO NEW MENU" << " ============================================" << endl;
		cout << "[HKEY_LOCAL_MACHINE\\Software\\Classes\\.cpp]" << endl;
		cout << "@=\"cpp_FILE\"" << endl;
		cout << "[HKEY_LOCAL_MACHINE\\Software\\Classes\\.cpp\\ShellNew]" << endl;
		cout << "\"NullFile\"=\"\"" << endl;
		cout << "\"FileName\"=\"C:\\\\Windows\\\\personal\\\\Templates\\\\template.cpp\"" << endl;
		cout << "[HKEY_LOCAL_MACHINE\\Software\\Classes\\cpp_FILE]" << endl;
		cout << "@=\"C/C++ Code File\"" << endl;
		cout << endl;
		
		cout << "; ========================================= " << "ADD H TO NEW MENU" << " ============================================" << endl;
		cout << "[HKEY_LOCAL_MACHINE\\Software\\Classes\\.h]" << endl;
		cout << "@=\"h_FILE\"" << endl;
		cout << "[HKEY_LOCAL_MACHINE\\Software\\Classes\\.h\\ShellNew]" << endl;
		cout << "\"NullFile\"=\"\"" << endl;
		cout << "\"FileName\"=\"C:\\\\Windows\\\\personal\\\\Templates\\\\template.h\"" << endl;
		cout << "[HKEY_LOCAL_MACHINE\\Software\\Classes\\h_FILE]" << endl;
		cout << "@=\"C/C++ Header File\"" << endl;
		cout << endl;
		
		cout << "; ========================================= " << "ADD EMPTY FILE TO NEW MENU" << " ============================================" << endl;
		cout << "[HKEY_LOCAL_MACHINE\\Software\\Classes\\.]" << endl;
		cout << "@=\"file_FILE\"" << endl;
		cout << "[HKEY_LOCAL_MACHINE\\Software\\Classes\\.\\ShellNew]" << endl;
		cout << "\"NullFile\"=\"\"" << endl;
		cout << "[HKEY_LOCAL_MACHINE\\Software\\Classes\\file_FILE]" << endl;
		cout << "@=\"Empty File\"" << endl;
		cout << endl;
	
	//*/
	return 0;
}