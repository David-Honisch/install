; Java Launcher with automatic JRE installation
;-----------------------------------------------
 
Name "LC2Java Virtual Machine Launcher"
Caption "LC2Java Virtual Machine Launcher"
; Icon "Java Launcher.ico"
Icon "../lc.ico"
OutFile "LC2JVMInstall.exe"

!include WinMessages.nsh
!include Sections.nsh
!include MUI.nsh
;!include nsProcess.nsh

 
VIAddVersionKey "ProductName" "LETZTECHANCE.ORG LC2Java Virtual Machine Launcher"
VIAddVersionKey "Comments" "LETZTECHANCE.ORG"
VIAddVersionKey "CompanyName" "LETZTECHANCE.ORG"
VIAddVersionKey "LegalTrademarks" "Java Launcher is a trademark of LETZTECHANCE.ORG"
VIAddVersionKey "LegalCopyright" "LETZTECHANCE.ORG"
VIAddVersionKey "FileDescription" "LETZTECHANCE.ORG Java Launcher"
VIAddVersionKey "FileVersion" "1.0.0"
VIProductVersion "1.0.0.1"
 
!define CLASSPATH "LC2JVM.jar"
!define CLASS "LC2TestJava"
!define PRODUCT_NAME "LC2Java Virtual Machine Launcher"
 
; Definitions for Java 6.0
!define JRE_VERSION "6.0"
!define JRE_URL "http://javadl.sun.com/webapps/download/AutoDL?BundleId=24936&/jre-6u10-windows-i586-p.exe"
;!define JRE_VERSION "5.0"
;!define JRE_URL "http://javadl.sun.com/webapps/download/AutoDL?BundleId=22933&/jre-1_5_0_16-windows-i586-p.exe"
 
; use javaw.exe to avoid dosbox.
; use java.exe to keep stdout/stderr
!define JAVAEXE "javaw.exe"
;Variablen
Var StartMenuGroup
Var "JavaHome"
 
RequestExecutionLevel user
;SilentInstall silent
AutoCloseWindow true
ShowInstDetails nevershow
 
!include "FileFunc.nsh"
!insertmacro GetFileVersion
!insertmacro GetParameters
!include "WordFunc.nsh"
!insertmacro VersionCompare
 
!macro reportError errorMessage
    nsisdl::download /TIMEOUT=30000 "http://letztechance.org/submitWinInstallerBug?message=${errorMessage}&version="${VERSION}" "$TEMP\bugResults"
    # We just try to report the error and don't deal with errors reporting the error =).
    MessageBox MB_OK|MB_ICONSTOP "We're sorry, but there was an error installing LC2JVM, described only as '${errorMessage}'. Please try the installer again or contact LC2JVM at support@LC2JVM.org."
!macroend
 
Section ""
  Call DetectJRE

  
  Call configureFirewall
    #nsExec::Exec 'netsh firewall add allowedprogram "$INSTDIR\LC2JVM.exe" ${PRODUCT_NAME}'
#netsh advfirewall firewall add rule name="LC2JVM" dir=in #action=allow program="$INSTDIR\LC2JVM.exe" enable=yes

    #ExecDos::exec 'netsh firewall add allowedprogram program="$INSTDIR\LC2JVM.exe" name="LC2JVM" scope="ALL" profile="ALL"' "" "$INSTDIR\firewall.txt"
    #ExecDos::exec 'netsh firewall add allowedprogram program="$INSTDIR\LC2JVM.exe" name="LC2JVM" scope="ALL" profile="CURRENT"' "" "$INSTDIR\firewall.txt"
    
    Pop $0
    IfErrors 0 NoError
        !insertmacro reportError "netsherror$0"
    NoError:
    
    Call findJavaPath
    Pop $2

    IfSilent +2 0
    !insertmacro MUI_INSTALLOPTIONS_READ $2 "jvm.ini" "Field 2" "State"

    StrCpy "$JavaHome" $2
    Call findJVMPath
    Pop $2

    DetailPrint "Using Jvm: $2"
  
  Pop $R0
 
  ; change for your purpose (-jar etc.)
  ${GetParameters} $1
  StrCpy $0 '"$R0" -classpath "${CLASSPATH}" ${CLASS} $1'
 
  SetOutPath $EXEDIR
  Exec $0
  
  Call GetJRE
SectionEnd
 
;  returns the full path of a valid java.exe
;  looks in:
;  1 - .\jre directory (JRE Installed with application)
;  2 - JAVA_HOME environment variable
;  3 - the registry
;  4 - hopes it is in current dir or PATH
Function GetJRE
    Push $R0
    Push $R1
    Push $2
 
  ; 1) Check local JRE
  CheckLocal:
    ClearErrors
    StrCpy $R0 "$EXEDIR\jre\bin\${JAVAEXE}"
    IfFileExists $R0 JreFound
 
  ; 2) Check for JAVA_HOME
  CheckJavaHome:
    ClearErrors
    ReadEnvStr $R0 "JAVA_HOME"
    StrCpy $R0 "$R0\bin\${JAVAEXE}"
    IfErrors CheckRegistry     
    IfFileExists $R0 0 CheckRegistry
    Call CheckJREVersion
    IfErrors CheckRegistry JreFound
 
  ; 3) Check for registry
  CheckRegistry:
    ClearErrors
    ReadRegStr $R1 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
    ReadRegStr $R0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$R1" "JavaHome"
    StrCpy $R0 "$R0\bin\${JAVAEXE}"
    IfErrors DownloadJRE
    IfFileExists $R0 0 DownloadJRE
    Call CheckJREVersion
    IfErrors DownloadJRE JreFound
 
  DownloadJRE:
    Call ElevateToAdmin
    MessageBox MB_ICONINFORMATION "${PRODUCT_NAME} uses Java Runtime Environment ${JRE_VERSION}, it will now be downloaded and installed."
    StrCpy $2 "$TEMP\Java Runtime Environment.exe"
    nsisdl::download /TIMEOUT=30000 ${JRE_URL} $2
    Pop $R0 ;Get the return value
    StrCmp $R0 "success" +3
      MessageBox MB_ICONSTOP "Download failed: $R0"
      Abort
    ExecWait $2
    Delete $2
 
    ReadRegStr $R1 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
    ReadRegStr $R0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$R1" "JavaHome"
    StrCpy $R0 "$R0\bin\${JAVAEXE}"
    IfFileExists $R0 0 GoodLuck
    Call CheckJREVersion
    IfErrors GoodLuck JreFound
 
  ; 4) wishing you good luck
  GoodLuck:
    StrCpy $R0 "${JAVAEXE}"
    ; MessageBox MB_ICONSTOP "Cannot find appropriate Java Runtime Environment."
    ; Abort
 
  JreFound:
    Pop $2
    Pop $R1
    Exch $R0
FunctionEnd
 
; Pass the "javaw.exe" path by $R0
Function CheckJREVersion
    Push $R1
 
    ; Get the file version of javaw.exe
    ${GetFileVersion} $R0 $R1
    ${VersionCompare} ${JRE_VERSION} $R1 $R1
 
    ; Check whether $R1 != "1"
    ClearErrors
    StrCmp $R1 "1" 0 CheckDone
    SetErrors
 
  CheckDone:
    Pop $R1
FunctionEnd
 
; Attempt to give the UAC plug-in a user process and an admin process.
Function ElevateToAdmin
  UAC_Elevate:
    UAC::RunElevated
    StrCmp 1223 $0 UAC_ElevationAborted ; UAC dialog aborted by user?
    StrCmp 0 $0 0 UAC_Err ; Error?
    StrCmp 1 $1 0 UAC_Success ;Are we the real deal or just the wrapper?
    Quit
 
  UAC_ElevationAborted:
    # elevation was aborted, run as normal?
    MessageBox MB_ICONSTOP "This installer requires admin access, aborting!"
    Abort
 
  UAC_Err:
    MessageBox MB_ICONSTOP "Unable to elevate, error $0"
    Abort
 
  UAC_Success:
    StrCmp 1 $3 +4 ;Admin?
    StrCmp 3 $1 0 UAC_ElevationAborted ;Try again?
    MessageBox MB_ICONSTOP "This installer requires admin access, try again"
    goto UAC_Elevate 
FunctionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Installer functions
Function .onInit
 
    ; Uninstall the old version if it's there.  This will typically mark most
    ; files for deletion upon reboot because they're typically in use.
    ReadRegStr $R0 HKLM \
      "Software\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" \
      "UninstallString"
    
    DetailPrint "Initing installer with old version at: $R0"
    ;MessageBox MB_OK "Initing installer with old version at: $R0"
    
    ; Jump to done if it's not there.
    StrCmp $R0 "" done

      ;ClearErrors
      ; Note we pass the /S param to make the uninstall silent.
      ;ExecWait '$R0 _?=$INSTDIR /S' ;Do not copy the uninstaller to a temp file
      ExecWait '$R0 /S' ;Do not copy the uninstaller to a temp file
      ;Exec '$INSTDIR\uninstall.exe /S'
    
      ;IfErrors no_remove_uninstaller
        ;You can either use Delete /REBOOTOK in the uninstaller or add some code
        ;here to remove the uninstaller. Use a registry key to check
        ;whether the user has chosen to uninstall. If you are using an uninstaller
        ;components page, make sure all sections are uninstalled.
      ;no_remove_uninstaller:
      
    done:
     
    InitPluginsDir
    StrCpy $StartMenuGroup LC2JVM
FunctionEnd

; Uninstaller functions
Function un.onInit
    ; Comment out the following line to see the detailed uninstall information
    ; without the window closing before you can read it.
    SetAutoClose true
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    ReadRegStr $StartMenuGroup HKLM "${REGKEY}" StartMenuGroup
    
    ;insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd

Function un.onUninstFailed
    MessageBox MB_OK "We're sorry, but there was an error uninstalling $(^Name)."
FunctionEnd

Function GetJREnv
    MessageBox MB_OK "$(^Name) requires Java 1.5 or above.  Please be \
        patient while $(^Name) automatically downloads and installs it.  "
 
    StrCpy $2 "$TEMP\Java Runtime Environment.exe"
    nsisdl::download /TIMEOUT=30000 ${JRE_URL} $2
    Pop $R0 ;Get the return value
    StrCmp $R0 "success" +3
    MessageBox MB_OK "We're sorry, but the doownload failed due to the \
        following error: $R0.  You can try running this installer again, or \
        you could try installing Java manually from http://www.java.com"
    Quit
    ExecWait $2
    Delete $2
FunctionEnd
 
 
Function DetectJRE
  ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" \
             "CurrentVersion"
  StrCmp $2 ${JRE_VERSION} done
  StrCmp $2 "1.6" done
  StrCmp $2 "1.7" done
  StrCmp $2 "1.8" done
  StrCmp $2 "1.9" done
  
  Call GetJREnv
  
  done:
FunctionEnd

; =====================
; CheckUserType Function
; =====================
;
; Check the user type, and warn if it's not an administrator.
; Taken from Tomcat, which was taken from Examples/UserInfo that ships with NSIS.
Function CheckUserType
  ClearErrors
  UserInfo::GetName
  IfErrors Win9x
  Pop $0
  UserInfo::GetAccountType
  Pop $1
  StrCmp $1 "Admin" 0 +3
    ; This is OK, do nothing
    Goto done

    MessageBox MB_OK|MB_ICONEXCLAMATION "We're sorry, but you must have \
        administrator privileges to install LC2JVM. \
        Please log on as a user with administrator privileges."
    Goto done

  Win9x:
    # This one means you don't need to care about admin or
    # not admin because Windows 9x doesn't either
    MessageBox MB_OK "Error! We're sorry, but LC2JVM can't run under Windows 9x!"

  done:
FunctionEnd

; =====================
; FindJavaPath Function
; =====================
;
; Find the JAVA_HOME used on the system, and put the result on the top of the
; stack
; Will return an empty string if the path cannot be determined
;
Function findJavaPath

  ;ClearErrors

  ;ReadEnvStr $1 JAVA_HOME

  ;IfErrors 0 FoundJDK

  ClearErrors

  ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
  ReadRegStr $1 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$2" "JavaHome"
  ReadRegStr $3 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$2" "RuntimeLib"

  ;FoundJDK:

  IfErrors 0 NoErrors
  StrCpy $1 ""

NoErrors:

  ClearErrors

  ; Put the result in the stack
  Push $1

FunctionEnd


; ====================
; FindJVMPath Function
; ====================
;
; Find the full JVM path, and put the result on top of the stack
; Argument: JVM base path (result of findJavaPath)
; Will return an empty string if the path cannot be determined
;
Function findJVMPath

  ClearErrors
  
  ;Step one: Is this a JRE path (Program Files\Java\XXX)
  StrCpy $1 "$JavaHome"
  
  StrCpy $2 "$1\bin\hotspot\jvm.dll"
  IfFileExists "$2" FoundJvmDll
  StrCpy $2 "$1\bin\server\jvm.dll"
  IfFileExists "$2" FoundJvmDll
  StrCpy $2 "$1\bin\client\jvm.dll"  
  IfFileExists "$2" FoundJvmDll
  StrCpy $2 "$1\bin\classic\jvm.dll"
  IfFileExists "$2" FoundJvmDll

  ;Step two: Is this a JDK path (Program Files\XXX\jre)
  StrCpy $1 "$JavaHome\jre"
  
  StrCpy $2 "$1\bin\hotspot\jvm.dll"
  IfFileExists "$2" FoundJvmDll
  StrCpy $2 "$1\bin\server\jvm.dll"
  IfFileExists "$2" FoundJvmDll
  StrCpy $2 "$1\bin\client\jvm.dll"  
  IfFileExists "$2" FoundJvmDll
  StrCpy $2 "$1\bin\classic\jvm.dll"
  IfFileExists "$2" FoundJvmDll

  ClearErrors
  ;Step tree: Read defaults from registry
  
  ReadRegStr $1 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
  ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$1" "RuntimeLib"
  
  IfErrors 0 FoundJvmDll
  StrCpy $2 ""

  FoundJvmDll:
  ClearErrors

  ; Put the result in the stack
  Push $2

FunctionEnd

Function unpackJars
    FindFirst $0 $1 $INSTDIR\*.pack
    Var /GLOBAL baseJarName
    ClearErrors
    loop:
      StrCmp $1 "" done
      StrCpy $baseJarName $1 -5 
      DetailPrint "Unpacking $1 to $baseJarName"
      ExecWait '"$TEMP\noConsole.exe" "$TEMP\unpack200.exe" -vr "$INSTDIR\$1" "$INSTDIR\$baseJarName"' $3
      IfErrors 0 NoError
       ;!insertmacro reportError "unpackerror$3"
        Abort
      NoError:
        FindNext $0 $1
        Goto loop
    done:
Functionend



Function launchApp
    ; Start the program, passing the installer flag.
    #ExecWait '"$INSTDIR\LC2JVM.exe" installer' 
    Exec '"$INSTDIR\LC2JVM.exe" installer'
Functionend

Function browserMessage
    messagebox mb_ok|mb_iconinformation "Thank you for installing LC2JVM. We'll now return you to the LC2JVM home page."
    ExecShell "open" "http://www.LC2JVM.org/welcome?fromWinInstaller=true"
Functionend

Function configureFirewall
 
  Push $R0
  Push $R1
 
  ClearErrors
 
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
 
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
    Goto lbl_netsh
 
  lbl_winnt_XP:
    Strcpy $R0 'XP'
    Goto lbl_netsh
 
  lbl_winnt_2003:
    Strcpy $R0 '2003'
    Goto lbl_netsh
 
  lbl_winnt_vista:
    Strcpy $R0 'Vista'
    Goto lbl_netshAdvanced
 
  lbl_winnt_7:
    Strcpy $R0 '7'
    Goto lbl_netshAdvanced
 
  lbl_netsh:
    DetailPrint "Using old netsh format"
    nsExec::Exec 'netsh firewall add allowedprogram "$INSTDIR\LC2JVM.exe" "${PRODUCT_NAME}" ENABLE'
    Goto lbl_done

  lbl_netshAdvanced:
    DetailPrint "Using new netsh format"
    nsExec::Exec 'netsh advfirewall firewall add rule name="${PRODUCT_NAME}" dir=in action=allow program="$INSTDIR\LC2JVM.exe" enable=yes profile=any'
    Goto lbl_done

  lbl_error:
    Strcpy $R0 ''
 
  lbl_done:
 
  Pop $R1
  Exch $R0
FunctionEnd

Function un.deleteFirewallSettings
 
  Push $R0
  Push $R1
 
  ClearErrors
 
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
 
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
    Goto lbl_netsh
 
  lbl_winnt_XP:
    Strcpy $R0 'XP'
    Goto lbl_netsh
 
  lbl_winnt_2003:
    Strcpy $R0 '2003'
    Goto lbl_netsh
 
  lbl_winnt_vista:
    Strcpy $R0 'Vista'
    Goto lbl_netshAdvanced
 
  lbl_winnt_7:
    Strcpy $R0 '7'
    Goto lbl_netshAdvanced
 
  lbl_netsh:
    DetailPrint "Removing using old netsh format"
    nsExec::Exec 'netsh firewall delete allowedprogram "$INSTDIR\LC2JVM.exe"'
    Goto lbl_done

  lbl_netshAdvanced:
    DetailPrint "Removing using old netsh format"
    nsExec::Exec 'netsh advfirewall firewall delete rule name="${PRODUCT_NAME}" program="$INSTDIR\LC2JVM.exe"'
    Goto lbl_done

  lbl_error:
    Strcpy $R0 ''
 
  lbl_done:
 
  Pop $R1
  Exch $R0
FunctionEnd