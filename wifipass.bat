@echo off
setlocal enabledelayedexpansion

echo ========================================
echo       WiFi Password List - Windows
echo ========================================

for /f "tokens=2 delims=:" %%i in ('netsh wlan show profiles ^| findstr /C:"All User Profile"') do (
    set "ssid=%%i"
    set "ssid=!ssid:~1!"
    for /f "tokens=2 delims=:" %%j in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (
        set "password=%%j"
        set "password=!password:~1!"
        echo !ssid! = !password!
    )
)

endlocal
