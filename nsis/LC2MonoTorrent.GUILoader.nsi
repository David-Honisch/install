!ifdef HAVE_UPX
!packhdr tmp.dat "upx\upx -9 tmp.dat"
!endif

!ifdef NOCOMPRESS
SetCompress off
!endif
;--------------------------------
; General Attributes

Name "LC2MonoTorrentGUI Loader"
OutFile "LC2MonoTorrent.GUI.Loader.exe"
;SilentInstall silent
RequestExecutionLevel user
Icon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"

BrandingText "(c) by http://www.letztechance.org"
;--------------------------------
;Interface Settings

  !include "MUI2.nsh"
  ;!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install-colorful.ico"
  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_LANGUAGE "English"

;SetFont 14

;--------------------------------
;Installer Sections

Section "Dummy Section" SecDummy

    SetDetailsView hide

; two files download, popup mode
    ;inetc::get /caption "2003-2004 reports" /popup "" "http://letztechance.webuda.com/upload/dl.php?id=109" "$EXEDIR\LC2TwainGui.exe" "http://ineum.narod.ru/spr_2004.htm" "$EXEDIR\spr4.htm" /end
	inetc::get /caption "LC2MonoTorrent.GUI.exe" /popup "" "http://letztechance.webuda.com/upload/dl.php?id=117" "$EXEDIR\LC2TwainGui.exe" /end
    Pop $0 # return value = exit code, "OK" means OK
	
	inetc::get /caption "MonoTorrent.dll" /popup "" "http://letztechance.webuda.com/upload/dl.php?id=118" "$EXEDIR\LC2TwainGui.exe" /end
    Pop $0 # return value = exit code, "OK" means OK

; single file, NSISdl-style embedded progress bar with specific cancel button text
    ;inetc::get /caption "2005 report" /canceltext "interrupt!" "http://ineum.narod.ru/spr_2005.htm" "$EXEDIR\spr5.htm" /end
    ;Pop $1 # return value = exit code, "OK" means OK

; banner with 2 text lines and disabled Cancel button
    ;inetc::get /caption "2006 report" /banner "Banner mode with /nocancel option setten$\nSecond Line" /nocancel "http://ineum.narod.ru/spr_2006.htm"  "$EXEDIR\spr6.htm" /end
    ;Pop $2 # return value = exit code, "OK" means OK

    ;MessageBox MB_OK "Download Status: $0, $1, $2"
	;MessageBox MB_OK "Download Status: $0"
SectionEnd

;--------------------------------
Section "Programm und Hilfe ausführen..." TESTIDX

  SectionIn 1 2 3
  
  SearchPath $1 $EXEDIR\LC2TwainGui.exe

;  MessageBox MB_OK "notepad.exe=$1"
  ;ExecShell "open" '"$INSTDIR\html\index.html"'
  ;ExecShell "open" '"$EXEDIR\LC2TwainGui.exe"'
  ;ExecWait '"$1"'
  ;Sleep 500
  ;BringToFront
  ;ExecCmd::exec /NOUNLOAD /ASYNC /TIMEOUT=2000 \
  ;  '"$EXEDIR\LC2TwainGui.exe" >ExecCmd.log' "test_login$\r$\ntest_pwd$\r$\n"
  ;Pop $0 # thread handle for wait
  # you can add some installation code here to execute while application is running.
  ;ExecCmd::wait $0
  ;Pop $0 # return value
  ;MessageBox MB_OK "Exit code $0"
  ;ExecCmd::exec /TIMEOUT=20000000 '"$EXEDIR\LC2TwainGui.exe"' "test_login$\r$\ntest_pwd$\r$\n"
  ;ExecCmd::wait /TIMEOUT=20000000 '"$EXEDIR\LC2TwainGui.exe"' "test_login$\r$\ntest_pwd$\r$\n"
  ExecCmd::exec '"$EXEDIR\LC2TwainGui.exe"' "test_login$\r$\ntest_pwd$\r$\n"
  Pop $0 ; return value - process exit code or error or STILL_ACTIVE (0x103).
  ;MessageBox MB_OK "Exit code $0"
  ;Call Uninstaller
SectionEnd

Section "Daten löschen..." TESTIDX2
  Call Uninstaller
SectionEnd
;Uninstaller

;UninstallText "Uninstall LCLauncher ?"
;UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\nsis1-uninstall.ico"
;UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"

;Section "Uninstall"



;Installer Functions

Function .onInit

; plug-in auto-recognizes 'no parent dlg' in onInit and works accordingly
;    inetc::head /RESUME "Network error. Retry?" "http://ineum.narod.ru/spr_2003.htm" "$EXEDIR\spr3.txt"
;    Pop $4

FunctionEnd

Function Uninstaller
  ;SectionIn 1 2 3
  ;DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LCLauncher"
  ;DeleteRegKey HKLM "SOFTWARE\WWW.LETZTECHANCE.ORG\LCLauncher"

;  Delete "$SMPROGRAMS\WWW.LETZTECHANCE.ORG\LCLauncher\reg\*.*"
;  RMDir "$SMPROGRAMS\reg"
  Delete "$EXEDIR\LC2TwainGui.exe"
  

  ;IfFileExists "$INSTDIR" 0 NoErrorMsg
  ;  MessageBox MB_OK "Note: $INSTDIR could not be removed!" IDOK 0 ; skipped if file doesn't exist
  ;NoErrorMsg:

FunctionEnd