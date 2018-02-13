; lc2install.nsi
;
; This script attempts to test most of the functionality of the NSIS exehead.

;--------------------------------

!ifdef HAVE_UPX
!packhdr tmp.dat "upx\upx -9 tmp.dat"
!endif

!ifdef NOCOMPRESS
SetCompress off
!endif

;--------------------------------
;Multilanguage Support
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Dutch.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\French.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\German.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Korean.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Russian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Spanish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Swedish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\TradChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Slovak.nlf"
;--------------------------------
;--------------------------------
;Version Information

  VIProductVersion "1.2.3.4"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "LC2HibernateMappingGenerator"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "Your personal Client"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "letztechance.org"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "no trademark"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© letztechance.org"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "LC2HibernateMappingGenerator"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "1.2.3"

;--------------------------------


Name "LC2HibernateMappingGenerator"
Caption "LC2HibernateMappingGenerator Install (c)by http://www.letztechance.org"
Icon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"
OutFile "LC2HibernateMappingGeneratorinstall.exe"

SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal
BGGradient FFFFFF A66E3C 000000
InstallColors A66E3C FFFFFF
XPStyle on

InstallDir "$PROGRAMFILES\LETZTECHANCE.ORG\LC2HibernateMappingGenerator"
InstallDirRegKey HKLM "Software\LETZTECHANCE.ORG\LC2HibernateMappingGenerator" "LC2HibernateMappingGenerator"

CheckBitmap "${NSISDIR}\Contrib\Graphics\Checks\classic-cross.bmp"

;--------------------------------
;--------------------------------
;--------------------------------


LicenseText "HTTP://WWW.LETZTECHANCE.ORG"
LicenseData "readme.txt"

;--------------------------------
Page license
Page components
Page directory
Page instfiles

;--------------------------------

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------
;Function YESNO
;ClearErrors
;UserInfo::GetName
;IfErrors Win9x
;Pop $0
;UserInfo::GetAccountType
;Pop $1
;!if $1 != "Admin"
;MessageBox MB_YESNO "Startmenü Eintrag ohne Administrations Privilegien setzen ?" IDYES NoReadme
;      Exec notepad.exe ; view readme or whatever, if you want.
;	CreateShortCut "$SMPROGRAMS\$R0\All users LC2HibernateMappingGenerator.lnk" $INSTDIR\LC2HibernateMappingGenerator.exe
;Abort
;!else
;MessageBox MB_YESNO "Startmenü Eintrag mit Administrations Privilegien setzen ?" IDYES NoReadme
;      Exec notepad.exe ; view readme or whatever, if you want.
;	CreateShortCut "$SMPROGRAMS\$R0\All users LC2HibernateMappingGenerator.lnk" $INSTDIR\LC2HibernateMappingGenerator.exe
;!endif
;    NoReadme:
;
;FunctionEnd

Section
;Call YESNO
SectionEnd
;--------------------------------




!ifndef NOINSTTYPES ; only if not defined
  InstType "Die wichtigsten Komponenten"
  InstType "Komplett Installation"
  InstType "Empfohlene Installation"
  InstType "Basis Installation"
  ;InstType /NOCUSTOM
  ;InstType /COMPONENTSONLYONCUSTOM
!endif

AutoCloseWindow false
ShowInstDetails show

;--------------------------------

Section "" ; empty string makes it hidden, so would starting with -
;MessageBox MB_YESNO "Wollen Sie dieses Programm wirklich installieren ?" IDYES
  ; write reg info
  StrCpy $1 "POOOOOOOOOOOP"
  DetailPrint "I like to be able to see what is going on (debug) $1"
  WriteRegStr HKLM SOFTWARE\WWW.LETZTECHANCE.ORG\LC2HibernateMappingGenerator "Install_Dir" "$INSTDIR"

  ; write uninstall strings
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LC2HibernateMappingGenerator" "DisplayName" "LC2HibernateMappingGenerator (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LC2HibernateMappingGenerator" "UninstallString" '"$INSTDIR\LC2HibernateMappingGeneratoruninst.exe"'
;---Extrahiere Dateien --------------------->
  SetOutPath $INSTDIR
  ;File /a "exe\LC2HibernateMappingGenerator.exe"
  File /a "exe\*.*"
  ;File /a /r "exe\Presents\*.*"	
  File /a "letztechance.org.url"
  File /a "favicon.ico"
;---Extrahiere HTML --------------------->
  CreateDirectory "$INSTDIR\html" ; 2 recursively create a directory for fun.
  SetOutPath $INSTDIR\html
;  File /a "html\search2.html"
  File /a "html\index.html"
  SetOutPath $INSTDIR\html\css
  File /a "html\css\*.*"
  ;File /a "html\iframe.html"
  ;File /a "html\addnav.html"
  ;File /a "css\lc.css"
  ;File /a "css\dc.css"
  File /a "html\index.html"
;---Extrahiere HTML --------------------->
;  CreateDirectory "$INSTDIR\WebSearch" ; WebSearch
;  SetOutPath $INSTDIR\WebSearch
;  File /a "exe\WebSearch\*.*"

  ;CreateDirectory "$INSTDIR\reg" ; 2 recursively create a directory for fun.
  WriteUninstaller "LC2HibernateMappingGeneratoruninst.exe"
;---Extrahiere Bilder --------------------->
  CreateDirectory "$INSTDIR\images" ; 2 recursively create a directory for fun.
  SetOutPath $INSTDIR\images
  File /a "images\t.gif"
  File /a "images\bg.png"
  File /a "images\bg.jpg"
  File /a "images\help.jpg"
  File /a "images\start.jpg"
  File /a "images\title.jpg"
  File /a "images\update.jpg"
;---Extrahiere Bilder EOF--------------------->
  
  Nop ; for fun

SectionEnd

Section "LC2HibernateMappingGenerator"

SectionIn 1 2 3
;  Start: MessageBox MB_OK "Starte Installation"
;Start: MessageBox MB_YESNO "Wollen Sie dieses Programm wirklich installieren ?" IDYES Start

;MessageBox MB_YESNO "Wollen Sie dieses Programm wirklich installieren ?" IDYES

;  MessageBox MB_YESNO "Goto MyLabel" IDYES MyLabel

;  MessageBox MB_OK "Right before MyLabel:"

;  MyLabel: MessageBox MB_OK "MyLabel:"
  
;  MessageBox MB_OK "Right after MyLabel:"

;  MessageBox MB_YESNO "Goto Start:?" IDYES Start

SectionEnd

SectionGroup /e Applikatonen

Section "Registry/INI functions"

SectionIn 1 4 3

  WriteRegStr HKLM SOFTWARE\LETZTECHANCE.ORG\LC2HibernateMappingGenerator "StrTest_INSTDIR" "$INSTDIR"
  WriteRegDword HKLM SOFTWARE\LETZTECHANCE.ORG\LC2HibernateMappingGenerator "DwordTest_0xDEADBEEF" 0xdeadbeef
  WriteRegDword HKLM SOFTWARE\LETZTECHANCE.ORG\LC2HibernateMappingGenerator "DwordTest_123456" 123456
  WriteRegDword HKLM SOFTWARE\LETZTECHANCE.ORG\LC2HibernateMappingGenerator "DwordTest_0123" 0123
  WriteRegBin HKLM SOFTWARE\LETZTECHANCE.ORG\LC2HibernateMappingGenerator "BinTest_deadbeef01f00dbeef" "DEADBEEF01F00DBEEF"
;  StrCpy $8 "$SYSDIR\LC"
  WriteINIStr "$INSTDIR\lc.ini"  "LC2Applikationen" "Value1" $8
  WriteINIStr "$INSTDIR\lc.ini"  "server" "http://www.letztechance.org" $8
  WriteINIStr "$INSTDIR\lc.ini"  "LC2Ini" "Value1" $8
  WriteINIStr "$INSTDIR\lc.ini"  "LC2Ini" "Value2" $8
  WriteINIStr "$INSTDIR\lc.ini"  "LC2INI" "Value1" $8

  WriteINIStr "$INSTDIR\konfiguration.cfg"  "server" "name""http://www.letztechance.org"

  WriteINIStr "$INSTDIR\konfiguration.cfg"  "http" "download" "/modules/Forum/read.php?f=3&i=30&t=30"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "http" "forum" "/modules/Forum/"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "http" "suchen" "/?q=jssearch"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "http" "refresh" "30"

  WriteINIStr "$INSTDIR\konfiguration.cfg"  "groesse" "hoehe" "600"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "groesse" "breite" "800"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "update" "pfad" "/modules/Suchen/"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "update" "datei" "search2.html"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "suchen" "dir" "/?q=jssearch"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "suchen" "main" "search2.html"


  Call MyFunctionTest

  DeleteINIStr "$INSTDIR\lc.ini" "LC2INI" "Value1"
  DeleteINISec "$INSTDIR\lc.ini" "LC2INi"

  ReadINIStr $1 "$INSTDIR\lc.ini" "LC2INi" "Value1"
  StrCmp $1 "" INIDelSuccess
    MessageBox MB_OK "DeleteINISec failed"
  INIDelSuccess:

  ClearErrors
;  ReadRegStr $1 HKCR "software\microsoft" xyz_¢¢_does_not_exist
;  IfErrors 0 NoError
;    MessageBox MB_OK "could not read from HKCR\software\microsoft\xyz_¢¢_does_not_exist"
;    Goto ErrorYay
;  NoError:
;    MessageBox MB_OK "read '$1' from HKCR\software\microsoft\xyz_¢¢_does_not_exist"
;  ErrorYay:
  
SectionEnd

Section "CreateShortCuts"
 CreateDirectory $SMPROGRAMS\$R0
 CreateDirectory $SMPROGRAMS\$R0\LETZTECHANCE.ORG
 CreateDirectory $SMPROGRAMS\$R0\LETZTECHANCE.ORG\LC2HibernateMappingGenerator
 ;CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LC2HibernateMappingGenerator\Start LC2HibernateMappingGenerator.lnk" $INSTDIR\start.bat
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LC2HibernateMappingGenerator\LC2HibernateMappingGenerator.lnk" $INSTDIR\LC2HibernateMappingGenerator.exe
 ;CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LC2HibernateMappingGenerator\LC2HibernateMappingGenerator.exe" $INSTDIR\LC2HibernateMappingGenerator.exe
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LC2HibernateMappingGenerator\LC2HibernateMappingGeneratoruninst.lnk" $INSTDIR\LC2HibernateMappingGeneratoruninst.exe
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LC2HibernateMappingGenerator\Support.lnk" $INSTDIR\letztechance.org.url
  SectionIn 1 2 3

;  Call CSCTest

SectionEnd

Section "Programm und Hilfe ausführen..." TESTIDX

  SectionIn 1 2 3
  
  SearchPath $1 $INSTDIR\LC2HibernateMappingGenerator.exe

;  MessageBox MB_OK "notepad.exe=$1"
  ExecShell "open" '"$INSTDIR\html\index.html"'
  ExecWait '"$1"'
  Sleep 500
  BringToFront

SectionEnd


Function MyFunctionTest

  ReadINIStr $1 "$INSTDIR\test.ini" "LC" "Value1"
  StrCmp $1 $8 NoFailedMsg
    MessageBox MB_OK "WriteINIStr failed"
  
  NoFailedMsg:

FunctionEnd

Function .onSelChange

  SectionGetText ${TESTIDX} $0
  StrCmp $0 "" e
    SectionSetText ${TESTIDX} ""
  Goto e2
e:
  SectionSetText ${TESTIDX} "Sections"
e2:

FunctionEnd
SectionGroupEnd
;--------------------------------

;Uninstaller

UninstallText "Uninstall LC2HibernateMappingGenerator ?"
;UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\nsis1-uninstall.ico"
UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"

Section "Uninstall"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LC2HibernateMappingGenerator"
  DeleteRegKey HKLM "SOFTWARE\WWW.LETZTECHANCE.ORG\LC2HibernateMappingGenerator"

;  Delete "$SMPROGRAMS\WWW.LETZTECHANCE.ORG\LC2HibernateMappingGenerator\reg\*.*"
;  RMDir "$SMPROGRAMS\reg"
  Delete "$INSTDIR\reg\*.*"
  RMDir "$INSTDIR\reg"
  Delete "$INSTDIR\html\css\*.*"
  RMDir "$INSTDIR\html\css"
  Delete "$INSTDIR\html\*.*"
  RMDir "$INSTDIR\html"
  Delete "$INSTDIR\images\*.*"  
  RMDir "$INSTDIR\images"
  Delete "$INSTDIR\*.*"  
;  File /a "exe\lc2sys.dll"
  Delete "$INSTDIR\LC2HibernateMappingGeneratoruninst.exe"
  Delete "$INSTDIR\*.*"
  RMDir "$INSTDIR\"
  
  Delete "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LC2HibernateMappingGenerator\LC2HibernateMappingGenerator.lnk"
  Delete "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LC2HibernateMappingGenerator\LC2HibernateMappingGeneratoruninst.lnk"
  Delete "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LC2HibernateMappingGenerator\Support.lnk"
  ;RMDir "$SMPROGRAMS\$R0\LETZTECHANCE.ORG"
  ;RMDir "$SMPROGRAMS"

  
;  MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to remove the directory $INSTDIR\cpdest?" IDNO ;NoDelete
;    Delete "$INSTDIR\cpdest\*.*"
;    RMDir "$INSTDIR\cpdest" ; skipped if no
;NoDelete:
  
;  RMDir "$INSTDIR\MyProjectFamily\MyProject"
;  RMDir "$INSTDIR\MyProjectFamily"
  RMDir "$INSTDIR\"
  RMDir "$INSTDIR"
  RMDir "$SMPROGRAMS"

  IfFileExists "$INSTDIR" 0 NoErrorMsg
    MessageBox MB_OK "Note: $INSTDIR could not be removed!" IDOK 0 ; skipped if file doesn't exist
  NoErrorMsg:

SectionEnd
