Caption "LC2JRE Install (c)by http://www.letztechance.org"
Icon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"
; Quicktime version checker
; by Rob Hudson <rob@euglug.net>
;
; hasMinQuicktime
; Returns 0 for no quicktime or not minimum required version
; Returns 1 if installed version is greater than or equal to min version
;
; Example of Usage:
; !define minQTMaj "6" ; major version required
; !define minQTMin "0" ; minor version required
; Call hasMinQuicktime
; Pop $R0
; IntCmp $R0 1 lbl_QT_OK
; ; Doesn't have the min version of Quicktime
; lbl_QT_OK:
; ; Has min version of Quicktime
Function hasMinQuicktime
	ClearErrors
	ReadRegDWord $R0 HKLM "SOFTWARE\Apple Computer, Inc.\QuickTime" Version
	IfErrors 0 lbl_has_qt
 
	; doesn't have quicktime
	Push "0"
	Goto lbl_done
 
	lbl_has_qt:
	IntFmt $R1 "0x%08X" $R0
	IntOp $R2 $R1 / 0x01000000 ; Major version number
	IntOp $R3 $R1 & 0x00FF0000
	IntOp $R4 $R3 / 0x00100000 ; Minor version number
 
	;MessageBox MB_OK "You have version $R2.$R4 of Quicktime."
 
	; Major version check
	IntCmp $R2 ${minQTMaj} lbl_maj_equal lbl_maj_less lbl_maj_more
	lbl_maj_less:
		Push "0"
		Goto lbl_done
	lbl_maj_more:
		Push "1"
		Goto lbl_done
	lbl_maj_equal:
		; Check minor version
		IntCmp $R4 ${minQTMin} lbl_min_equal lbl_min_less lbl_min_more
		lbl_min_less:
			Push "0"
			Goto lbl_done
		lbl_min_more:
		lbl_min_equal:
			Push "1"
			Goto lbl_done
 
	lbl_done:
 
FunctionEnd