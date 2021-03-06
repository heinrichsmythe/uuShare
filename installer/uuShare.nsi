﻿# _____________________________________________________________________________
; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "uuShare"
!define PRODUCT_VERSION "1.6.4"
!define PRODUCT_PUBLISHER "XUULM"
!define PRODUCT_WEB_SITE "http://share.xuulm.com/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_NAME}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_STARTUP_REGKEY "Software\Microsoft\Windows\CurrentVersion\Run"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTUP_APP "Launcher.exe"
!define PRODUCT_MAIN_APP "ApexDC.exe"
!define PRODUCT_MAIN_APP_X64 "ApexDC-x64.exe"

!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "header.bmp"
!define MUI_HEADERIMAGE_RIGHT
BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION}"

; MUI 1.67 compatible ------
!include "MUI.nsh"
;!include "UAC.nsh"
!include "x64.nsh"
!include "WinVer.nsh"
!include "FileFunc.nsh"
!include "WinMessages.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "u-share.ico"
!define MUI_UNICON "u-share.ico"
!define APPLICATION_ICON "u-share.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "license.txt"
; Directory page
!define MUI_PAGE_CUSTOMFUNCTION_PRE skipChoseDirectory
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION PageFinishRun
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "SimpChinese"
LangString APPNAME ${LANG_ENGLISH}     "uuShare"
LangString APPNAME ${LANG_SIMPCHINESE} "呦呦共享"
LangString UninstAsk  ${LANG_ENGLISH}     "Are you sure you want to completely remove $(APPNAME) and all of its components?"
LangString UninstAsk  ${LANG_SIMPCHINESE} "您确实要完全卸载 $(APPNAME)，及其所有的组件？"
LangString UninstDone ${LANG_ENGLISH}     "$(APPNAME) was successfully removed from your computer!"
LangString UninstDone ${LANG_SIMPCHINESE} "$(APPNAME) 已成功地从您的计算机卸载。"
LangString StillRunning ${LANG_ENGLISH}     "$(APPNAME) is still running, close it before continue."
LangString StillRunning ${LANG_SIMPCHINESE} "$(APPNAME) 仍在运行，请先关闭程序。"
LangString ShortCutUninstall ${LANG_ENGLISH}     "Uninstall $(APPNAME).lnk"
LangString ShortCutUninstall ${LANG_SIMPCHINESE} "卸载 $(APPNAME).lnk"
LangString ShortCutLaunchServer ${LANG_ENGLISH}     "Launch $(APPNAME) Server.lnk"
LangString ShortCutLaunchServer ${LANG_SIMPCHINESE} "启动 $(APPNAME) 服务.lnk"
LangString STRING_INSTALL_SAME_VERSION ${LANG_ENGLISH}     "$(APPNAME) $PREVIOUS_VERSION has been installed! $\nDo you want to reinstall $(APPNAME) $PREVIOUS_VERSION ?"
LangString STRING_INSTALL_SAME_VERSION ${LANG_SIMPCHINESE} "$(APPNAME) $PREVIOUS_VERSION 已安装! $\n您确定要重新安装 $(APPNAME) $PREVIOUS_VERSION 吗?"
LangString STRING_INSTALL_HIGHER_VERSION ${LANG_ENGLISH}     "$(APPNAME) $PREVIOUS_VERSION has been installed! $\nDo you want to update the $(APPNAME) to ${PRODUCT_VERSION} ?"
LangString STRING_INSTALL_HIGHER_VERSION ${LANG_SIMPCHINESE} "侦测到 $(APPNAME) $PREVIOUS_VERSION 已安装! $\n您确定要更新版本至 ${PRODUCT_VERSION} 吗?"
LangString STRING_INSTALL_LOWER_VERSION ${LANG_ENGLISH}     "A higher version - $PREVIOUS_VERSION of the $(APPNAME) is already installed on this system."
LangString STRING_INSTALL_LOWER_VERSION ${LANG_SIMPCHINESE} "侦测到系统已安装更新的版本 - $PREVIOUS_VERSION !"
LangString STRING_UNINSTALL_OLD_VERSION ${LANG_ENGLISH}     "A previous version of $OLD_VERSION was found. It is recommended that you uninstall it first.$\n$\n\Do you want to do that now?"
LangString STRING_UNINSTALL_OLD_VERSION ${LANG_SIMPCHINESE} "侦测到$OLD_VERSION 版本已安装! 强烈建议先移除旧版本，再安装新版本。 $\n$\n您确定要移除旧版本吗?"
; MUI end ------

Function openLinkNewWindow
  Push $3
  Exch
  Push $2
  Exch
  Push $1
  Exch
  Push $0
  Exch

  ReadRegStr $0 HKCR "http\shell\open\command" ""
# Get browser path
    DetailPrint $0
  StrCpy $2 '"'
  StrCpy $1 $0 1
  StrCmp $1 $2 +2 # if path is not enclosed in " look for space as final char
    StrCpy $2 ' '
  StrCpy $3 1
  loop:
    StrCpy $1 $0 1 $3
    DetailPrint $1
    StrCmp $1 $2 found
    StrCmp $1 "" found
    IntOp $3 $3 + 1
    Goto loop

  found:
    StrCpy $1 $0 $3
    StrCmp $2 " " +2
      StrCpy $1 '$1"'

  Pop $0
  Exec '$1 $0'
  Pop $0
  Pop $1
  Pop $2
  Pop $3
FunctionEnd

!macro _OpenURL URL
Push "${URL}"
Call openLinkNewWindow
!macroend

!define OpenURL '!insertmacro "_OpenURL"'

; Function WriteToFile ------
Function WriteToFile
Exch $0 ;file to write to
Exch
Exch $1 ;text to write

  FileOpen $0 $0 a #open file
  FileSeek $0 0 END #go to end
  FileWrite $0 $1 #write to file
  FileClose $0

Pop $1
Pop $0
FunctionEnd

!macro WriteToFile NewLine File String
  !if `${NewLine}` == true
  Push `${String}$\r$\n`
  !else
  Push `${String}`
  !endif
  Push `${File}`
  Call WriteToFile
!macroend
!define WriteToFile `!insertmacro WriteToFile false`
!define WriteLineToFile `!insertmacro WriteToFile true`

; Function WriteToFile end ------
Function VersionCompare
  !define VersionCompare `!insertmacro VersionCompareCall`

  !macro VersionCompareCall _VER1 _VER2 _RESULT
    Push `${_VER1}`
    Push `${_VER2}`
    Call VersionCompare
    Pop ${_RESULT}
  !macroend

  Exch $1
  Exch
  Exch $0
  Exch
  Push $2
  Push $3
  Push $4
  Push $5
  Push $6
  Push $7

  begin:
  StrCpy $2 -1
  IntOp $2 $2 + 1
  StrCpy $3 $0 1 $2
  StrCmp $3 '' +2
  StrCmp $3 '.' 0 -3
  StrCpy $4 $0 $2
  IntOp $2 $2 + 1
  StrCpy $0 $0 '' $2

  StrCpy $2 -1
  IntOp $2 $2 + 1
  StrCpy $3 $1 1 $2
  StrCmp $3 '' +2
  StrCmp $3 '.' 0 -3
  StrCpy $5 $1 $2
  IntOp $2 $2 + 1
  StrCpy $1 $1 '' $2

  StrCmp $4$5 '' equal

  StrCpy $6 -1
  IntOp $6 $6 + 1
  StrCpy $3 $4 1 $6
  StrCmp $3 '0' -2
  StrCmp $3 '' 0 +2
  StrCpy $4 0

  StrCpy $7 -1
  IntOp $7 $7 + 1
  StrCpy $3 $5 1 $7
  StrCmp $3 '0' -2
  StrCmp $3 '' 0 +2
  StrCpy $5 0

  StrCmp $4 0 0 +2
  StrCmp $5 0 begin newer2
  StrCmp $5 0 newer1
  IntCmp $6 $7 0 newer1 newer2

  StrCpy $4 '1$4'
  StrCpy $5 '1$5'
  IntCmp $4 $5 begin newer2 newer1

  equal:
  StrCpy $0 0
  goto end
  newer1:
  StrCpy $0 1
  goto end
  newer2:
  StrCpy $0 2

  end:
  Pop $7
  Pop $6
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Exch $0
FunctionEnd

Var PREVIOUS_INSTALLDIR
Var PREVIOUS_INSTALLDIR_DIR
Var PREVIOUS_VERSION
Var VERSION_COMP_RESULT ; 0-Versions are equal; 1-Update ;2-Old ;3-New Install
Var OLD_VERSION

Function skipChoseDirectory

${If} $VERSION_COMP_RESULT == 1
Abort ; dont allow to change directory install
${EndIf}
${If} $VERSION_COMP_RESULT == 0
Abort ; dont allow to change directory install
${EndIf}
FunctionEnd

Function CheckPrevInstallDirExists

  ${If} $PREVIOUS_INSTALLDIR != ""

    ; Make sure directory is valid
    Push $R0
    Push $R1
    StrCpy $R0 "$PREVIOUS_INSTALLDIR" "" -1
    ${If} $R0 == '\'
    ${OrIf} $R0 == '/'
      StrCpy $R0 $PREVIOUS_INSTALLDIR*.*
    ${Else}
      StrCpy $R0 $PREVIOUS_INSTALLDIR\*.*
    ${EndIf}
    ${IfNot} ${FileExists} $R0
      StrCpy $PREVIOUS_INSTALLDIR ""
    ${EndIf}
    Pop $R1
    Pop $R0

  ${EndIf}

FunctionEnd

Function ReadPreviousVersion

  ReadRegStr $PREVIOUS_INSTALLDIR HKLM "${PRODUCT_DIR_REGKEY}" ""

  Call CheckPrevInstallDirExists

  ${If} $PREVIOUS_INSTALLDIR == ""
    ;Detect version
    ReadRegStr $PREVIOUS_VERSION HKLM "${PRODUCT_DIR_REGKEY}" "Version"
    ${If} $PREVIOUS_VERSION == ""
    StrCpy $VERSION_COMP_RESULT 3
      return
    ${EndIf}
  ${VersionCompare} "${PRODUCT_VERSION}" "$PREVIOUS_VERSION" $VERSION_COMP_RESULT
  ${EndIf}

FunctionEnd

Function UninstallMSI
  ; $R0 should contain the GUID of the application
  push $R1
  ReadRegStr $R1 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\$R0" "UninstallString"
  StrCmp $R1 "" UninstallMSI_nomsi
    MessageBox MB_YESNOCANCEL|MB_ICONQUESTION  "$(STRING_UNINSTALL_OLD_VERSION)" IDNO UninstallMSI_nomsi IDYES UninstallMSI_yesmsi
      Abort
UninstallMSI_yesmsi:
    ExecWait '"msiexec.exe" /x $R0'
    ;MessageBox MB_OK|MB_ICONINFORMATION "$(UninstAsk)"
UninstallMSI_nomsi:
  pop $R1
  Quit
FunctionEnd

Name "$(APPNAME)"
OutFile "output\${PRODUCT_NAME}_${PRODUCT_VERSION}.exe"
InstallDir "$APPDATA\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
RequestExecutionLevel admin

Function .onInit
  FindProcDLL::KillProc "$INSTDIR\${PRODUCT_MAIN_APP}"

  Call ReadPreviousVersion
    ${If} $VERSION_COMP_RESULT == 3
    ;MessageBox MB_ICONINFORMATION|MB_OK "${PRODUCT_NAME} ${PRODUCT_VERSION} installing.."
    Goto contInst
  ${EndIf}
  ${If} $VERSION_COMP_RESULT == 0
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(STRING_INSTALL_SAME_VERSION)" IDYES +2
    Quit
    Goto contUpdate
  ${EndIf}
  ${If} $VERSION_COMP_RESULT == 1
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(STRING_INSTALL_HIGHER_VERSION)" IDYES +2
    Quit
    Goto contUpdate
  ${EndIf}
  ${If} $VERSION_COMP_RESULT == 2
    MessageBox MB_ICONINFORMATION|MB_OK "$(STRING_INSTALL_LOWER_VERSION)"
    Quit
  ${EndIf}
  Goto contInst
;  !insertmacro MUI_LANGDLL_DISPLAY
;Run the uninstaller
uninst:
  ClearErrors
  ReadRegStr $R0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
  StrCmp $R0 "" done
  ;Exec '$R0 _?=$INSTDIR' ;Do not copy the uninstaller to a temp file
  Exec '$R0'
  Quit
  IfErrors no_remove_uninstaller done
    ;You can either use Delete /REBOOTOK in the uninstaller or add some code
    ;here to remove the uninstaller. Use a registry key to check
    ;whether the user has chosen to uninstall. If you are using an uninstaller
    ;components page, make sure all sections are uninstalled.
  no_remove_uninstaller:
  Return
instAfterUninst:
  ClearErrors
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(UninstAsk)" IDYES +2
  Abort
  ReadRegStr $R0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
  StrCmp $R0 "" done
  ReadRegStr $INSTDIR HKLM "${PRODUCT_DIR_REGKEY}" "INSTDIR"
  ExecWait '"$R0" -SLIENT="SLIENTOK" _?=$INSTDIR' ;Do not copy the uninstaller to a temp file

  IfErrors ano_remove_uninstaller contInst
    ;You can either use Delete /REBOOTOK in the uninstaller or add some code
    ;here to remove the uninstaller. Use a registry key to check
    ;whether the user has chosen to uninstall. If you are using an uninstaller
    ;components page, make sure all sections are uninstalled.
  ano_remove_uninstaller:
  Return
done:
  Quit
contInst:
  Return
contUpdate:
  ReadRegStr $PREVIOUS_INSTALLDIR_DIR HKLM "${PRODUCT_DIR_REGKEY}" "INSTDIR"
  StrCpy $INSTDIR $PREVIOUS_INSTALLDIR_DIR

  SetOutPath "$PREVIOUS_INSTALLDIR_DIR"
  DetailPrint "Exec $PREVIOUS_INSTALLDIR_DIR\prepare_update.bat"
  ;nsExec::Exec "$PREVIOUS_INSTALLDIR_DIR\prepare_update.bat"
  Sleep 2000
  Return
FunctionEnd

Section "Section01" SEC01
  CreateDirectory "$SMPROGRAMS\$(APPNAME)"
  SetOutPath $INSTDIR
  SetOverwrite on
  File "u-share.ico"
  CreateShortCut "$SMPROGRAMS\$(APPNAME)\$(ShortCutUninstall)"  "$INSTDIR\uninst2.exe" "" "$INSTDIR\${APPLICATION_ICON}" 0
SectionEnd

Section "ExecFileSection" SEC02
  SetOutPath $INSTDIR
  SetOverwrite on

  ${If} ${AtLeastWinVista}
    File /nonfatal "..\compiled\${PRODUCT_STARTUP_APP}"
    ${If} ${RunningX64}
        File /nonfatal /oname=${PRODUCT_MAIN_APP} "..\compiled\${PRODUCT_MAIN_APP_X64}"
    ${Else}
        File /nonfatal "..\compiled\${PRODUCT_MAIN_APP}"
    ${EndIf}
  ${Else}
    File /nonfatal "..\compiled\XP\${PRODUCT_STARTUP_APP}"
    File /nonfatal "..\compiled\XP\${PRODUCT_MAIN_APP}"
  ${EndIf}
SectionEnd

Section "DirSection" SEC03
  SetOutPath $INSTDIR
  SetOverwrite on
  File /nonfatal /r "DIR_TO_INSTALL\*.*"
SectionEnd

Section "ZipSection" SEC04
  File /oname=$TEMP\EmoPacks.zip "EmoPacks.zip"
  ZipDLL::extractall "$TEMP\EmoPacks.zip" "$INSTDIR\EmoPacks"
SectionEnd

Section -AdditionalGrant
  ;AccessControl::GrantOnFile "$INSTDIR\resource" "(S-1-1-0)" "FullAccess"
  ;AccessControl::GrantOnFile "$INSTDIR\resource" "(S-1-5-32-545)" "FullAccess"

  WriteRegStr HKCR "uushare" "" "URL:uuShare DC Launcher"
  WriteRegStr HKCR "uushare" "URL Protocol" ""
  WriteRegStr HKCR "uushare\DefaultIcon" "" "$INSTDIR\u-share.ico"
  WriteRegStr HKCR "uushare\shell\open\command" "" '$INSTDIR\${PRODUCT_STARTUP_APP} "%1"'
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\$(APPNAME).url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\$(APPNAME)\$(APPNAME).lnk" "$INSTDIR\$(APPNAME).url" "" "$INSTDIR\${APPLICATION_ICON}" 0
  CreateShortCut "$DESKTOP\$(APPNAME).lnk" "$INSTDIR\$(APPNAME).url" "" "$INSTDIR\${APPLICATION_ICON}" 0
SectionEnd

Section -Post
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_DIR_REGKEY}" "INSTDIR" $INSTDIR
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_DIR_REGKEY}" "Version" "${PRODUCT_VERSION}"

  SetOutPath $INSTDIR
  WriteUninstaller "$INSTDIR\uninst.exe"
  Sleep 2000

  SetOutPath "$INSTDIR"
  ;WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_STARTUP_REGKEY}" "${PRODUCT_NAME}" "$INSTDIR\startup.lnk"

  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${PRODUCT_STARTUP_APP}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(APPNAME)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${PRODUCT_STARTUP_APP}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "NoModify" 1
  WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "NoRepair" 1

  Sleep 1000
  SetOutPath "$INSTDIR"
  SetOverwrite on
  Delete "$INSTDIR\InstallerVersion.txt"
  Delete "$INSTDIR\InstallerDir.txt"
  ${WriteToFile} "$INSTDIR\InstallerVersion.txt" "${PRODUCT_VERSION}"
  ${WriteToFile} "$INSTDIR\InstallerDir.txt" "$INSTDIR\"

  ; Add ApexDC.exe to the authorized list
  liteFirewall::AddRule "$INSTDIR\${PRODUCT_MAIN_APP}" "$(APPNAME)"

  SetOutPath '$INSTDIR'
  ;${If} $VERSION_COMP_RESULT != 1
  DetailPrint "Exec $INSTDIR\postinstall.bat"
  ;nsExec::Exec '$INSTDIR\postinstall.bat'
  ;${EndIf}
  Sleep 1000
  SetOutPath $INSTDIR
  WriteUninstaller "$INSTDIR\uninst2.exe"
  CreateShortCut "$SMPROGRAMS\$(APPNAME)\$(ShortCutUninstall)" "$INSTDIR\uninst2.exe" "" "$INSTDIR\${APPLICATION_ICON}" 0
  ;${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  ;IntFmt $0 "0x%08X" $0
  ;WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "EstimatedSize" "$0"
SectionEnd

Function PageFinishRun
; You would run "$InstDir\MyApp.exe" here but this example has no application to execute...
;!insertmacro UAC_AsUser_ExecShell "" "$INSTDIR\${PRODUCT_STARTUP_APP}" "" "" ""
${OpenURL} "${PRODUCT_WEB_SITE}"
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(UninstDone)"
FunctionEnd

Function un.onInit

  ${GetParameters} $R0
  ${GetOptions} '$R0' "-SLIENT=" $R1
  ;MessageBox MB_ICONINFORMATION|MB_OK "$R0"
  ;MessageBox MB_ICONINFORMATION|MB_OK "$R1"
  StrCmp $R1 "SLIENTOK" 0 AskUserUnistall
  Return
AskUserUnistall:
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(UninstAsk)" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  FindProcDLL::KillProc "$INSTDIR\${PRODUCT_MAIN_APP}"

  liteFirewall::RemoveRule "$INSTDIR\${PRODUCT_MAIN_APP}" "$(APPNAME)"

  Delete "$SMPROGRAMS\$(APPNAME)\$(ShortCutUninstall)"
  Delete "$SMPROGRAMS\$(APPNAME)\$(APPNAME).lnk"
  Delete "$DESKTOP\$(APPNAME).lnk"
  ;Delete "$SMSTARTUP\Launch ${PRODUCT_NAME} Server.lnk"
  RMDir /r "$SMPROGRAMS\$(APPNAME)"
  SetOutPath "$INSTDIR"
  Delete "$INSTDIR\uninst.exe"
  Sleep 2000
  RMDir /r "$INSTDIR"
  DeleteRegValue ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_STARTUP_REGKEY}" "${PRODUCT_NAME}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegKey /ifempty HKLM "${PRODUCT_DIR_REGKEY}"

  DeleteRegKey HKCR "uushare"
  DeleteRegKey /ifempty HKCR "uushare"

  SetAutoClose true
SectionEnd
