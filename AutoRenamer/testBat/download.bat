rem @echo off
set current=%~dp0
set /a version=121
powershell Invoke-WebRequest -Uri 192.168.0.75/files/update%version%log.txt -OutFile %current%%version%update.txt
pause