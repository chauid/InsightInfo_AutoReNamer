@echo off
chcp 65001>nul
setlocal ENABLEDELAYEDEXPANSION
set current=%~dp0
set batchname=%~nx0
set insfile=AutoReNamer.bat
set version=141
title AutoReNamer_ver%version:~0,1%.%version:~1,2%
bcdedit > nul
if %errorlevel% equ 1 goto noadmin
echo 설치중...  버전:[%version:~0,1%.%version:~1,2%]
cd /d %current%
rem -----------------------------------------------Here write Base64Code.-----------------------------------------------

rem-------------------------------------------------------End Code-------------------------------------------------------
certutil /decode ins64 %insfile%>nul
del ins64
cd /d %userprofile%
if not exist %userprofile%\hashcode\ ( mkdir hashcode )
timeout /t 1 /nobreak >nul
cd /d %userprofile%\hashcode\
certutil /hashfile %current%\%insfile% SHA256>hashcode%version%.hash
for /f "tokens=* skip=1" %%i in (hashcode%version%.hash) do echo %%i>hashcode%version%.hash & goto genhash
:genhash
echo WScript.Sleep(100)>sleep.vbs
cls
echo        설치 완료
WScript sleep.vbs
cls
echo       -설치 완료-
WScript sleep.vbs
cls
echo      --설치 완료--
WScript sleep.vbs
cls
echo     ---설치 완료---
WScript sleep.vbs
cls
echo    ----설치 완료----
WScript sleep.vbs
cls
echo   -----설치 완료-----
del sleep.vbs
timeout /t 3 >nul
cd /d %current%
start %insfile%
exit
:noadmin
echo 관리자 권한으로 실행해주세요.
pause>nul
exit