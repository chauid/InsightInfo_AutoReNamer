@echo off
choice /c 12 /n /m "1.Generate hash 2.Generate base64"
if %errorlevel% equ 1 goto hash
if %errorlevel% equ 2 goto base64
:hash
certutil /hashfile AutoReNamer_dev.bat SHA256>SHA256.txt
for /f "tokens=* skip=1" %%i in (SHA256.txt) do echo %%i>SHA256.txt & goto :endhash
:endhash
start notepad SHA256.txt
timeout /t 1 >nul
del SHA256.txt
exit
:base64
certutil /encode AutoReNamer_dev.bat temp.txt
for /f "tokens=*" %%i in (temp.txt) do echo echo %%i^>^>ins64>>copybase64.txt
start notepad copybase64.txt
timeout /t 1 >nul
del temp.txt
del copybase64.txt
exit