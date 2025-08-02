@echo off
setlocal enabledelayedexpansion

:: Determine max SSID length
set maxlen=0
for /f "tokens=2 delims=:" %%i in ('netsh wlan show profiles ^| findstr /C:"All User Profile"') do (
    set "ssid=%%i"
    set "ssid=!ssid:~1!"
    call :strlen "!ssid!" len
    if !len! gtr !maxlen! set maxlen=!len!
)

:: Print header
echo ============================================
echo       WiFi Password List - Windows 11
echo ============================================

:: Print aligned column header
call :pad "SSID" !maxlen! paddedHeader
echo !paddedHeader! = Password
call :dashline !maxlen!

:: Print each SSID with aligned password
for /f "tokens=2 delims=:" %%i in ('netsh wlan show profiles ^| findstr /C:"All User Profile"') do (
    set "ssid=%%i"
    set "ssid=!ssid:~1!"
    call :pad "!ssid!" !maxlen! padded
    set "password="
    for /f "tokens=2 delims=:" %%j in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (
        set "password=%%j"
        set "password=!password:~1!"
    )
    if defined password echo !padded! = !password!
)

endlocal
goto :eof

:: Calculates string length
:strlen
setlocal enabledelayedexpansion
set "str=%~1"
set /a len=0
:strlen_loop
if defined str (
    set "str=!str:~1!"
    set /a len+=1
    goto strlen_loop
)
endlocal & set "%~2=%len%"
goto :eof

:: Pads string with spaces to match max length
:pad
setlocal enabledelayedexpansion
set "str=%~1"
set /a padlen=%2
call :strlen "%~1" currlen
set /a spaces = padlen - currlen
set "outstr=%~1"
:pad_space
if !spaces! GTR 0 (
    set "outstr=!outstr! "
    set /a spaces-=1
    goto pad_space
)
endlocal & set "%~3=%outstr%"
goto :eof

:: Prints a dash line for header separator
:dashline
setlocal
set /a totalWidth = %1 + 11
set "line="
for /l %%i in (1,1,%totalWidth%) do set "line=!line!-"
echo !line!
endlocal
goto :eof
