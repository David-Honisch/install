OutFile "LC2JDKDetect.exe"
Section ""
ClearErrors

ReadRegStr $1 HKLM "SOFTWARE\JavaSoft\Java Development Kit" "CurrentVersion"
ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$1" "JavaHome"
 
IfErrors 0 NoAbort
    MessageBox MB_OK "Couldn't find a Java Development Kit installed. Setup will exit now." 
    Quit        
 
NoAbort:
    DetailPrint "Found JDK in path $2"
	MessageBox MB_OK "Found JDK in path $2"
SectionEnd	