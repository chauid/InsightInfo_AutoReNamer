@echo off
powershell (Invoke-WebRequest 192.168.0.75/files/Yachtver.txt).RawContent > Yacht.txt
powershell (Invoke-WebRequest 192.168.0.75/files/AutoReName.bat).RawContent > ReName.txt
for /f "delims=: tokens=2 skip=2" %%i in ('find "version" Yacht.txt')  do set Yachtver=%%i
for /f "delims=: tokens=2 skip=2" %%i in ('find "CurrentVersion" ReName.txt')  do set ReNamever=%%i & goto getVersion
:getVersion
del Yacht.txt
del ReName.txt
set /a Yachtver=Yachtver
set /a ReNamever=ReNamever
echo Server's YachtDice version=%Yachtver%
echo Server's AutoRename version=%ReNamever%
pause
exit