@echo off
chcp 65001>nul
setlocal ENABLEDELAYEDEXPANSION
set current=%~dp0
set batchname=%~nx0
rem ##########CurrentVersion:112:##########
set /a version=112
title AutoReName_ver%version%
bcdedit > nul
if %errorlevel% equ 1 goto noadmin
echo Initialize...
timeout /t 2 /nobreak > nul
rem ##########zip, upzip 설치##########
if not exist C:\Windows\System32\zip.exe powershell Invoke-WebRequest -Uri http://stahlworks.com/dev/zip.exe -OutFile C:\Windows\System32\zip.exe
if not exist C:\Windows\System32\unzip.exe powershell Invoke-WebRequest -Uri http://stahlworks.com/dev/unzip.exe -OutFile C:\Windows\System32\unzip.exe
if exist C:\Windows\System32\zip.exe echo zip.exe is Installed
if exist C:\Windows\System32\unzip.exe echo unzip.exe is Installed
rem ##########버전 확인(업데이트)##########
if "%1" neq "update" goto FirstEx
cd /d %current%
ren "%batchname%" "AutoReName.bat" & start %current%"AutoReName.bat" & exit
goto init
:UpdateProgram
powershell Invoke-WebRequest -Uri 192.168.0.75/files/AutoReName.bat -OutFile %current%\NewVersion.bat
start %current%NewVersion.bat update
del %current%%batchname%
exit
:FirstEx
powershell (Invoke-WebRequest 192.168.0.75/files/AutoReName.bat).RawContent > ReName.txt
if not exist ReName.txt echo 서버와 연결할 수 없습니다. & pause>nul & goto init
for /f "delims=: tokens=2 skip=2" %%i in ('find "CurrentVersion" ReName.txt')  do set ReName=%%i & goto getVersion
:getVersion
del ReName.txt
set /a ReName=ReName
echo 현재 버전:%version%, 최신버전:%ReName%
if %ReName% equ %version% echo 현재 최신 버전입니다. & timeout /t 3 > nul & goto init
if %ReName% lss %version% echo 서버의 버전보다 높습니다. 버전을 확인하세요. & pause>nul & start http://192.168.0.75/ & goto init
choice /c yn /m "업데이트 가능한 버전이 있습니다. 업데이트를 진행하시겠습니까?"
if %errorlevel% equ 0 goto quit
if %errorlevel% equ 1 goto UpdateProgram
if %errorlevel% equ 2 goto init
:init
set listname=filelist
set /a listnum=0
set workercode=000
set category1=00
set category2=00
cd /d %current%
cls
rem ##########디렉터리 탐색##########
:OnDirectory
title 현재 디렉터리 경로 : %cd%
set /a dirnum=0
set /a dirlistnum=1
set /a filenum=0
rem #####디렉터리 리스트 배열[1~N]#####
set dirlist=NULL
for /f %%i in ('dir /a:d /b') do set /a dirnum=dirnum+1
for /f %%i in ('dir /a:-d /b') do set /a filenum=filenum+1
if %dirnum% lss 1 goto NoDir
for /f "tokens=*" %%i in ('dir /a:d /b') do (set dirlist[%dirlistnum%]=%%i & goto LoadDirList)
:LoadDirList
set /a dirlistnum=dirlistnum+1
rem #####리스트의 인덱스는 1부터 시작, 따라서 문장스킵은 리스트의 인덱스 - 1#####
set /a skips=dirlistnum-1
if %skips% equ %dirnum% goto EOF
for /f "tokens=* skip=%skips%" %%i in ('dir /a:d /b') do (set dirlist[%dirlistnum%]=%%i & goto LoadDirList)
goto quit
:EOF
echo 현재 경로 : %cd%
echo ----------------------------------------------------------------------
for /l %%i in (1,1,%dirnum%) do echo %%i. !dirlist[%%i]!
echo %dirlistnum%. [..]상위 디렉터리로 가기
echo ----------------------------------------------------------------------
echo 현재 경로의 디렉터리 수 : %dirnum% ^| 파일 수 : %filenum%
echo 현재 경로를 작업공간으로 설정하기 : S  ^| 현재 경로에서 파일 보기 : P  ^| 종료하기 : Q
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set /p Todir=Choice : 
if %Todir% equ S goto quitExplore
if %Todir% equ s goto quitExplore
if %Todir% equ P dir /a:-d /d & pause>nul & cls & goto OnDirectory
if %Todir% equ p dir /a:-d /d & pause>nul & cls & goto OnDirectory
if %Todir% equ Q echo 프로그램을 종료합니다. & pause>nul & exit
if %Todir% equ q echo 프로그램을 종료합니다. & pause>nul & exit
set /a temp=Todir-1
if %Todir% gtr %dirnum% (echo 1~%dirnum%까지만 선택 가능합니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
if %temp% lss 0 (echo 1~%dirnum%까지만 선택 가능합니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
goto MvDir
:NoDir
echo 현재 경로 : %cd%
echo ----------------------------------------------------------------------
echo %dirlistnum%. [..]상위 디렉터리로 가기
echo ----------------------------------------------------------------------
echo 현재 경로의 디렉터리 수 : %dirnum% ^| 파일 수 : %filenum%
echo 현재 경로를 작업공간으로 설정하기 : S  ^| 현재 경로에서 파일 보기 : P  ^| 종료하기 : Q
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set /p Todir=Choice : 
if %Todir% equ S goto quitExplore
if %Todir% equ s goto quitExplore
if %Todir% equ P dir /a:-d /d & pause>nul & cls & goto OnDirectory
if %Todir% equ p dir /a:-d /d & pause>nul & cls & goto OnDirectory
if %Todir% equ Q echo 프로그램을 종료합니다. & pause>nul & exit
if %Todir% equ q echo 프로그램을 종료합니다. & pause>nul & exit
set /a temp=Todir-1
if %temp% neq 0 (echo 현재 디렉터리에 디렉터리가 없습니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
goto MvDir
:MvDir
cd !dirlist[%Todir%]!
cls
goto OnDirectory
:quitExplore
set /a skips=1
set /a number=1
cls & title 작업할 디렉터리 경로 : %cd%
rem ##########소리/소음 선택##########
echo 소리/소음 분류
choice /c 12 /n /m "1.소음 2.소리"
if %errorlevel% equ 0 exit
if %errorlevel% equ 1 (
 set last=NN
 set /p category1=대분류ID : 
 set /p category2=소분류ID : 
)
if %errorlevel% equ 2 (
 set last=SS
 set category1=00
 set /p category2=소분류ID : 
)
rem ##########워커코드 입력 (default:000)##########
set /p workercode=워커코드 : 
rem ##########날짜 입력##########
set /p setdate=날짜(ex:220628) : 
rem ##########파일 확장자 입력##########
set /p fileExt=파일 확장자(ex:xlsx, wav) : 
rem ##########선택 옵션##########
choice /c 12 /n /m "1.이름재설정, 2.파일복사 : "
if %errorlevel% equ 0 exit
if %errorlevel% equ 1 goto rename
if %errorlevel% equ 2 goto copyname
:rename
set option=rename
rem ##########파일 개수 계산(디렉터리  제외)##########
set /a listnum=0
dir /b /a:-d > %listname%
for /f %%i in (%listname%) do set /a listnum=listnum+1
if %listnum% lss 2 (set option=renError & goto quit)
set /a plistnum=listnum-1
echo 현재 폴더의 파일 개수 : %plistnum%
rem ##########시작값 입력##########
echo 시작할 번호를 입력해 주세요. (001부터 시작하려면 1을 입력해주세요.)
set /p number=시작 번호 : 
set /a listnum=listnum+number-1
rem ##########skip=0은 지원하기 않음, skip=1부터 시작##########
for /f "tokens=*" %%i in (%listname%) do (set temp=%%i & goto getName)
:renLoop
if %number% geq %listnum% goto quit
for /f "tokens=* skip=%skips%" %%i in (%listname%) do (set temp=%%i & set /a skips=skips+1 & goto getName)
:getName
rem ##########파일 이름이 filelist일 경우 이름바꾸기X##########
if "%temp%" equ "%listname% " goto renLoop
rem ##########숫자 형식 설정 001~999 (010 != 8 error)##########
set Fixednumber=%number%
if %number% lss 100 set Fixednumber=0%number%
if %number% lss 10 set Fixednumber=00%number%
ren "%temp%" "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.%fileExt%"
set /a number=number+1
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
copy /y "%target%" "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.%fileExt%">nul
set /a number=number-1
goto cpLoop
:quit
if %option% equ rename (del /f %listname% & echo ########이름 재설정 완료!########)
if %option% equ renError (del /f %listname% & echo 이름을 재설정할 파일이 없습니다.)
if %option% equ copyname echo ########복사 완료!########
pause>nul
choice /c 12 /n /m "1.계속하기 2.종료하기"
if %errorlevel% equ 0 exit
if %errorlevel% equ 1 cls & goto OnDirectory
if %errorlevel% equ 2 echo 프로그램을 종료합니다. & pause>nul
endlocal
exit
:noadmin
echo 관리자 권한으로 실행해주세요.
pause>nul
exit
