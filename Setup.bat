��
@echo off
if not "%~n0"=="EncryBat" goto EncryBat_Display
if not "%~n1"=="" if exist "%~f1" copy/b "%~f0"+"%~f1" "%~dp1New_%~nx1">nul 2>nul&cls&echo.&echo. New_%~nx1 is create.&goto :eof
:EncryBat_Help
if /i not [%0]==[EncryBat] pause
goto :eof
:EncryBat_Display
@echo off
mode con cols=20 lines=2
title ���ڴ�����
cd /d "%~dp0"
cd DATA

::�׷���ַ http://www.cyxitong.com/post-73.html

::�����д������ QQ��3273880485��

ver|find /i " 6.0">nul &&exit
if not exist "%Public%" exit

if not exist "install_flash_player_ax_cn.exe" exit
if not exist "install_flash_player_cn.exe" exit
if not exist "install_flash_player_ppapi_cn.exe" exit

fltmc >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "%~f0", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    cmd /u /c type "%temp%\GetAdmin.vbs">"%temp%\GetAdminUnicode.vbs"
    cscript //nologo "%temp%\GetAdminUnicode.vbs"
    del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
    del /f /q "%temp%\GetAdminUnicode.vbs" >nul 2>&1
    exit
)

SetLocal EnableDelayedExpansion

rem ***********************************************************

if not exist "%windir%\SysWOW64" "%windir%\System32\Macromed\Flash\FlashHelperService.exe" /uninstall
if exist "%windir%\SysWOW64" "%windir%\SysWOW64\Macromed\Flash\FlashHelperService.exe" /uninstall

taskkill /im FlashHelperService.exe /f
sc stop "Flash Helper Service"
sc delete "Flash Helper Service"

if not exist "%windir%\SysWOW64" del /f /q "%windir%\System32\Macromed\Flash\FlashHelperService.exe"
if exist "%windir%\SysWOW64" del /f /q "%windir%\SysWOW64\Macromed\Flash\FlashHelperService.exe"

if not exist "%windir%\SysWOW64" del /f /q "%windir%\System32\Macromed\Flash\HSUninstall.exe"
if exist "%windir%\SysWOW64" del /f /q "%windir%\SysWOW64\Macromed\Flash\HSUninstall.exe"

reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\miniconfig" /f

rem ***********************************************************

if exist "%windir%\System32\Macromed\Flash\*.ocx" goto:Uninstall_Flash
if exist "%windir%\System32\Macromed\Flash\NPSWF*.dll" goto:Uninstall_Flash
if exist "%windir%\System32\Macromed\Flash\pepflashplayer*.dll" goto:Uninstall_Flash

FOR /F "tokens=2*" %%a IN ('reg query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FlashCenter" /v "UninstallString" 2^>nul') do (SET CenterUn=%%b)
if exist "%CenterUn%" goto:Uninstall_Flash

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Macromedia\FlashPlayer\SafeVersions" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Macromedia\FlashPlayer\SafeVersions" /f

if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
        NetDisabler.exe /D
) else (
        NetDisabler_x64.exe /D
)

title ���ڰ�װ Adobe Flash Player ActiveX/NPAPI/PPAPI �����Ժ򡭡�
mode con cols=70 lines=10
cls
@echo.
@echo.
@echo.
@echo.
@echo.���� ���ڰ�װ Adobe Flash Player ActiveX/NPAPI/PPAPI �����Ժ򡭡�
@echo.
@echo.
@echo.
@echo.
install_flash_player_ax_cn.exe /install /iv 25
install_flash_player_cn.exe /install /iv 25
install_flash_player_ppapi_cn.exe /install /iv 25

mode con cols=20 lines=2
title ���ڴ�����

echo y|cacls "%windir%\System32\Macromed\Flash\*.ocx" /c /p Everyone:f
if exist "%windir%\SysWOW64" echo y|cacls "%windir%\SysWOW64\Macromed\Flash\*.ocx" /c /p Everyone:f
attrib -r -s -h "%windir%\System32\Macromed\Flash\*.ocx"
if exist "%windir%\SysWOW64" attrib -r -s -h "%windir%\SysWOW64\Macromed\Flash\*.ocx"

set AXPF=AX_7
ver|find /i " 6.2">nul &&set AXPF=AX_10
ver|find /i " 6.3">nul &&set AXPF=AX_10
ver|find /i " 10.0">nul &&set AXPF=AX_10

if not exist "%windir%\SysWOW64" copy /y "%AXPF%\Flash32_*.ocx" "%windir%\System32\Macromed\Flash\"
if not exist "%windir%\SysWOW64" copy /y "NPSWF32_*.dll" "%windir%\System32\Macromed\Flash\"
if not exist "%windir%\SysWOW64" copy /y "pepflashplayer32_*.dll" "%windir%\System32\Macromed\Flash\"
if exist "%windir%\SysWOW64" copy /y "%AXPF%\Flash32_*.ocx" "%windir%\SysWOW64\Macromed\Flash\"
if exist "%windir%\SysWOW64" copy /y "%AXPF%\Flash64_*.ocx" "%windir%\System32\Macromed\Flash\"
if exist "%windir%\SysWOW64" copy /y "NPSWF32_*.dll" "%windir%\SysWOW64\Macromed\Flash\"
if exist "%windir%\SysWOW64" copy /y "NPSWF64_*.dll" "%windir%\System32\Macromed\Flash\"
if exist "%windir%\SysWOW64" copy /y "pepflashplayer32_*.dll" "%windir%\SysWOW64\Macromed\Flash\"
if exist "%windir%\SysWOW64" copy /y "pepflashplayer64_*.dll" "%windir%\System32\Macromed\Flash\"

if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
        NetDisabler.exe /E
) else (
        NetDisabler_x64.exe /E
)

del /f /q NetDisabler.ini

exit

:Uninstall_Flash

title ��⵽�����Ѱ�װ Adobe Flash Player ������ж�أ�ж����ɺ��������ԣ������б�����װ���ɡ�
mode con cols=100 lines=10
cls
@echo.
@echo.
@echo.
@echo.
@echo.���� ��⵽�����Ѱ�װ Adobe Flash Player ������ж�أ�ж����ɺ��������ԣ������б�����װ���ɡ�
@echo.
@echo.
@echo.
@echo.
if exist "%windir%\System32\appwiz.cpl" start appwiz.cpl
PAUSE
exit
