@echo off
title System Cleaner by Emamul Islam Rabbi
mode con: cols=60 lines=20

:: -------------------------------
:: Log ফাইল সেটআপ
:: -------------------------------
set "logFile=%USERPROFILE%\Desktop\RabbiCleanerLog.txt"
echo System Cleanup Log - %DATE% %TIME% > "%logFile%"
echo --------------------------------------------- >> "%logFile%"

:: -------------------------------
:: অ্যাডমিন হিসেবে রান হচ্ছে কিনা চেক করা
:: -------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell Start-Process '%0' -Verb runAs
    exit
)

:: -------------------------------
:: প্রথম কাউন্টডাউন: 20 সেকেন্ড
:: -------------------------------
for /L %%i in (20,-1,1) do (
    cls
    echo ============================================
    echo     System Cleaner by Emamul Islam Rabbi
    echo ============================================
    echo.
    echo Starting in %%i seconds...
    timeout /t 1 >nul
)
:: কাউন্টডাউন শেষ হলে স্ক্রিন পরিষ্কার করে "Program started" দেখানো হবে
cls
echo ============================================
echo     System Cleaner by Emamul Islam Rabbi
echo ============================================
echo.
echo Program started.
timeout /t 1 >nul

echo ============================================= >> "%logFile%"
echo      System Cleaner by Emamul Islam Rabbi >> "%logFile%"
echo ============================================= >> "%logFile%"
echo.
:: -------------------------------
:: Temporary Files ক্লিন করা হচ্ছে
:: -------------------------------
echo Cleaning Temporary Files...
echo Cleaning Temporary Files... >> "%logFile%"
timeout /t 2 >nul

set "tempFolder=C:\Users\Rabbi\AppData\Local\Temp"

:: যদি ফাইল/ফোল্ডার লক থাকে, তাহলে পারমিশন নেওয়া হচ্ছে
takeown /f "%tempFolder%" /r /d Y >nul 2>&1
icacls "%tempFolder%" /grant administrators:F /t /c /q >nul 2>&1

:: ফাইলগুলো ডিলিট করা হচ্ছে এবং LOG এ লেখা হচ্ছে
for /r "%tempFolder%" %%F in (*.*) do (
    echo Deleted: %%F >> "%logFile%"
    del /f /q "%%F" >nul 2>&1
)

:: সব সাবফোল্ডারগুলো ডিলিট করা হচ্ছে
for /D %%G in ("%tempFolder%\*") do (
    echo Deleted Folder: %%G >> "%logFile%"
    rd /s /q "%%G" >nul 2>&1
)

timeout /t 2 >nul
echo Temporary Files Deleted Successfully! >> "%logFile%"

:: -------------------------------
:: Recycle Bin খালি করা হচ্ছে (PowerShell দিয়ে)
:: -------------------------------
echo Emptying Recycle Bin...
echo Emptying Recycle Bin... >> "%logFile%"
timeout /t 2 >nul
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Clear-RecycleBin -Confirm:$false" >nul 2>&1
echo Recycle Bin Emptied! >> "%logFile%"
timeout /t 2 >nul

:: -------------------------------
:: Windows Explorer রিস্টার্ট করা হচ্ছে
:: -------------------------------
echo Restarting Windows Explorer...
echo Restarting Windows Explorer... >> "%logFile%"
timeout /t 2 >nul
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
start explorer.exe
timeout /t 2 >nul
echo Windows Explorer Restarted! >> "%logFile%"

:: -------------------------------
:: শেষের কাউন্টডাউন: 30 সেকেন্ড
:: -------------------------------
echo.
echo Done! Your system has been refreshed.
echo Cleanup Complete. >> "%logFile%"
echo.

for /L %%i in (30,-1,1) do (
    cls
    echo ============================================
    echo     System Cleaner by Emamul Islam Rabbi
    echo ============================================
    echo.
    echo Temporary Files Deleted Successfully!
    echo Recycle Bin Emptied!
    echo Windows Explorer Restarted!
    echo Your system has been refreshed.
    echo.
    echo CLEANUP COMPLETE !
    echo.
    echo The program will close in %%i seconds...
    timeout /t 1 >nul
)

exit
