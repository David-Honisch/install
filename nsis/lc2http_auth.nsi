
;--------------------------------
; General Attributes

Name "LC2Update via HTTP Authentication"
Icon "${NSISDIR}\Examples\favicon.ico"
OutFile "LC2Update.exe"
Caption "LC2MSSQLBackupAndRestore Install (c)by http://www.letztechance.org"

;SilentInstall silent

!packhdr "$%TEMP%\exehead.dat" 'header.cmd'



;--------------------------------
;Interface Settings

  !include "MUI.nsh"
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_LANGUAGE "English"


;--------------------------------
;Installer Sections

Section "Default Section" SecDummy

!define LR_SHARED	0x8000
!define IMAGE_ICON	1
# Get a handle for some window on $R1 and some field on that window on $R2 (define those somewhere)
FindWindow $R1 "#32770" "" $HWNDPARENT
StrCpy $R2 1239
GetDlgItem $0 $R1 $R2
System::Call 'kernel32::GetModuleFileNameA(i 0, t .R0, i 1024) i r1'
System::Call 'kernel32::GetModuleHandleA(t R0)i .r2'
System::Call 'user32::LoadImage(i r2, i 101, i ${IMAGE_ICON}, , , i ${LR_SHARED}) i.R0'
SendMessage $0 ${STM_SETICON} $R0 0

; Displays IE auth dialog.
; Please test this with your own link
	
;	InetLoad::load "http://www.letztechance.org/upload/dl.php?id=3" "$EXEDIR\patch.exe" \
;				   "http://www.letztechance.org/personal/LC2MSSQLBackupAndRestoreinstall.exe" "$EXEDIR\patch.exe"
	InetLoad::load "http://www.letztechance.org/upload/dl.php?id=3" "$EXEDIR\patch.exe"

	Pop $0
    ;InetLoad::load /POPUP "http auth test" "http://www.cnt.ru/personal" "$EXEDIR\auth.html"
	;InetLoad::load /POPUP "http auth test" "http://www.letztechance.org/personal/LC2MSSQLBackupAndRestoreinstall.exe" "$EXEDIR\patch.exe"
    ;Pop $0 # return value = exit code, "OK" if OK
    MessageBox MB_OK "Download Status: $0"

SectionEnd
