Caption "LC2VCRedistributable Install (c)by http://www.letztechance.org"
Icon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"
OutFile "LC2VCRedistinstall.exe"

;-------------------------------
; Test if Visual Studio Redistributables 2005+ SP1 installed
; Returns -1 if there is no VC redistributables intstalled
Section ""
Call CheckVCRedist
SectionEnd

Function CheckVCRedist
   Push $R0
   ClearErrors
   ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7299052b-02a4-4627-81f2-1818da5d550d}" "Version"

   ; if VS 2005+ redist SP1 not installed, install it
   IfErrors 0 VSRedistInstalled
   MessageBox MB_OK "Die Microsoft VC 8.0 Redistributables werden jetzt installiert."
   StrCpy $R0 "-1"
	
VSRedistInstalled:
   Exch $R0
   MessageBox MB_OK "Die Microsoft VC 8.0 Redistributables wurden erfolgreich installiert."
FunctionEnd
