; lc2install.nsi
;
; This script attempts to test most of the functionality of the NSIS exehead.
;--------------------------------
!define APPNAME "LC2AutoStart"
!define COMPANYNAME "letztechance.org"
!define DESCRIPTION "A letztechance.org UnInstaller - Created by David Honisch"
!define GINFILE ".\LC2AutoStart.cfg"
!ifdef HAVE_UPX
!packhdr tmp.dat "upx\upx -9 tmp.dat"
!endif

!ifdef NOCOMPRESS
SetCompress off
!endif
var SOUTPATH
var S0
var S1
var INFILE


;Running a .exe file on Windows Start
;!include "MUI.nsh"
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

 
Name "START WINDOWS"
Caption "LCLauncher AutoStart UnInstall (c)by http://www.letztechance.org"
;Icon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"
Icon "${NSISDIR}\Examples\favicon.ico"
OutFile "LC2autostart.exe"

Function .onInit
   StrCpy $INFILE ${GINFILE} # ".\konfiguration.cfg"
   ;ReadINIStr $INSTDIR $WINDIR\wincmd.ini Configuration InstallDir
   ReadINIStr $S0 "$INFILE" autorun name
   ReadINIStr $S1 "$INFILE" regkey name
   ;MessageBox MB_OK $S0
   StrCmp $S0 "" 0 NoAbort
   MessageBox MB_OK "$INSTDIR\$INFILE not found. Abort process."
   Abort ; causes installer to quit.
   NoAbort:
   ;MessageBox MB_OK "$S0 in $INSTDIR\konfiguration.cfg found."
 FunctionEnd

;Section "Files"
;File /a "favicon.ico" 
;SectionEnd
;!insertmacro MUI_LANGUAGE "Spanish"

SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal
BGGradient FFFFFF A66E3C 000000
InstallColors A66E3C FFFFFF
XPStyle on

LicenseText "HTTP://WWW.LETZTECHANCE.ORG"
LicenseData "readme.txt"

Section
	System::Call "kernel32::GetCurrentDirectory(i ${NSIS_MAX_STRLEN}, t .r0)"
	StrCpy $SOUTPATH "$0"
	;MessageBox MB_OK "$SOUTPATH"
SectionEnd

 
Section
# Start Menu
#	createDirectory "$SMPROGRAMS\${COMPANYNAME}"
#	createShortCut "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}.lnk" "$SOUTPATH\$S0" "" "${NSISDIR}\Examples\favicon.ico"
#	createShortCut "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}.lnk" "$SOUTPATH\$S0" "" "${NSISDIR}\Examples\favicon.ico"
#	CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCLauncher.NET\LCLauncher.NET.lnk" $INSTDIR\launcher.exe
#	CreateShortCut "$SMPROGRAMS\Startup\$S1.lnk" "$SOUTPATH\$S0"
	Delete "$SMPROGRAMS\Startup\$S1.lnk"
#WriteRegStr HKLM "Software\letztechance.org\Uninstall" \
#  "$S1" "$SOUTPATH\$S0"
#autostart key  
#  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Run" \
#  "$S1" "$SOUTPATH\$S0"
#test
#WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Run" \
#  "test" "test"  
  
;SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run  
;  WriteRegStr HKEY_LOCAL_MACHINE "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" \
;  "LC2Launcher" "$SOUTPATH\$S0"
;"LC2Launcher" "$WinDir\$S0"
;  MessageBox MB_OK "The $SOUTPATH\$S0 Running is now registered to startup"
SectionEnd