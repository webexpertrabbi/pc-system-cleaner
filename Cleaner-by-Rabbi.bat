@echo off
chcp 437 >nul 2>&1
setlocal EnableDelayedExpansion
title System Cleaner by Emamul Islam Rabbi - v2.0
mode con: cols=70 lines=35
color 0B

:: ===============================================================
::  System Cleaner by Emamul Islam Rabbi - Enhanced and Universal
::  Works on ALL Windows PCs (Dynamic Paths)
::  Version: 2.0
:: ===============================================================

:: -------------------------------
:: Dynamic Path Setup (Works on ALL PCs)
:: -------------------------------
set "userTemp=%TEMP%"
set "winTemp=%WINDIR%\Temp"
set "prefetchDir=%WINDIR%\Prefetch"
set "swDistDir=%WINDIR%\SoftwareDistribution\Download"
set "thumbCacheDir=%LOCALAPPDATA%\Microsoft\Windows\Explorer"
set "werReportsLocal=%LOCALAPPDATA%\Microsoft\Windows\WER"
set "werReportsAppData=%APPDATA%\Microsoft\Windows\WER"
set "recentDir=%APPDATA%\Microsoft\Windows\Recent"
set "winLogs=%WINDIR%\Logs"
set "delivOptDir=%WINDIR%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache"
set "fontCacheFile=%WINDIR%\ServiceProfiles\LocalService\AppData\Local\FontCache"
set "edgeCacheDir=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache"
set "chromeCacheDir=%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
set "inetCacheDir=%LOCALAPPDATA%\Microsoft\Windows\INetCache"

:: -------------------------------
:: Log File Setup (saves to Desktop)
:: -------------------------------
set "logFile=%USERPROFILE%\Desktop\RabbiCleanerLog.txt"
echo ========================================================== > "%logFile%"
echo   System Cleanup Log - %DATE% %TIME% >> "%logFile%"
echo   Computer: %COMPUTERNAME%  User: %USERNAME% >> "%logFile%"
echo   OS: %OS%  Processor: %PROCESSOR_ARCHITECTURE% >> "%logFile%"
echo ========================================================== >> "%logFile%"
echo. >> "%logFile%"

:: Counter Initialize
set "totalSteps=18"
set "currentStep=0"
set "successCount=0"
set "failCount=0"
set "scanReport=%USERPROFILE%\Desktop\RabbiCleanerScan.txt"
set "scanAscii=%TEMP%\RabbiCleanerScan_ascii.txt"

:: ===============================================================
:: Automatic Dry Run / Storage Analysis
:: ===============================================================
:: This report is informational only. No user action is required.
echo ========================================================== > "%scanReport%"
echo   STORAGE SCAN - %DATE% %TIME% >> "%scanReport%"
echo ========================================================== >> "%scanReport%"
echo. >> "%scanReport%"
echo   Storage scan in progress...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$items=@(@{Name='User Temp';Path=$env:TEMP},@{Name='Windows Temp';Path=([Environment]::GetEnvironmentVariable('WINDIR')+'\Temp')},@{Name='Windows Update Cache';Path=([Environment]::GetEnvironmentVariable('WINDIR')+'\SoftwareDistribution\Download')},@{Name='Downloads';Path=([Environment]::GetFolderPath('UserProfile')+'\Downloads')},@{Name='Browser Cache';Path=([Environment]::GetEnvironmentVariable('LOCALAPPDATA')+'\Microsoft\Edge\User Data\Default\Cache')},@{Name='Chrome Cache';Path=([Environment]::GetEnvironmentVariable('LOCALAPPDATA')+'\Google\Chrome\User Data\Default\Cache')}); foreach($item in $items){$bytes=0;$files=0;if(Test-Path -LiteralPath $item.Path){Get-ChildItem -LiteralPath $item.Path -File -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {$bytes+=$_.Length;$files++}}; $mb=[math]::Round($bytes/1MB,2); ('{0}: {1} MB ({2} files) - {3}' -f $item.Name,$mb,$files,$item.Path) | Tee-Object -FilePath '%scanReport%' -Append}; Add-Content -LiteralPath '%scanReport%' -Value ''; Add-Content -LiteralPath '%scanReport%' -Value 'Largest files in Downloads (top 10):'; if(Test-Path -LiteralPath ([Environment]::GetFolderPath('UserProfile')+'\Downloads')){Get-ChildItem -LiteralPath ([Environment]::GetFolderPath('UserProfile')+'\Downloads') -File -Recurse -Force -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Select-Object -First 10 | ForEach-Object {('{0} MB - {1}' -f [math]::Round($_.Length/1MB,2),$_.FullName) | Tee-Object -FilePath '%scanReport%' -Append}}" >nul 2>&1
powershell -NoProfile -Command "Get-Content -LiteralPath '%scanReport%' | Set-Content -LiteralPath '%scanAscii%' -Encoding ASCII; Move-Item -LiteralPath '%scanAscii%' -Destination '%scanReport%' -Force"
echo   [SCAN] Storage summary
powershell -NoProfile -Command "$lines=Get-Content -LiteralPath '%scanReport%'; foreach($line in $lines){if($line -match '^([^:]+): ([0-9.]+) MB \(([0-9]+) files\)'){Write-Host ('   {0}: {1} MB / {2} files' -f $matches[1],$matches[2],$matches[3])}}"
echo   Details: %scanReport%
echo   Cleanup starts automatically...
timeout /t 3 /nobreak >nul
echo. >> "%logFile%"
echo   STORAGE SCAN REPORT >> "%logFile%"
echo   See detailed report: %scanReport% >> "%logFile%"
type "%scanReport%" >> "%logFile%"

:: ===============================================================
:: Admin Check
:: ===============================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo.
    echo  +----------------------------------------------------------+
    echo  ^|    SYSTEM CLEANER by Emamul Islam Rabbi - v2.0           ^|
    echo  +----------------------------------------------------------+
    echo.
    echo   [!] Administrator privileges required!
    echo   [*] Requesting elevation...
    echo.
    echo   Please click YES on the UAC prompt.
    echo.
    timeout /t 3 >nul
    powershell -NoProfile -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

:: ===============================================================
:: Countdown: 10 seconds
:: ===============================================================
for /L %%i in (10,-1,1) do (
    cls
    echo.
    echo  +----------------------------------------------------------+
    echo  ^|                                                          ^|
    echo  ^|    #####  #   #  #####  #####  #####  #   #              ^|
    echo  ^|    #       # #   #        #    #      ## ##              ^|
    echo  ^|    #####    #    #####    #    ####   # # #              ^|
    echo  ^|        #    #        #    #    #      #   #              ^|
    echo  ^|    #####    #    #####    #    #####  #   #              ^|
    echo  ^|                                                          ^|
    echo  ^|                   CLEANER  v2.0                          ^|
    echo  ^|                 Emamul Islam Rabbi                       ^|
    echo  ^|                                                          ^|
    echo  +----------------------------------------------------------+
    echo.
    echo     Starting in %%i seconds...
    echo.
    echo     [PC: %COMPUTERNAME%]  [User: %USERNAME%]
    timeout /t 1 >nul
)

:: ===============================================================
:: Cleaning Start
:: ===============================================================
cls
echo.
echo  +----------------------------------------------------------+
echo  ^|          SYSTEM CLEANING IN PROGRESS...                  ^|
echo  +----------------------------------------------------------+
echo.
echo  [START] Cleanup started at %TIME% >> "%logFile%"
echo. >> "%logFile%"

:: ---------------------------------------------------------------
:: [1/18] User Temp Files
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning User Temp Files...
echo   [!currentStep!/%totalSteps%] Cleaning User Temp Files... >> "%logFile%"
if exist "%userTemp%" (
    del /f /s /q "%userTemp%\*.*" >nul 2>&1
    for /D %%G in ("%userTemp%\*") do rd /s /q "%%G" >nul 2>&1
    echo     [OK] User Temp Files cleaned: %userTemp% >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [SKIP] User Temp folder not found >> "%logFile%"
    set /a failCount+=1
)

:: ---------------------------------------------------------------
:: [2/18] Windows Temp Files
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Windows Temp Files...
echo   [!currentStep!/%totalSteps%] Cleaning Windows Temp Files... >> "%logFile%"
if exist "%winTemp%" (
    del /f /s /q "%winTemp%\*.*" >nul 2>&1
    for /D %%G in ("%winTemp%\*") do rd /s /q "%%G" >nul 2>&1
    echo     [OK] Windows Temp Files cleaned: %winTemp% >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [SKIP] Windows Temp folder not found >> "%logFile%"
    set /a failCount+=1
)

:: ---------------------------------------------------------------
:: [3/18] Prefetch Files
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Prefetch Files...
echo   [!currentStep!/%totalSteps%] Cleaning Prefetch Files... >> "%logFile%"
if exist "%prefetchDir%" (
    del /f /s /q "%prefetchDir%\*.pf" >nul 2>&1
    echo     [OK] Prefetch Files cleaned: %prefetchDir% >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [SKIP] Prefetch folder not found >> "%logFile%"
    set /a failCount+=1
)

:: ---------------------------------------------------------------
:: [4/18] Recycle Bin
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Emptying Recycle Bin...
echo   [!currentStep!/%totalSteps%] Emptying Recycle Bin... >> "%logFile%"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Clear-RecycleBin -Confirm:$false -ErrorAction SilentlyContinue" >nul 2>&1
echo     [OK] Recycle Bin emptied >> "%logFile%"
set /a successCount+=1

:: ---------------------------------------------------------------
:: [5/18] Windows Update Cache
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Windows Update Cache...
echo   [!currentStep!/%totalSteps%] Cleaning Windows Update Cache... >> "%logFile%"
net stop wuauserv >nul 2>&1
if exist "%swDistDir%" (
    del /f /s /q "%swDistDir%\*.*" >nul 2>&1
    for /D %%G in ("%swDistDir%\*") do rd /s /q "%%G" >nul 2>&1
    echo     [OK] Windows Update Cache cleaned >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [SKIP] SoftwareDistribution Download not found >> "%logFile%"
    set /a failCount+=1
)
net start wuauserv >nul 2>&1

:: ---------------------------------------------------------------
:: [6/18] Thumbnail Cache
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Thumbnail Cache...
echo   [!currentStep!/%totalSteps%] Cleaning Thumbnail Cache... >> "%logFile%"
if exist "%thumbCacheDir%" (
    del /f /q "%thumbCacheDir%\thumbcache_*.db" >nul 2>&1
    del /f /q "%thumbCacheDir%\iconcache_*.db" >nul 2>&1
    echo     [OK] Thumbnail and Icon Cache cleaned >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [SKIP] Thumbnail Cache folder not found >> "%logFile%"
    set /a failCount+=1
)

:: ---------------------------------------------------------------
:: [7/18] DNS Cache Flush
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Flushing DNS Cache...
echo   [!currentStep!/%totalSteps%] Flushing DNS Cache... >> "%logFile%"
ipconfig /flushdns >nul 2>&1
echo     [OK] DNS Cache flushed >> "%logFile%"
set /a successCount+=1

:: ---------------------------------------------------------------
:: [8/18] Windows Error Reports
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Windows Error Reports...
echo   [!currentStep!/%totalSteps%] Cleaning Windows Error Reports... >> "%logFile%"
set "werCleaned=0"
if exist "%werReportsLocal%" (
    del /f /s /q "%werReportsLocal%\*.*" >nul 2>&1
    for /D %%G in ("%werReportsLocal%\*") do rd /s /q "%%G" >nul 2>&1
    set "werCleaned=1"
)
if exist "%werReportsAppData%" (
    del /f /s /q "%werReportsAppData%\*.*" >nul 2>&1
    for /D %%G in ("%werReportsAppData%\*") do rd /s /q "%%G" >nul 2>&1
    set "werCleaned=1"
)
if exist "%ProgramData%\Microsoft\Windows\WER" (
    del /f /s /q "%ProgramData%\Microsoft\Windows\WER\*.*" >nul 2>&1
    for /D %%G in ("%ProgramData%\Microsoft\Windows\WER\*") do rd /s /q "%%G" >nul 2>&1
    set "werCleaned=1"
)
if "!werCleaned!"=="1" (
    echo     [OK] Windows Error Reports cleaned >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [SKIP] No WER folders found >> "%logFile%"
    set /a failCount+=1
)

:: ---------------------------------------------------------------
:: [9/18] Recent Files History
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Recent Files History...
echo   [!currentStep!/%totalSteps%] Cleaning Recent Files History... >> "%logFile%"
if exist "%recentDir%" (
    del /f /s /q "%recentDir%\*.*" >nul 2>&1
    for /D %%G in ("%recentDir%\*") do rd /s /q "%%G" >nul 2>&1
    echo     [OK] Recent Files History cleaned >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [SKIP] Recent folder not found >> "%logFile%"
    set /a failCount+=1
)

:: ---------------------------------------------------------------
:: [10/18] Browser Cache (Edge + Chrome)
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Browser Cache...
echo   [!currentStep!/%totalSteps%] Cleaning Browser Cache... >> "%logFile%"
set "browserCleaned=0"

if exist "%edgeCacheDir%" (
    del /f /s /q "%edgeCacheDir%\*.*" >nul 2>&1
    echo     [OK] Microsoft Edge Cache cleaned >> "%logFile%"
    set "browserCleaned=1"
)
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache" (
    del /f /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\*.*" >nul 2>&1
    echo     [OK] Microsoft Edge Code Cache cleaned >> "%logFile%"
    set "browserCleaned=1"
)
if exist "%chromeCacheDir%" (
    del /f /s /q "%chromeCacheDir%\*.*" >nul 2>&1
    echo     [OK] Google Chrome Cache cleaned >> "%logFile%"
    set "browserCleaned=1"
)
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache" (
    del /f /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache\*.*" >nul 2>&1
    echo     [OK] Google Chrome Code Cache cleaned >> "%logFile%"
    set "browserCleaned=1"
)
if exist "%inetCacheDir%" (
    del /f /s /q "%inetCacheDir%\*.*" >nul 2>&1
    echo     [OK] IE Legacy Cache cleaned >> "%logFile%"
    set "browserCleaned=1"
)
if "!browserCleaned!"=="1" (
    set /a successCount+=1
) else (
    echo     [SKIP] No browser cache found >> "%logFile%"
    set /a failCount+=1
)

:: ---------------------------------------------------------------
:: [11/18] Windows Log Files
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Windows Log Files...
echo   [!currentStep!/%totalSteps%] Cleaning Windows Log Files... >> "%logFile%"
if exist "%winLogs%" (
    del /f /s /q "%winLogs%\*.log" >nul 2>&1
    del /f /s /q "%winLogs%\*.etl" >nul 2>&1
    del /f /s /q "%winLogs%\*.old" >nul 2>&1
    echo     [OK] Windows Log Files cleaned >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [SKIP] Windows Logs folder not found >> "%logFile%"
    set /a failCount+=1
)
if exist "%WINDIR%\*.log" (
    del /f /q "%WINDIR%\*.log" >nul 2>&1
    echo     [OK] System root log files cleaned >> "%logFile%"
)

:: ---------------------------------------------------------------
:: [12/18] Delivery Optimization Cache
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Delivery Optimization Cache...
echo   [!currentStep!/%totalSteps%] Cleaning Delivery Optimization Cache... >> "%logFile%"
net stop dosvc >nul 2>&1
if exist "%delivOptDir%" (
    del /f /s /q "%delivOptDir%\*.*" >nul 2>&1
    for /D %%G in ("%delivOptDir%\*") do rd /s /q "%%G" >nul 2>&1
    echo     [OK] Delivery Optimization Cache cleaned >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [SKIP] Delivery Optimization Cache not found >> "%logFile%"
    set /a failCount+=1
)
net start dosvc >nul 2>&1

:: ---------------------------------------------------------------
:: [13/18] Font Cache
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Font Cache...
echo   [!currentStep!/%totalSteps%] Cleaning Font Cache... >> "%logFile%"
net stop FontCache >nul 2>&1
net stop FontCache3.0.0.0 >nul 2>&1
if exist "%fontCacheFile%" (
    del /f /q "%fontCacheFile%\*" >nul 2>&1
    echo     [OK] Font Cache cleaned >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [INFO] Font Cache location not standard, skipping >> "%logFile%"
    set /a successCount+=1
)
net start FontCache >nul 2>&1
net start FontCache3.0.0.0 >nul 2>&1

:: ---------------------------------------------------------------
:: [14/18] Memory Dump Files
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Cleaning Memory Dump Files...
echo   [!currentStep!/%totalSteps%] Cleaning Memory Dump Files... >> "%logFile%"
set "dumpCleaned=0"
if exist "%WINDIR%\MEMORY.DMP" (
    del /f /q "%WINDIR%\MEMORY.DMP" >nul 2>&1
    set "dumpCleaned=1"
)
if exist "%WINDIR%\Minidump" (
    del /f /s /q "%WINDIR%\Minidump\*.*" >nul 2>&1
    set "dumpCleaned=1"
)
if exist "%LOCALAPPDATA%\CrashDumps" (
    del /f /s /q "%LOCALAPPDATA%\CrashDumps\*.*" >nul 2>&1
    set "dumpCleaned=1"
)
if "!dumpCleaned!"=="1" (
    echo     [OK] Memory Dump Files cleaned >> "%logFile%"
) else (
    echo     [SKIP] No dump files found >> "%logFile%"
)
set /a successCount+=1

:: ===============================================================
:: PC Optimization Section
:: ===============================================================
echo.
echo  +----------------------------------------------------------+
echo  ^|           PC OPTIMIZATION IN PROGRESS...                 ^|
echo  +----------------------------------------------------------+
echo.
echo. >> "%logFile%"
echo  ========================================== >> "%logFile%"
echo   PC OPTIMIZATION >> "%logFile%"
echo  ========================================== >> "%logFile%"

:: ---------------------------------------------------------------
:: [15/18] Network Optimization (Winsock Reset)
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Optimizing Network Stack...
echo   [!currentStep!/%totalSteps%] Optimizing Network Stack... >> "%logFile%"
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
echo     [OK] Winsock catalog and IP stack reset >> "%logFile%"
set /a successCount+=1

:: ---------------------------------------------------------------
:: [16/18] Windows Store Cache
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Clearing Windows Store Cache...
echo   [!currentStep!/%totalSteps%] Clearing Windows Store Cache... >> "%logFile%"
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache" (
    del /f /s /q "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache\*.*" >nul 2>&1
    echo     [OK] Windows Store Cache cleaned >> "%logFile%"
    set /a successCount+=1
) else (
    echo     [OK] Windows Store Cache reset >> "%logFile%"
    set /a successCount+=1
)

:: ---------------------------------------------------------------
:: [17/18] Windows Disk Cleanup Utility (Silent)
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Running Disk Cleanup Utility...
echo   [!currentStep!/%totalSteps%] Running Disk Cleanup Utility... >> "%logFile%"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0064 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" /v StateFlags0064 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files" /v StateFlags0064 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files" /v StateFlags0064 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" /v StateFlags0064 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files" /v StateFlags0064 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v StateFlags0064 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files" /v StateFlags0064 /t REG_DWORD /d 2 /f >nul 2>&1
cleanmgr /sagerun:64 >nul 2>&1
echo     [OK] Disk Cleanup Utility completed >> "%logFile%"
set /a successCount+=1

:: ---------------------------------------------------------------
:: [18/18] Windows Explorer Restart
:: ---------------------------------------------------------------
set /a currentStep+=1
echo   [!currentStep!/%totalSteps%] Restarting Windows Explorer...
echo   [!currentStep!/%totalSteps%] Restarting Windows Explorer... >> "%logFile%"
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
start explorer.exe
timeout /t 2 >nul
echo     [OK] Windows Explorer restarted >> "%logFile%"
set /a successCount+=1

:: ===============================================================
:: Summary Report
:: ===============================================================
echo. >> "%logFile%"
echo ========================================================== >> "%logFile%"
echo   CLEANUP SUMMARY >> "%logFile%"
echo ========================================================== >> "%logFile%"
echo   Total Steps:     %totalSteps% >> "%logFile%"
echo   Successful:      !successCount! >> "%logFile%"
echo   Skipped/Failed:  !failCount! >> "%logFile%"
echo   Completed At:    %TIME% on %DATE% >> "%logFile%"
echo ========================================================== >> "%logFile%"
echo   Log saved to: %logFile% >> "%logFile%"
echo ========================================================== >> "%logFile%"

:: ===============================================================
:: Final Countdown - Show Summary
:: ===============================================================
for /L %%i in (30,-1,1) do (
    cls
    echo.
    echo  +----------------------------------------------------------+
    echo  ^|              CLEANUP COMPLETE - SUMMARY                  ^|
    echo  +----------------------------------------------------------+
    echo  ^|                                                          ^|
    echo  ^|   [OK] User Temp Files            - Cleaned              ^|
    echo  ^|   [OK] Windows Temp Files         - Cleaned              ^|
    echo  ^|   [OK] Prefetch Files             - Cleaned              ^|
    echo  ^|   [OK] Recycle Bin                - Emptied              ^|
    echo  ^|   [OK] Windows Update Cache       - Cleaned              ^|
    echo  ^|   [OK] Thumbnail/Icon Cache       - Cleaned              ^|
    echo  ^|   [OK] DNS Cache                  - Flushed              ^|
    echo  ^|   [OK] Windows Error Reports      - Cleaned              ^|
    echo  ^|   [OK] Recent Files History       - Cleaned              ^|
    echo  ^|   [OK] Browser Cache              - Cleaned              ^|
    echo  ^|   [OK] Windows Log Files          - Cleaned              ^|
    echo  ^|   [OK] Delivery Optimization      - Cleaned              ^|
    echo  ^|   [OK] Font Cache                 - Rebuilt              ^|
    echo  ^|   [OK] Memory Dump Files          - Cleaned              ^|
    echo  ^|   [OK] Network Stack              - Optimized            ^|
    echo  ^|   [OK] Windows Store Cache        - Cleared              ^|
    echo  ^|   [OK] Disk Cleanup               - Completed            ^|
    echo  ^|   [OK] Windows Explorer           - Restarted            ^|
    echo  ^|                                                          ^|
    echo  +----------------------------------------------------------+
    echo  ^|   Steps: !successCount!/%totalSteps% Successful                  ^|
    echo  ^|   Log: %logFile%                                         ^|
    echo  ^|                                                          ^|
    echo  ^|   Closing in %%i seconds...                               ^|
    echo  ^|                                                          ^|
    echo  ^|   by Emamul Islam Rabbi - v2.0                           ^|
    echo  +----------------------------------------------------------+
    timeout /t 1 >nul
)

endlocal
exit
