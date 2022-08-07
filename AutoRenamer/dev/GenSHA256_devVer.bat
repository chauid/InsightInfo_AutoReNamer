@echo off
certutil /hashfile AutoReNamer_dev.bat SHA256>SHA256.txt
for /f "tokens=* skip=1" %%i in (SHA256.txt) do echo %%i>SHA256.txt & goto :endhash
:endhash
start notepad SHA256.txt
timeout /t 1 >nul
del SHA256.txt
exit