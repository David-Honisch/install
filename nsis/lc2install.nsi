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

Name "LC2SEARCH at http://www.letztechance.org"
Caption "LC2SEARCH Installer"
Icon "${NSISDIR}\Contrib\Graphics\Icons\lc16.ico"
OutFile "lc2search.exe"

SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal
BGGradient FFFFFF A66E3C 000000
InstallColors A66E3C FFFFFF
XPStyle on

InstallDir "$PROGRAMFILES\WWW.LETZTECHANCE.ORG\NC2SEARCH"
InstallDirRegKey HKLM "Software\WWW.LETZTECHANCE.ORG\NC2SEARCH" ""

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

  ; write reg info
  StrCpy $1 "POOOOOOOOOOOP"
  DetailPrint "I like to be able to see what is going on (debug) $1"
  WriteRegStr HKLM SOFTWARE\NSISTest\NC2SEARCH "Install_Dir" "$INSTDIR"

  ; write uninstall strings
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NC2SEARCH" "DisplayName" "NC2SEARCH (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NC2SEARCH" "UninstallString" '"$INSTDIR\nc2searchuninst.exe"'

  SetOutPath $INSTDIR
  File /a "exe\lc2search.exe"
  CreateDirectory "$INSTDIR\WWW.LETZTECHANCE.ORG\NC2SEARCH" ; 2 recursively create a directory for fun.
  WriteUninstaller "nc2searchuninst.exe"
  
  Nop ; for fun

SectionEnd

Section "NC2SEARCH"

SectionIn 1 2 3
;  Start: MessageBox MB_OK "Starte Installation"
Start: MessageBox MB_YESNO "Wollen Sie dieses Programm wirklich installieren ?" IDYES Start

;  MessageBox MB_YESNO "Goto MyLabel" IDYES MyLabel

;  MessageBox MB_OK "Right before MyLabel:"

;  MyLabel: MessageBox MB_OK "MyLabel:"
  
;  MessageBox MB_OK "Right after MyLabel:"

;  MessageBox MB_YESNO "Goto Start:?" IDYES Start

SectionEnd

SectionGroup /e Applikatonen

Section "Registry/INI functions"

SectionIn 1 4 3

  WriteRegStr HKLM SOFTWARE\NSISTest\NC2SEARCH "StrTest_INSTDIR" "$INSTDIR"
  WriteRegDword HKLM SOFTWARE\NSISTest\NC2SEARCH "DwordTest_0xDEADBEEF" 0xdeadbeef
  WriteRegDword HKLM SOFTWARE\NSISTest\NC2SEARCH "DwordTest_123456" 123456
  WriteRegDword HKLM SOFTWARE\NSISTest\NC2SEARCH "DwordTest_0123" 0123
  WriteRegBin HKLM SOFTWARE\NSISTest\NC2SEARCH "BinTest_deadbeef01f00dbeef" "DEADBEEF01F00DBEEF"
  StrCpy $8 "$SYSDIR\IniTest"
  WriteINIStr "$INSTDIR\lc.ini"  "LC2Applikationen" "Value1" $8
  WriteINIStr "$INSTDIR\lc.ini"  "server" "http://www.letztechance.org" $8
  WriteINIStr "$INSTDIR\lc.ini"  "LC2Ini" "Value1" $8
  WriteINIStr "$INSTDIR\lc.ini"  "LC2Ini" "Value2" $8
  WriteINIStr "$INSTDIR\lc.ini"  "LC2INI" "Value1" $8

  Call MyFunctionTest

  DeleteINIStr "$INSTDIR\lc.ini" "LC2INI" "Value1"
  DeleteINISec "$INSTDIR\lc.ini" "LC2INi"

  ReadINIStr $1 "$INSTDIR\lc.ini" "LC2INi" "Value1"
  StrCmp $1 "" INIDelSuccess
    MessageBox MB_OK "DeleteINISec failed"
  INIDelSuccess:

  ClearErrors
  ReadRegStr $1 HKCR "software\microsoft" xyz_¢¢_does_not_exist
  IfErrors 0 NoError
    MessageBox MB_OK "could not read from HKCR\software\microsoft\xyz_¢¢_does_not_exist"
    Goto ErrorYay
  NoError:
    MessageBox MB_OK "read '$1' from HKCR\software\microsoft\xyz_¢¢_does_not_exist"
  ErrorYay:
  
SectionEnd

Section "CreateShortCuts"

  SectionIn 1 2 3

  Call CSCTest

SectionEnd

SectionGroup Tools

Section "Branching" 
  
;  BeginTestSection:
  SectionIn 1 2 3
 
  SetOutPath $INSTDIR

;  IfFileExists "$INSTDIR\search2.html" 0 69
    
;    MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to overwrite $INSTDIR\search2.html?" IDNO NoOverwrite ; skipped if file doesn't exist

;    69:
  
;    SetOverwrite ifnewer ; NOT AN INSTRUCTION, NOT COUNTED IN SKIPPINGS

;  NoOverwrite:

  File /a "html\search2.html" ; skipped if answered no
;  SetOverwrite try ; NOT AN INSTRUCTION, NOT COUNTED IN SKIPPINGS

;  MessageBox MB_YESNO|MB_ICONQUESTION "Letzte Version überschreiben ?" IDYES EndTestBranch
;  MessageBox MB_YESNO|MB_ICONQUESTION "Zur Aktualisierung ?" IDYES BeginTestSection
;  MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to hide the installer and wait five seconds?" IDNO ;NoHide

;    HideWindow
;    Sleep 5000
;    BringToFront
;  NoHide:

;  MessageBox MB_YESNO|MB_ICONQUESTION "Willst Du diese Funktion 5 mal sehen?" IDNO NoRecurse

;    StrCpy $1 "x"

;  LoopTest: 
      
;    Call myfunc
;    StrCpy $1 "x$1"
;    StrCmp $1 "xxxxxx" 0 LoopTest
      
;  NoRecurse:

;  End69:

SectionEnd

SectionGroupEnd

Section "Copy Base Files"

  SectionIn 1 2 3

  SetOutPath $INSTDIR\cpdest
  CopyFiles "$WINDIR\*.ini" "$INSTDIR\cpdest" 0

SectionEnd

SectionGroupEnd

Section "Exec functions" TESTIDX

  SectionIn 1 2 3
  
  SearchPath $1 notepad.exe

  MessageBox MB_OK "notepad.exe=$1"
  Exec '"$1"'
  ExecShell "open" '"$INSTDIR"'
  Sleep 500
  BringToFront

SectionEnd

Section "ActiveX Control Registration"

  SectionIn 2

  UnRegDLL "$SYSDIR\spin32.ocx"
  Sleep 1000
  RegDLL "$SYSDIR\spin32.ocx"
  Sleep 1000
  
SectionEnd

;--------------------------------

Function "CSCTest"
  
  CreateDirectory "$SMPROGRAMS\LC"
  SetOutPath $INSTDIR ; for working directory
  CreateShortCut "$SMPROGRAMS\LC\Uninstall NC2SEARCH.lnk" "$INSTDIR\nc2serachuninst.exe" ; use defaults for parameters, icon, etc.
  ; this one will use notepad's icon, start it minimized, and give it a hotkey (of Ctrl+Shift+Q)
;  CreateShortCut "$SMPROGRAMS\LC2SEARCH\silent.nsi.lnk" "$INSTDIR\silent.nsi" "" "$WINDIR\notepad.exe" 0 SW_SHOWMINIMIZED CONTROL|SHIFT|Q
;  CreateShortCut "$SMPROGRAMS\NC2SEARCH\TheDir.lnk" "$INSTDIR\" "" "" 0 SW_SHOWMAXIMIZED CONTROL|SHIFT|Z

FunctionEnd

;Function myfunc

;  StrCpy $2 "MyTestVar=$1"
;  MessageBox MB_OK "myfunc: $2"

;FunctionEnd

Function MyFunctionTest

  ReadINIStr $1 "$INSTDIR\test.ini" "MySectionIni" "Value1"
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
  SectionSetText ${TESTIDX} "TextInSection"
e2:

FunctionEnd

;--------------------------------

; Uninstaller

UninstallText "Uninstall NC2SEARCH ?"
;UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\nsis1-uninstall.ico"
UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\lc16-uninstall.ico"

Section "Uninstall"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NC2SEARCH"
  DeleteRegKey HKLM "SOFTWARE\NSISTest\NC2SEARCH"
;  Delete "$INSTDIR\silent.nsi"
;  Delete "$INSTDIR\LogicLib.nsi"
  Delete "$INSTDIR\nc2searchuninst.exe"
  Delete "$INSTDIR\lc.ini"
  Delete "$SMPROGRAMS\NC2SEARCH\*.*"
  RMDir "$SMPROGRAMS\NC2SEARCH"
  
  MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to remove the directory $INSTDIR\cpdest?" IDNO NoDelete
    Delete "$INSTDIR\cpdest\*.*"
    RMDir "$INSTDIR\cpdest" ; skipped if no
  NoDelete:
  
  RMDir "$INSTDIR\MyProjectFamily\MyProject"
  RMDir "$INSTDIR\MyProjectFamily"
  RMDir "$INSTDIR"

  IfFileExists "$INSTDIR" 0 NoErrorMsg
    MessageBox MB_OK "Note: $INSTDIR could not be removed!" IDOK 0 ; skipped if file doesn't exist
  NoErrorMsg:

SectionEnd
