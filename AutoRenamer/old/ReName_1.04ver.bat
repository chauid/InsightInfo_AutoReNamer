@echo off
chcp 65001>nul
setlocal ENABLEDELAYEDEXPANSION
set batchname=%~nx0
set listname=filelist
set /a listnum=0
set workercode=000
set classcode=00
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
if %Todir% equ Q exit /b
if %Todir% equ q exit /b
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
if %Todir% equ Q exit /b
if %Todir% equ q exit /b
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
rem ##########워커코드 입력 (default:000)##########
set /p workercode=워커코드 : 
rem ##########날짜 입력##########
set /p setdate=날짜(ex:220628) : 
rem ##########파일 확장자 입력##########
set /p fileExt=파일 확장자(ex:xlsx, wav) : 
rem ##########선택 옵션##########
choice /c 12 /n /m "1.이름재설정, 2.파일복사 : "
if %errorlevel% equ 0 goto quit
if %errorlevel% equ 1 goto rename
if %errorlevel% equ 2 goto copyname
:rename
set option=rename
rem ##########파일 개수 계산(디렉터리  제외)##########
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
ren "%temp%" "%classcode%_03_%workercode%_%setdate%_%Fixednumber%_SS.%fileExt%"
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
copy /y "%target%" "%classcode%_03_%workercode%_%setdate%_%Fixednumber%_SS.%fileExt%">nul
set /a number=number-1
goto cpLoop
:quit
if %option% equ rename (del /f %listname% & echo ########이름 재설정 완료!########)
if %option% equ renError (del /f %listname% & echo 이름을 재설정할 파일이 없습니다.)
if %option% equ copyname echo ########복사 완료!########
endlocal
pause>nul
exit /b