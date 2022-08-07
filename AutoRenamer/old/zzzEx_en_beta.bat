@echo off
title ReName
set batchpath=%~dp0
set /a listnum=0
set /a number=0
set workercode=000
set classcode=00
set before=NULL
rem ##########Input WorkCode (default:000)##########
set /p workercode=WorkerCode : 
rem ##########Input date##########
set /p setdate=Set Date(ex:220628) : 
rem ##########Input File Extension##########
set /p fileExt=File Extension(ex:xlsx, wav) : 
rem ##########choice option##########
choice /c 12 /n /m "1.rename, 2.copy : "
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
echo Currtent number of files : %listnum%
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
set /p target=What files do you want to copy? : 
set /p number=how many copies? : 
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
if %option% equ rename (del /f zzfilelist & echo ########Change Complete!########)
if %option% equ renError (del /f zzfilelist & echo Nothing to rename files! Exit...)
if %option% equ copyname echo ########Copy Complete!########
pause>nul