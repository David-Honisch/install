;Locate Java Runtime/JRE, ensure correct version, write CLASSPATH, PATH and JAVA HOME to .bat file.
Caption "LC2JRE Install (c)by http://www.letztechance.org"
Icon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"
;--------------------------------
;Steps
;--------------------------------
;Locate Java Runtime/JRE
;Ensure version 1.4 or higher
;Write CLASSPATH, PATH and JAVA_HOME to .Bat file
;
;If JRE unavailable or version less than 1.4, launch Explorer and open ;http://www.java.com and inform user to download the correct version of JRE.
;--------------------------------
 
;--------------------------------
;AUTHOR: Ashwin Jayaprakash
;WEBSITE: http://www.JavaForU.com
;--------------------------------
 
;--------------------------------
; Constants
;--------------------------------
!define GET_JAVA_URL "http://www.java.com"
 
;--------------------------------
; Variables
;--------------------------------
  Var JAVA_HOME
  Var JAVA_VER
  Var JAVA_INSTALLATION_MSG
 
;--------------------------------
; Main Install settings
;--------------------------------
Name "LC2JVM"
InstallDir ".\"
OutFile "LC2JRE_Installer.exe"
 
;--------------------------------
Section "JRE Locate and Set Path and Classpath Section" JRECheckAndEnvSection
    Call LocateJVM
    StrCmp "" $JAVA_INSTALLATION_MSG Success OpenBrowserToGetJava
 
    Success:
        Call SetEnv
		;neu !!!!
		Call getEnv
        Goto Done
 
    OpenBrowserToGetJava:
        Exec '"explorer.exe" ${GET_JAVA_URL}'
    Done:
SectionEnd
;--------------------------------
Function LocateJVM
    ;Check for Java version and location
    Push $0
    Push $1
 
    ReadRegStr $JAVA_VER HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" CurrentVersion
    StrCmp "" "$JAVA_VER" JavaNotPresent CheckJavaVer
 
    JavaNotPresent:
        StrCpy $JAVA_INSTALLATION_MSG "Java Runtime Environment is not installed on your computer. You need version 1.4 or newer to run this program."
        Goto Done
 
    CheckJavaVer:
        ReadRegStr $0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$JAVA_VER" JavaHome
        GetFullPathName /SHORT $JAVA_HOME "$0"
        StrCpy $0 $JAVA_VER 1 0
        StrCpy $1 $JAVA_VER 1 2
        StrCpy $JAVA_VER "$0$1"
        IntCmp 14 $JAVA_VER FoundCorrectJavaVer FoundCorrectJavaVer JavaVerNotCorrect
 
    FoundCorrectJavaVer:
        IfFileExists "$JAVA_HOME\bin\javaw.exe" 0 JavaNotPresent
        ;MessageBox MB_OK "Found Java: $JAVA_VER at $JAVA_HOME"
        Goto Done
 
    JavaVerNotCorrect:
        StrCpy $JAVA_INSTALLATION_MSG "The version of Java Runtime Environment installed on your computer is $JAVA_VER. Version 1.4 or newer is required to run this program."
 
    Done:
        Pop $1
        Pop $0
FunctionEnd
;--------------------------------
Function SetEnv
    Push $3
    Push $4
 
    FileOpen $4 "$INSTDIR\setEnv.cmd" w
    StrCpy $3 "Set CLASSPATH=$JAVA_HOME\jre\libt.jar;$JAVA_HOME\lib\dt.jar;%CLASSPATH%"
    FileWrite $4 "$3"
 
    FileWriteByte $4 "13"
    FileWriteByte $4 "10"
 
    StrCpy $3 "Set PATH=$JAVA_HOME\bin;%PATH%"
    FileWrite $4 "$3"

    FileWriteByte $4 "13"
    FileWriteByte $4 "10"
	
	StrCpy $3 "pause()"
    FileWrite $4 "$3"

	FileClose $4
 
    Pop $4
    Pop $3
FunctionEnd

Function getEnv
 ExecShell "open" '"$INSTDIR\setenv.cmd"'
  ExecWait '"$1"'
  Sleep 500
  BringToFront
FunctionEnd
;--------------------------------
; eof
;--------------------------------