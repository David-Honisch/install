!ifdef HAVE_UPX
!packhdr tmp.dat "upx\upx -9 tmp.dat"
!endif

!ifdef NOCOMPRESS
SetCompress off
!endif
Icon "${NSISDIR}\Examples\favicon.ico"
!ifndef UserDetails
 !define UserDetails '!insertmacro _UserDetailsRetrieve'
 
    !macro _UserDetailsRetrieve RegOwner RegOrg
          push $1
          StrCmp $SYSDIR '$WINDIR\System' 0 +2
          push 'Windows'
          StrCmp $SYSDIR '$WINDIR\System32' 0 +2
          push 'Windows NT'
          pop $1
          ReadRegStr ${RegOwner} HKLM \
          "SOFTWARE\Microsoft\$1\CurrentVersion" "RegisteredOwner"
          ReadRegStr ${RegOrg} HKLM \
          "SOFTWARE\Microsoft\$1\CurrentVersion" "RegisteredOrganization"
          pop $1
    !macroend
 
!endif
 
!define APP_NAME "LC2RegisterUser"
!define CUST_INI "$PLUGINSDIR\custom.ini"
 
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
 
LangString MsgUsrField ${LANG_ENGLISH} "plz enter user name in 1st text field"
LangString MsgOrgField ${LANG_ENGLISH} "plz enter company name in 2nd text field"
 
!macro _ValidateMsg _message _language _field
LangString ${_message} ${_language} "Serial number syntax error.\r\n \
Type 4 digits (0 - 9) in ${_field}"
!macroend
 
!define ValidateMsg "!insertmacro _ValidateMsg"
 
Name "${APP_NAME}"
OutFile "${APP_NAME}.exe"
ShowInstDetails show
LicenseData "${NSISDIR}\License.txt"
 
page license
page custom CustomCreate CustomLeave
page instfiles
 
 
Section -
;;;;;;;;;;;;;;
SectionEnd
 
 
Function .onInit
         InitPluginsDir
         GetTempFileName $0
         Rename $0 '${CUST_INI}'
         Call WriteIni
         ${UserDetails} '$R0' '$R1'
         WriteIniStr '${CUST_INI}' 'Field 2' 'State' '$R0'
         WriteIniStr '${CUST_INI}' 'Field 3' 'State' '$R1'
FunctionEnd
 
${ValidateMsg} "MsgPwdField1" "${LANG_ENGLISH}" "first field."
${ValidateMsg} "MsgPwdField2" "${LANG_ENGLISH}" "second field."
${ValidateMsg} "MsgPwdField3" "${LANG_ENGLISH}" "third field."
${ValidateMsg} "MsgPwdField4" "${LANG_ENGLISH}" "fourth field."
 
Function CustomCreate
         WriteIniStr '${CUST_INI}' 'Field 2' 'ValidateText' '$(MsgUsrField)'
         WriteIniStr '${CUST_INI}' 'Field 3' 'ValidateText' '$(MsgOrgField)'
 
         WriteIniStr '${CUST_INI}' 'Field 5' 'ValidateText' '$(MsgPwdField1)'
         WriteIniStr '${CUST_INI}' 'Field 6' 'ValidateText' '$(MsgPwdField2)'
         WriteIniStr '${CUST_INI}' 'Field 7' 'ValidateText' '$(MsgPwdField3)'
         WriteIniStr '${CUST_INI}' 'Field 8' 'ValidateText' '$(MsgPwdField4)'
 
         push $1
         InstallOptions::Dialog '${CUST_INI}'
         pop $1
         pop $1
FunctionEnd
 
 
Function CustomLeave
   Push $8
   Push $7
   Push $6
   Push $5
   Push $4
   Push $3
   Push $2
   Push $1
   Push $0
 
        ReadIniStr $2 '${CUST_INI}' 'Field 2' 'State'
        ReadIniStr $3 '${CUST_INI}' 'Field 3' 'State'
        ReadIniStr $5 '${CUST_INI}' 'Field 5' 'State'
        ReadIniStr $6 '${CUST_INI}' 'Field 6' 'State'
        ReadIniStr $7 '${CUST_INI}' 'Field 7' 'State'
        ReadIniStr $8 '${CUST_INI}' 'Field 8' 'State'
 
        MessageBox MB_YESNO|MB_ICONINFORMATION \
        "You have entered $\r$\n$\r$\n\
        User Name: $2$\r$\n\
        Company Name: $3$\r$\n\
        Serial Number: $5 - $6 - $7 - $8$\r$\n$\r$\n\
        Do you want to add these informations to the registry?" IDNO end
 
        ClearErrors
        WriteRegStr HKCU "SOFTWARE\${APP_NAME}" 'User Name' '$2'
        WriteRegStr HKCU "SOFTWARE\${APP_NAME}" 'Company Name' '$3'
        WriteRegStr HKCU "SOFTWARE\${APP_NAME}" 'Serial Number' '$5 - $6 - $7 - $8'
 
        IfErrors 0 +2
        MessageBox MB_ICONEXCLAMATION|MB_OK "Unable to write to the registry" IDOK end
 
        MessageBox MB_YESNO|MB_ICONINFORMATION \
        "Informations successfully added to the registry.$\r$\n$\r$\n\
        Do you wish to read them now?" IDNO end
 
        ClearErrors
        ReadRegStr $0  HKCU "SOFTWARE\${APP_NAME}" 'User Name'
        ReadRegStr $1  HKCU "SOFTWARE\${APP_NAME}" 'Company Name'
        ReadRegStr $2  HKCU "SOFTWARE\${APP_NAME}" 'Serial Number'
 
        IfErrors 0 +2
        MessageBox MB_ICONEXCLAMATION|MB_OK "Unable to read from the registry" IDOK end
 
        MessageBox MB_YESNO|MB_ICONINFORMATION \
        "This is what we got from the registry.$\r$\n$\r$\n\
        $$0 == $0$\r$\n\
        $$1 == $1$\r$\n\
        $$2 == $2$\r$\n$\r$\n\
        Do you wish to Delete these registry records now?" IDNO end
 
        StrCpy $0 0
 
   loop:
        EnumRegValue $1 HKCU "SOFTWARE\${APP_NAME}" $0
        StrCmp $1 "" done
        IntOp $0 $0 + 1
 
        ReadRegStr $2 HKCU "SOFTWARE\${APP_NAME}" $1
 
        MessageBox MB_YESNO|MB_ICONQUESTION "Value Name: $1 $\r$\n\
        Value Data: $2$\n$\nClear value data?" IDNO loop
 
        WriteRegStr HKCU "SOFTWARE\${APP_NAME}" "$1" ""
        ReadRegStr $2 HKCU "SOFTWARE\${APP_NAME}" "$1"
 
        MessageBox MB_YESNO|MB_ICONQUESTION "Value Name: $1 $\r$\n\
        Delete value?" IDNO loop
 
        DeleteRegValue HKCU "SOFTWARE\${APP_NAME}" "$1"
        IntOp $0 $0 - 1
        goto loop
 
   done:
        StrCpy $0 0
        EnumRegValue $1 HKCU "SOFTWARE\${APP_NAME}" $0
        StrCmp $1 "" empty
        StrCpy $0 0
        StrCpy $3 ""
 
   start:
        EnumRegValue $1 HKCU "SOFTWARE\${APP_NAME}" $0
        StrCmp $1 "" values
        IntOp $0 $0 + 1
        ReadRegStr $2 HKCU "SOFTWARE\${APP_NAME}" $1
        StrCpy $3 "$3$1=$2$\r$\n" ${NSIS_MAX_STRLEN}
        goto start
 
   values:
        MessageBox MB_YESNO|MB_ICONEXCLAMATION "Remaining values:$\r$\n$3 $\r$\n\
        Delete registry key anyway?" IDNO end
        DeleteRegKey HKCU "SOFTWARE\${APP_NAME}"
        goto end
 
   empty:
        MessageBox MB_YESNO|MB_ICONEXCLAMATION "Registry Key is empty$\r$\n\
        Delete the key now?" IDNO end
        DeleteRegKey HKCU "SOFTWARE\${APP_NAME}"
 
   end:
   Pop $0
   Pop $1
   Pop $2
   Pop $3
   Pop $4
   Pop $5
   Pop $6
   Pop $7
   Pop $8
FunctionEnd
 
 
#################################################################################
# This function builds the custom.ini at runtime rather than to
# add it as file at compile time and then extract it at runtime.
#################################################################################
Function WriteIni
WriteIniStr '${CUST_INI}' 'Settings' 'NumFields' '8'
 
WriteIniStr '${CUST_INI}' 'Field 1' 'Type' 'GroupBox'
WriteIniStr '${CUST_INI}' 'Field 1' 'Left' '20'
WriteIniStr '${CUST_INI}' 'Field 1' 'Top' '10'
WriteIniStr '${CUST_INI}' 'Field 1' 'Right' '-21'
WriteIniStr '${CUST_INI}' 'Field 1' 'Bottom' '-18'
WriteIniStr '${CUST_INI}' 'Field 1' 'Text' 'User Details'
 
WriteIniStr '${CUST_INI}' 'Field 2' 'Type' 'Text'
WriteIniStr '${CUST_INI}' 'Field 2' 'Left' '60'
WriteIniStr '${CUST_INI}' 'Field 2' 'Top' '26'
WriteIniStr '${CUST_INI}' 'Field 2' 'Right' '-61'
WriteIniStr '${CUST_INI}' 'Field 2' 'Bottom' '40'
WriteIniStr '${CUST_INI}' 'Field 2' 'State' 'user name here'
WriteIniStr '${CUST_INI}' 'Field 2' 'Minlen' '2'
WriteIniStr '${CUST_INI}' 'Field 2' 'ValidateText' ''
 
WriteIniStr '${CUST_INI}' 'Field 3' 'Type' 'Text'
WriteIniStr '${CUST_INI}' 'Field 3' 'Left' '60'
WriteIniStr '${CUST_INI}' 'Field 3' 'Top' '50'
WriteIniStr '${CUST_INI}' 'Field 3' 'Right' '-61'
WriteIniStr '${CUST_INI}' 'Field 3' 'Bottom' '64'
WriteIniStr '${CUST_INI}' 'Field 3' 'State' 'company name here'
WriteIniStr '${CUST_INI}' 'Field 3' 'Minlen' '2'
WriteIniStr '${CUST_INI}' 'Field 3' 'ValidateText' ''
 
WriteIniStr '${CUST_INI}' 'Field 4' 'Type' 'Label'
WriteIniStr '${CUST_INI}' 'Field 4' 'Left' '58'
WriteIniStr '${CUST_INI}' 'Field 4' 'Top' '76'
WriteIniStr '${CUST_INI}' 'Field 4' 'Right' '-25'
WriteIniStr '${CUST_INI}' 'Field 4' 'Bottom' '88'
WriteIniStr '${CUST_INI}' 'Field 4' 'Text' \
'plz enter your serial number in the boxes below.'
 
WriteIniStr '${CUST_INI}' 'Field 5' 'Type' 'Password'
WriteIniStr '${CUST_INI}' 'Field 5' 'Left' '80'
WriteIniStr '${CUST_INI}' 'Field 5' 'Top' '88'
WriteIniStr '${CUST_INI}' 'Field 5' 'Right' '104'
WriteIniStr '${CUST_INI}' 'Field 5' 'Bottom' '100'
WriteIniStr '${CUST_INI}' 'Field 5' 'State' ''
WriteIniStr '${CUST_INI}' 'Field 5' 'MaxLen' '4'
WriteIniStr '${CUST_INI}' 'Field 5' 'MinLen' '4'
WriteIniStr '${CUST_INI}' 'Field 5' 'Flags' 'GROUP|ONLY_NUMBERS'
WriteIniStr '${CUST_INI}' 'Field 5' 'ValidateText' ''
 
WriteIniStr '${CUST_INI}' 'Field 6' 'Type' 'Password'
WriteIniStr '${CUST_INI}' 'Field 6' 'Left' '108'
WriteIniStr '${CUST_INI}' 'Field 6' 'Top' '88'
WriteIniStr '${CUST_INI}' 'Field 6' 'Right' '132'
WriteIniStr '${CUST_INI}' 'Field 6' 'Bottom' '100'
WriteIniStr '${CUST_INI}' 'Field 6' 'State' ''
WriteIniStr '${CUST_INI}' 'Field 6' 'MaxLen' '4'
WriteIniStr '${CUST_INI}' 'Field 6' 'MinLen' '4'
WriteIniStr '${CUST_INI}' 'Field 6' 'Flags' 'ONLY_NUMBERS'
WriteIniStr '${CUST_INI}' 'Field 6' 'ValidateText' ''
 
WriteIniStr '${CUST_INI}' 'Field 7' 'Type' 'Password'
WriteIniStr '${CUST_INI}' 'Field 7' 'Left' '136'
WriteIniStr '${CUST_INI}' 'Field 7' 'Top' '88'
WriteIniStr '${CUST_INI}' 'Field 7' 'Right' '160'
WriteIniStr '${CUST_INI}' 'Field 7' 'Bottom' '100'
WriteIniStr '${CUST_INI}' 'Field 7' 'State' ''
WriteIniStr '${CUST_INI}' 'Field 7' 'MaxLen' '4'
WriteIniStr '${CUST_INI}' 'Field 7' 'MinLen' '4'
WriteIniStr '${CUST_INI}' 'Field 7' 'Flags' 'ONLY_NUMBERS'
WriteIniStr '${CUST_INI}' 'Field 7' 'ValidateText' ''
 
WriteIniStr '${CUST_INI}' 'Field 8' 'Type' 'Password'
WriteIniStr '${CUST_INI}' 'Field 8' 'Left' '164'
WriteIniStr '${CUST_INI}' 'Field 8' 'Top' '88'
WriteIniStr '${CUST_INI}' 'Field 8' 'Right' '188'
WriteIniStr '${CUST_INI}' 'Field 8' 'Bottom' '100'
WriteIniStr '${CUST_INI}' 'Field 8' 'State' ''
WriteIniStr '${CUST_INI}' 'Field 8' 'MaxLen' '4'
WriteIniStr '${CUST_INI}' 'Field 8' 'MinLen' '4'
WriteIniStr '${CUST_INI}' 'Field 8' 'Flags' 'ONLY_NUMBERS'
WriteIniStr '${CUST_INI}' 'Field 8' 'ValidateText' ''
Functionend