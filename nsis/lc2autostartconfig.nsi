; lc2install.nsi
;
; This script attempts to test most of the functionality of the NSIS exehead.
;--------------------------------
!define APPNAME "LC2AutoStart"
!define COMPANYNAME "letztechance.org"
!define DESCRIPTION "A letztechance.org Installer - Created by David Honisch"
!define GINFILE ".\LC2AutoStart.cfg"

!ifdef HAVE_UPX
!packhdr tmp.dat "upx\upx -9 tmp.dat"
!endif

!ifdef NOCOMPRESS
SetCompress off
!endif
!define /date MyTIMESTAMP "%Y-%m-%d-%H-%M-%S"

;Running a .exe file on Windows Start
;!include "MUI.nsh"
;--------------------------------
;var vTitle
var S0
var INFILE


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
Caption "LCLauncher AutoStart Install (c)by http://www.letztechance.org"
;Icon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"
Icon "${NSISDIR}\Examples\favicon.ico"
;OutFile "LC2autostartConfig${MyTIMESTAMP}.exe"
OutFile "LC2autostartConfig.exe"

Function .onInit
	StrCpy $INFILE ${GINFILE} # ".\konfiguration.cfg"
   ;ReadINIStr $INSTDIR $WINDIR\wincmd.ini Configuration InstallDir
   ReadINIStr $S0 "$INFILE" configuration InstallDir
   StrCmp $S0 "" 0 NoAbort
;   MessageBox MB_OK "$INSTDIR\konfiguration.cfg not found. Creating configuration..."
	WriteINIStr "$INFILE"  "autorun" "name" "launcher.lnk"
	WriteINIStr "$INFILE"  "regkey" "name" "LC2Launcher"
	WriteINIStr "$INFILE"  "server" "name" "http://www.letztechance.org"
	WriteINIStr "$INFILE"  "http" "download" "/index.html"

     ;Abort ; causes installer to quit.
   NoAbort:
 ;  MessageBox MB_OK $S0$INSTDIR\konfiguration.cfg
 FunctionEnd

Section "Files"
;File /a "favicon.ico" 
SectionEnd
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
WriteRegDword HKLM SOFTWARE\LETZTECHANCE.ORG\AutoStartConfig "AutoStartConfig" 123456
WriteRegDword HKLM SOFTWARE\LETZTECHANCE.ORG\AutoStartConfig "AutoStartConfig" 0123
WriteRegBin HKLM SOFTWARE\LETZTECHANCE.ORG\AutoStartConfig "AutoStartConfig" "DEADBEEF01F00DBEEF"
;  StrCpy $8 "$SYSDIR\LC"{NSISDIR}
;WriteINIStr ".\konfiguration.cfg"  "server" "name""http://www.letztechance.org"
;WriteINIStr ".\konfiguration.cfg"  "http" "download" "/read.php?f=3&i=30&t=30"
WriteINIStr "$INFILE"  "update" "date" "${MyTIMESTAMP}"
MessageBox MB_OK "Configuration sucessfully written..."
SectionEnd

Section
MessageBox MB_OK "Execute..."
SetOutPath ".\"
    ExpandEnvStrings $0 %COMSPEC%
    nsExec::ExecToStack '"LC2autostart.bat"'
SectionEnd

Section
	;${DriveSpace} "C:\" "/D=F /S=M" $R0
	; $R0="2530"   megabytes free on drive C:
SectionEnd

