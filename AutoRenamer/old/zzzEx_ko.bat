@echo off
chcp 65001>nul
setlocal ENABLEDELAYEDEXPANSION
set batchpath=%~dp0
set /a listnum=0
set /a number=0
set workercode=000
set classcode=00
set before=NULL
rem ##########Input WorkCode (default:000)##########
set /p workercode=워커코드 : 
rem ##########Input date##########
set /p setdate=날짜(ex:220628) : 
rem ##########Input File Extension##########
set /p fileExt=파일 확장자(ex:xlsx, wav) : 
rem ##########choice option##########
choice /c 12 /n /m "1.이름재설정, 2.파일복사 : "
if %errorlevel% equ 0 goto quit
if %errorlevel% equ 1 goto rename
if %errorlevel% equ 2 goto copyname
:rename
set option=rename
rem ##########calc number of files##########
dir /b > zzfilelist
for /f %%i in (zzfilelist) do set /a listnum=listnum+1
rem ##########self file and list file -2##########
set /a listnum=listnum-2
if %listnum% lss 1 (set option=renError & goto quit)
echo 현재 폴더의 파일 개수 : %listnum%
rem ##########not support skip=0, start skip.value = 1##########
for /f "tokens=*" %%i in (zzfilelist) do (set temp=%%i & goto getName)
:renLoop
if %number% equ %listnum% goto quit
set before=temp
for /f "tokens=* skip=%number%" %%i in (zzfilelist) do (set temp=%%i & goto getName)
:getName
rem ##########Fix number 001~999 (010 != 8 error)##########
set /a calcnumber=number+1
set Fixednumber=%calcnumber%
if %calcnumber% lss 100 set Fixednumber=0%calcnumber%
if %calcnumber% lss 10 set Fixednumber=00%calcnumber%
ren "%temp%" "%classcode%_03_%workercode%_%setdate%_%Fixednumber%_SS.%fileExt%"
set /a number=number+1
rem ##########End of File list##########
if %before% equ %temp% goto quit
goto renLoop
:copyname
set option=copyname
dir /d
set /p target=복사할 파일 : 
set /p number=복사할 개수 : 
:cpLoop
if %number% lss 1 goto quit
set /a calcnumber=number
set Fixednumber=%calcnumber%
if %calcnumber% lss 100 set Fixednumber=0%calcnumber%
if %calcnumber% lss 10 set Fixednumber=00%calcnumber%
copy /y "%target%" "%classcode%_03_%workercode%_%setdate%_%Fixednumber%_SS.%fileExt%">nul
set /a number=number-1
goto cpLoop
:quit
if %option% equ rename (del /f zzfilelist & echo ########이름 재설정 완료!########)
if %option% equ renError (del /f zzfilelist & echo 이름을 재설정할 파일이 없습니다.)
if %option% equ copyname echo ########복사 완료!########
pause>nul