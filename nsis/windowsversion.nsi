; This script will detect which Version of Windows is running. And display
; its version in a messagebox
; Email: dragonbals@hotmail.com
 
SetCompressor lzma
Name "Windows Detection"
OutFile "Windows Detection.exe"
 
SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal
 
XPStyle On
 
Function .onInit
 
  Push $R0
  Push $R1
 
  ClearErrors
 
  ReadRegStr $R0 HKLM \
  "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
 
  IfErrors 0 lbl_winnt
 
  ; we are not NT
  ReadRegStr $R0 HKLM \
  "SOFTWARE\Microsoft\Windows\CurrentVersion" VersionNumber
 
  StrCpy $R1 $R0 1
  StrCmp $R1 '4' 0 lbl_error
 
  StrCpy $R1 $R0 3
 
  StrCmp $R1 '4.0' lbl_win32_95
  StrCmp $R1 '4.9' lbl_win32_ME lbl_win32_98
 
  lbl_win32_95:
    StrCpy $R0 '95'
MessageBox MB_OK|MB_ICONQUESTION "Windows 95" IDOK 
Quit
    Goto lbl_done
 
  lbl_win32_98:
    StrCpy $R0 '98'
MessageBox MB_OK|MB_ICONQUESTION "Windows 98" IDOK 
Quit
    Goto lbl_done
 
  lbl_win32_ME:
    StrCpy $R0 'ME'
MessageBox MB_OK|MB_ICONQUESTION "Windows ME" IDOK 
Quit
    Goto lbl_done
 
  lbl_winnt:
 
  StrCpy $R1 $R0 1
 
  StrCmp $R1 '3' lbl_winnt_x
  StrCmp $R1 '4' lbl_winnt_x
 
  StrCpy $R1 $R0 3
 
  StrCmp $R1 '5.0' lbl_winnt_2000
  StrCmp $R1 '5.1' lbl_winnt_XP
  StrCmp $R1 '5.2' lbl_winnt_2003
  StrCmp $R1 '6.0' lbl_winnt_vista
  StrCmp $R1 '6.1' lbl_winnt_7 lbl_error
 
  lbl_winnt_x:
    StrCpy $R0 "NT $R0" 6
 
  Goto lbl_done
 
  lbl_winnt_2000:
    Strcpy $R0 '2000'
MessageBox MB_OK|MB_ICONQUESTION "Windows 2000" IDOK 
Quit
    Goto lbl_done
 
  lbl_winnt_XP:
    Strcpy $R0 'XP'
MessageBox MB_OK|MB_ICONQUESTION "Windows XP" IDOK 
Quit
    Goto lbl_done
 
  lbl_winnt_2003:
    Strcpy $R0 '2003'
MessageBox MB_OK|MB_ICONQUESTION "Windows 2003" IDOK 
Quit
    Goto lbl_done
 
  lbl_winnt_vista:
    Strcpy $R0 'Vista'
MessageBox MB_OK|MB_ICONQUESTION "Windows Vista" IDOK 
Quit
    Goto lbl_done
 
  lbl_winnt_7:
    Strcpy $R0 '7'
MessageBox MB_OK|MB_ICONQUESTION "Windows 7" IDOK 
Quit
  Goto lbl_done
 
  lbl_error:
    Strcpy $R0 ''
  lbl_done:
 
  Pop $R1
  Exch $R0
 
Quit
FunctionEnd
 
Section "-boo"
;
SectionEnd