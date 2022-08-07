@echo off
chcp 65001>nul
setlocal ENABLEDELAYEDEXPANSION
set current=%~dp0
set batchname=%~nx0
rem ##########CurrentVersion:134:##########
set /a version=134
title AutoReName_ver%version%
bcdedit > nul
if %errorlevel% equ 1 goto noadmin
echo Initialize...
rem ##########업데이트##########
if "%1" neq "update" goto init
timeout /t 2 /nobreak > nul
cd /d %current%
ren "%batchname%" "AutoReNamer.bat" & start %current%"AutoReNamer.bat" & exit
goto init
:UpdateProgram
powershell Invoke-WebRequest -Uri %serverIP%/files/AutoReNamer.bat -OutFile %current%NewVersion.bat
powershell Invoke-WebRequest -Uri %serverIP%/files/update%ReName%log.txt -OutFile %current%%ReName%update.txt
start %current%NewVersion.bat update
del %current%%batchname%
exit
:UpdateNow
if "%serverIP%" equ "0.0.0.0" echo 서버IP를 설정 후 업데이트하세요. & timeout /t 2 >nul & goto startScreen
echo 서버와 연결중... [접속서버IP:%serverIP%]
powershell (Invoke-WebRequest %serverIP%/files/AutoReNamer.bat).RawContent > ReNamer.txt
for /f "delims=: tokens=2 skip=2" %%i in ('find "CurrentVersion" ReNamer.txt')  do set ReName=%%i & goto getVersion
:getVersion
del ReNamer.txt
set /a ReName=ReName
if %ReName% equ 0 echo 서버와 연결할 수 없습니다. 또는 인터넷 익스플로러 최초 실행이 필요합니다. & timeout /t 3 >nul & cls & goto init
echo 현재 버전:%version%, 최신버전:%ReName%
if %ReName% equ %version% echo 현재 최신 버전입니다. & timeout /t 3 > nul & goto init
if %ReName% lss %version% echo 서버의 버전보다 높습니다. 버전을 확인하세요. & timeout /t 2 >nul & start http://%serverIP%/ & goto init
choice /c yn /m "업데이트 가능한 버전이 있습니다. 업데이트를 진행하시겠습니까?"
if %errorlevel% equ 1 goto UpdateProgram
if %errorlevel% equ 2 goto init
:init
set serverIP=0.0.0.0
set workercode=000
set setdate=%date:~2,2%%date:~5,2%%date:~8,2%
set mode=rename
set mixfile=OFF
set bgcolor=0
set textcolor=7
set listname=filelist.txt
set /a listnum=0
set category1=00
set category2=00
cd /d C:\
if exist usersetting.txt (
    echo 사용자 설정 불러오는 중...
    for /f "tokens=2 delims=: skip=1" %%i in ('find "worker" usersetting.txt') do set workercode=%%i
    for /f "tokens=2 delims=: skip=1" %%i in ('find "setdate" usersetting.txt') do set setdate=%%i
    for /f "tokens=2 delims=: skip=1" %%i in ('find "mode" usersetting.txt') do set mode=%%i
    for /f "tokens=2 delims=: skip=1" %%i in ('find "mixfile" usersetting.txt') do set mixfile=%%i
    for /f "tokens=2 delims=: skip=1" %%i in ('find "backgroundcolor" usersetting.txt') do set bgcolor=%%i
    for /f "tokens=2 delims=: skip=1" %%i in ('find "textcolor" usersetting.txt') do set textcolor=%%i
    for /f "tokens=2 delims=: skip=1" %%i in ('find "server" usersetting.txt') do set serverIP=%%i
) else (
    echo 사용자 설정 파일이 없음. 기본값으로 설정...
    timeout /t 1 >nul
)
:startScreen
color %bgcolor%%textcolor%
cls
cd /d %current%
echo WScript.Sleep(1)>sleep.vbs
WScript sleep.vbs
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
WScript sleep.vbs
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
echo ■  █████╗ ██╗   ██╗████████╗ ██████╗     ██████╗ ███████╗███╗   ██╗ █████╗ ███╗   ███╗███████╗██████╗  ■ 
WScript sleep.vbs
echo ■ ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗    ██╔══██╗██╔════╝████╗  ██║██╔══██╗████╗ ████║██╔════╝██╔══██╗ ■ 
WScript sleep.vbs
echo ■ ███████║██║   ██║   ██║   ██║   ██║    ██████╔╝█████╗  ██╔██╗ ██║███████║██╔████╔██║█████╗  ██████╔╝ ■ 
WScript sleep.vbs
echo ■ ██╔══██║██║   ██║   ██║   ██║   ██║    ██╔══██╗██╔══╝  ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗ ■ 
WScript sleep.vbs
echo ■ ██║  ██║╚██████╔╝   ██║   ╚██████╔╝    ██║  ██║███████╗██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗██║  ██║ ■ 
WScript sleep.vbs
echo ■ ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ ■ 
WScript sleep.vbs
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ver.%version:~0,1%.%version:~1,2%■■■■■ 
WScript sleep.vbs
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
WScript sleep.vbs
echo 1.시작하기  2.설정  3.업데이트  4.종료 
del sleep.vbs
choice /c 1234 /n /m "선택 : "
if %errorlevel% equ 1 goto OnDirectory
if %errorlevel% equ 2 set Callby=Main& goto Setting
if %errorlevel% equ 3 goto UpdateNow
if %errorlevel% equ 4 echo 프로그램을 종료합니다. & timeout /t 2 >nul & exit
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
cls
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
echo ---------------------------------------------------------------------------
for /l %%i in (1,1,%dirnum%) do echo %%i. !dirlist[%%i]!
echo %dirlistnum%. [..]상위 디렉터리로 가기
echo ---------------------------------------------------------------------------
echo 현재 설정 : [워커코드:%workercode%, 날짜:%setdate%, 실행모드:%mode%, 파일섞기:%mixfile%]
echo.
echo 현재 경로의 디렉터리 수 : %dirnum% ^| 파일 수 : %filenum%
echo 현재 경로를 작업공간으로 설정하기 : S  ^| 현재 경로에서 파일 보기 : P  ^| 이름바꾸기설정 : U  ^| 종료하기 : Q
echo 파일탐색기에서 현재 경로 열기 : E
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set /p Todir=입력 : 
if "%Todir%" equ "S" goto quitExplore
if "%Todir%" equ "s" goto quitExplore
if "%Todir%" equ "P" call :printfilelist & cls & goto OnDirectory
if "%Todir%" equ "p" call :printfilelist & cls & goto OnDirectory
if "%Todir%" equ "U" set Callby=Explorer& goto Setting
if "%Todir%" equ "u" set Callby=Explorer& goto Setting
if "%Todir%" equ "E" explorer %cd% & goto OnDirectory
if "%Todir%" equ "e" explorer %cd% & goto OnDirectory
if "%Todir%" equ "Q" echo 프로그램을 종료합니다. & timeout /t 2 >nul & exit
if "%Todir%" equ "q" echo 프로그램을 종료합니다. & timeout /t 2 >nul & exit
set /a temp=Todir-1
if %Todir% gtr %dirnum% (echo 1~%dirnum%까지만 선택 가능합니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
if %temp% lss 0 (echo 1~%dirnum%까지만 선택 가능합니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
goto MvDir
:NoDir
echo 현재 경로 : %cd%
echo ---------------------------------------------------------------------------
echo %dirlistnum%. [..]상위 디렉터리로 가기
echo ---------------------------------------------------------------------------
echo 현재 설정 : [워커코드:%workercode%, 날짜:%setdate%, 실행모드:%mode%, 파일섞기:%mixfile%]
echo.
echo 현재 경로의 디렉터리 수 : %dirnum% ^| 파일 수 : %filenum%
echo 현재 경로를 작업공간으로 설정하기 : S  ^| 현재 경로에서 파일 보기 : P  ^| 이름바꾸기설정 : U  ^| 종료하기 : Q
echo 파일탐색기에서 현재 경로 열기 : E
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set /p Todir=입력 : 
if "%Todir%" equ "S" goto quitExplore
if "%Todir%" equ "s" goto quitExplore
if "%Todir%" equ "P" call :printfilelist & cls & goto OnDirectory
if "%Todir%" equ "p" call :printfilelist & pause>nul & cls & goto OnDirectory
if "%Todir%" equ "U" set Callby=Explorer& goto Setting
if "%Todir%" equ "u" set Callby=Explorer& goto Setting
if "%Todir%" equ "E" explorer %cd% & goto OnDirectory
if "%Todir%" equ "e" explorer %cd% & goto OnDirectory
if "%Todir%" equ "Q" echo 프로그램을 종료합니다. & timeout /t 2 >nul & exit
if "%Todir%" equ "q" echo 프로그램을 종료합니다. & timeout /t 2 >nul & exit
set /a temp=Todir-1
if %temp% neq 0 (echo 현재 디렉터리에 디렉터리가 없습니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
goto MvDir
:MvDir
cd !dirlist[%Todir%]!
set current=%cd%
cls
goto OnDirectory
:printfilelist
echo.
echo 파일 목록
echo ------------------------------------------------------------------------------
for /f "tokens=* skip=5" %%i in ('dir /a:-d /d') do echo %%i
echo ------------------------------------------------------------------------------
exit /b
:quitExplore
cls & title 작업할 디렉터리 경로 : %cd%
rem ##########소리/소음 선택##########
:InputSoundtype
echo 소리/소음 분류 (오디오 확장자는 .m4a, .mp3, .wav만 지원합니다.)
choice /c 123 /n /m "1.소음 2.소리 3.취소"
if %errorlevel% equ 1 cls & goto TypeNoise
if %errorlevel% equ 2 cls & goto TypeSound
if %errorlevel% equ 3 cls & goto OnDirectory
:TypeNoise
set last=NN
echo 소음 대분류표
echo --------------------
echo 코드ID ^| 코드명
echo --------------------
echo  01 ^| 교통수단 
echo  02 ^| 공사장 
echo  03 ^| 공장 
echo  04 ^| 시설류 
echo  05 ^| 기타 
echo --------------------
set /p category1=대분류ID : 
if "%category1%" equ "01" goto inputNosieCategory
if "%category1%" equ "02" goto inputNosieCategory
if "%category1%" equ "03" goto inputNosieCategory
if "%category1%" equ "04" goto inputNosieCategory
if "%category1%" equ "05" goto inputNosieCategory
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
:inputNosieCategory
echo.
echo 소음 소분류표
echo --------------------
echo 코드ID  ^|  코드명
echo --------------------
if "%category1%" equ "01" (
    echo  01 ^| 지상운송수단 
    echo  02 ^| 철로운송수단 
    echo  03 ^| 항공운송수단 
    echo  04 ^| 수상운송수단 
    echo --------------------
    set /p category2=소분류ID : 
    goto Cat01
)
if "%category1%" equ "02" (
    echo  01 ^| 경장비소음 
    echo  02 ^| 중장비소음 
    echo --------------------
    set /p category2=소분류ID : 
    goto Cat02
)
if "%category1%" equ "03" (
    echo  01 ^| 공장기계음 
    echo --------------------
    set /p category2=소분류ID : 
    goto Cat03
)
if "%category1%" equ "04" (
    echo  01 ^| 실내시설 
    echo  02 ^| 실외시설 
    echo --------------------
    set /p category2=소분류ID : 
    goto Cat04
)
if "%category1%" equ "05" (
    echo  01 ^| 실내기타소음 
    echo  02 ^| 실외기타소음 
    echo --------------------
    set /p category2=소분류ID : 
    goto Cat05
)
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
:Cat01
if "%category2%" equ "01" goto AfterInit
if "%category2%" equ "02" goto AfterInit
if "%category2%" equ "03" goto AfterInit
if "%category2%" equ "04" goto AfterInit
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
:Cat02
if "%category2%" equ "01" goto AfterInit
if "%category2%" equ "02" goto AfterInit
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
:Cat03
if "%category2%" equ "01" goto AfterInit
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
:Cat04
if "%category2%" equ "01" goto AfterInit
if "%category2%" equ "02" goto AfterInit
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
:Cat05
if "%category2%" equ "01" goto AfterInit
if "%category2%" equ "02" goto AfterInit
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
goto inputNoiseCat
:inputNoiseCat
echo --------------------
set /p category2=소분류ID : 
goto AfterInit
:TypeSound
set last=SS
set category1=00
echo 소리 대분류표
echo --------------------
echo  00 ^| 미정(워커전용) 
echo  01 ^| 사람의 비언어적소리 
echo  02 ^| 동물 및 자연물소리 
echo  03 ^| 전자제품 및 생활환경소리 
echo  04 ^| 기타소리 
echo --------------------
set /p category2=대분류ID : 
if "%category2%" equ "00" goto AfterInit
if "%category2%" equ "01" goto AfterInit
if "%category2%" equ "02" goto AfterInit
if "%category2%" equ "03" goto AfterInit
if "%category2%" equ "04" goto AfterInit
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
:Setting
cls
rem ##########이름바꾸기 설정, 프로그램 설정##########
set /a MaxX=2
set /a MaxY=1
set /a posMenuX=1
set /a posMenuY=1
goto drawSettingScreen
:inputSettingCode
choice /c adrq /n >nul
if %errorlevel% equ 1 set /a posMenuX=posMenuX-1 & goto drawSettingScreen
if %errorlevel% equ 2 set /a posMenuX=posMenuX+1 & goto drawSettingScreen
if %errorlevel% equ 3 goto SettingCodeSelected
if %errorlevel% equ 4 (
    if "%Callby%" equ "Main" (goto startScreen) else (
        if "%Callby%" equ "Explorer" (goto OnDirectory) else (goto startScreen)
    )
)
:drawSettingScreen
cls
if %posMenuX% lss 1 set /a posMenuX=MaxX
if %posMenuX% gtr %MaxX% set /a posMenuX=1
echo *---------------------------------------------------------*
echo ^| 사용자 설정 메뉴 [왼쪽:A, 오른쪽:D, 확인:R, 뒤로가기:Q] ^|
echo ^|---------------------------------------------------------^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" (set /p "=이름바꾸기 설정[*]  "<nul) else (set /p "=이름바꾸기 설정[ ]  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" (set /p "=프로그램 설정[*]  "<nul) else (set /p "=프로그램 설정[ ]  "<nul)
echo                   ^|
echo ^|---------------------------------------------------------^|
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" echo ^| 워커코드, 날짜, 실행모드, 파일섞기 기능을 설정합니다.   ^|
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" echo ^| 프로그램의 색상 설정 및 서버IP를 설정합니다.            ^|
echo *---------------------------------------------------------*
goto inputSettingCode
:SettingCodeSelected
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" goto SettingRename
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" goto SettingProgram
:SettingRename
cls
rem ##########이름바꾸기 설정//워커코드, 날짜, 선택옵션, 파일섞기 옵션##########
set /a MaxX=4
set /a MaxY=1
set /a posMenuX=1
set /a posMenuY=1
goto drawSettingRenameScreen
:inputSettingRenameCode
choice /c adrfq /n >nul
if %errorlevel% equ 1 set /a posMenuX=posMenuX-1 & goto drawSettingRenameScreen
if %errorlevel% equ 2 set /a posMenuX=posMenuX+1 & goto drawSettingRenameScreen
if %errorlevel% equ 3 goto SettingRenameSelected
if %errorlevel% equ 4 goto SettingSave
if %errorlevel% equ 5 goto Setting
:drawSettingRenameScreen
cls
if %posMenuX% lss 1 set /a posMenuX=MaxX
if %posMenuX% gtr %MaxX% set /a posMenuX=1
echo *-------------------------------------------------------------------------------*
echo ^| 이름바꾸기 설정 메뉴 [왼쪽:A, 오른쪽:D, 확인:R, 사용자설정저장:F, 뒤로가기:Q] ^|
echo ^|-------------------------------------------------------------------------------^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" (set /p "=워커코드 설정[*]  "<nul) else (set /p "=워커코드 설정[ ]  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" (set /p "=날짜 설정[*]  "<nul) else (set /p "=날짜 설정[ ]  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" (set /p "=실행모드 설정[*]  "<nul) else (set /p "=실행모드 설정[ ]  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(4,1)" (set /p "=파일순서 섞기 설정[*]  "<nul) else (set /p "=파일순서 섞기 설정[ ]  "<nul)
echo      ^|
echo *-------------------------------------------------------------------------------*
echo 현재 설정 : [워커코드:%workercode%, 날짜:%setdate%, 실행모드:%mode%, 파일섞기:%mixfile%]
echo ※사용자설정저장:F는 현재 설정을 로컬 파일에 저장합니다.
echo   프로그램을 종료 후 재시작할 때 저장된 설정을 불러옵니다.
echo.
goto inputSettingRenameCode
:SettingRenameSelected
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" set /p workercode=워커코드 : & goto SettingRename
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" set /p setdate=날짜(ex:220628) : & goto SettingRename
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" goto SettingMode
if "(%posMenuX%,%posMenuY%)" equ "(4,1)" goto SettingMix
:SettingMode
set /a MaxX=2
set /a MaxY=1
set /a posMenuX=1
set /a posMenuY=1
goto drawSettingModeScreen
:inputSettingModeCode
choice /c adrq /n >nul
if %errorlevel% equ 1 set /a posMenuX=posMenuX-1 & goto drawSettingModeScreen
if %errorlevel% equ 2 set /a posMenuX=posMenuX+1 & goto drawSettingModeScreen
if %errorlevel% equ 3 goto SettingModeSelected
if %errorlevel% equ 4 goto SettingRename
:drawSettingModeScreen
cls
if %posMenuX% lss 1 set /a posMenuX=MaxX
if %posMenuX% gtr %MaxX% set /a posMenuX=1
echo *-----------------------------------------------------------*
echo ^| 실행모드 설정 [왼쪽:A, 오른쪽:D, 확인:R, 뒤로가기:Q]      ^|
echo ^|-----------------------------------------------------------^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" (set /p "=이름 바꾸기[*]  "<nul) else (set /p "=이름 바꾸기[ ]  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" (set /p "=파일 복사[*]  "<nul) else (set /p "=파일 복사[ ]  "<nul)
echo                             ^|
echo ^|-----------------------------------------------------------^|
echo ^| 이름 바꾸기 실행모드 : 폴더 내에 있는 모든 음원 파일들의  ^|
echo ^| 이름을 소음/소리 데이터 이름양식으로 바꿉니다.            ^|
echo ^| 이름 양식 :                                               ^|
echo ^| [대분류]_[소분류]_[날짜]_[파일번호]_[소음/소리].[확장자]  ^|
echo ^| ex)01_02_220630_001_NN.wav                                ^|
echo ^| -^>소음-교통수단-철로운송수단, 22년 06월 30일에 녹음한 파일^|
echo ^| 중 1번째 웨이브 파일                                      ^|
echo ^| ※음원파일만 이름을 바꿉니다.                             ^|
echo ^| (지원하는 음원파일 형식: mp3, m4a, wav)                   ^|
echo ^|                                                           ^|
echo ^| 파일 복사 실행모드 : 하나의 파일을 지정하여 설정한 소음/소^|
echo ^| 리 데이터 이름양식으로 입력한 개수만큼 복사합니다.        ^|
echo ^| ex)[파일이름].[확장자] -^> 01_03_220701_001.[확장자]       ^|
echo ^| 파일확장자는 원본 파일의 확장자를 따릅니다.               ^|
echo ^| 모든 확장자의 파일에 대하여 복사합니다.                   ^|
echo ^| ※파일 지정 시 원하는 파일의 초성만 입력하고 Tab키를 누르 ^|
echo ^| 면 자동 완성됩니다.                                       ^|
echo ^| ※파일복사 모드는 파일섞기 설정과 함께 작동하지 않습니다. ^|
echo *-----------------------------------------------------------*
goto inputSettingModeCode
:SettingModeSelected
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" set mode=rename& goto SettingRename
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" set mode=copy& goto SettingRename
:SettingMix
set /a MaxX=2
set /a MaxY=1
set /a posMenuX=1
set /a posMenuY=1
goto drawSettingMixScreen
:inputSettingMixCode
choice /c adrq /n >nul
if %errorlevel% equ 1 set /a posMenuX=posMenuX-1 & goto drawSettingMixScreen
if %errorlevel% equ 2 set /a posMenuX=posMenuX+1 & goto drawSettingMixScreen
if %errorlevel% equ 3 goto SettingMixSelected
if %errorlevel% equ 4 goto SettingRename
:drawSettingMixScreen
cls
if %posMenuX% lss 1 set /a posMenuX=MaxX
if %posMenuX% gtr %MaxX% set /a posMenuX=1
echo *-----------------------------------------------------------*
echo ^| 파일순서 섞기 설정 [왼쪽:A, 오른쪽:D, 확인:R, 뒤로가기:Q] ^|
echo ^|-----------------------------------------------------------^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" (set /p "=ON[*]  "<nul) else (set /p "=ON[ ]  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" (set /p "=OFF[*]  "<nul) else (set /p "=OFF[ ]  "<nul)
echo                                            ^|
echo ^|-----------------------------------------------------------^|
echo ^| 이름 바꾸기 실행모드에서 정렬된 파일의 이름을 무작위로 바 ^|
echo ^| 꾼 후 재정렬하여 이름을 바꿉니다.                         ^|
echo ^|                                                           ^|
echo ^| 요약 : 폴더 내의 정렬된 파일의 순서를 무작위로 바꿉니다.  ^|
echo ^| ※파일복사 모드는 파일섞기 설정과 함께 작동하지 않습니다. ^|
echo *-----------------------------------------------------------*
goto inputSettingMixCode
:SettingMixSelected
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" set mixfile=ON& goto SettingRename
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" set mixfile=OFF& goto SettingRename
:SettingSave
cd /d C:\
echo workercode:%workercode%>usersetting.txt
echo setdate:%setdate%>>usersetting.txt
echo mode:%mode%>>usersetting.txt
echo mixfile:%mixfile%>>usersetting.txt
echo backgroundcolor:%bgcolor%>>usersetting.txt
echo textcolor:%textcolor%>>usersetting.txt
echo server:%serverIP%>>usersetting.txt
cd /d "%current%"
echo 현재 설정이 저장되었습니다. & pause>nul
goto Setting
:SettingProgram
rem ##########프로그램 설정//글자색상, 배경색상##########
set /a MaxX=4
set /a MaxY=1
set /a posMenuX=1
set /a posMenuY=1
goto drawSettingProgramScreen
:inputSettingProgramCode
choice /c adrfq /n >nul
if %errorlevel% equ 1 set /a posMenuX=posMenuX-1 & goto drawSettingProgramScreen
if %errorlevel% equ 2 set /a posMenuX=posMenuX+1 & goto drawSettingProgramScreen
if %errorlevel% equ 3 goto SettingProgramSelected
if %errorlevel% equ 4 goto SettingSave
if %errorlevel% equ 5 goto Setting
:drawSettingProgramScreen
cls
if %posMenuX% lss 1 set /a posMenuX=MaxX
if %posMenuX% gtr %MaxX% set /a posMenuX=1
echo *-----------------------------------------------------------------------------*
echo ^| 프로그램 설정 메뉴 [왼쪽:A, 오른쪽:D, 확인:R, 사용자설정저장:F, 뒤로가기:Q] ^|
echo ^|-----------------------------------------------------------------------------^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" (set /p "=텍스트색 바꾸기[*]  "<nul) else (set /p "=텍스트색 바꾸기[ ]  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" (set /p "=배경색 바꾸기[*]  "<nul) else (set /p "=배경색 바꾸기[ ]  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" (set /p "=설정 초기화[*]  "<nul) else (set /p "=설정 초기화[ ]  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(4,1)" (set /p "=서버IP 설정[*]  "<nul) else (set /p "=서버IP 설정[ ]  "<nul)
echo       ^|
echo ^|-----------------------------------------------------------------------------^|
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" echo ^| 터미널의 텍스트 색상을 변경합니다.                                          ^|
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" echo ^| 터미널의 배경 색상을 변경합니다.                                            ^|
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" echo ^| 설정된 텍스트와 배경 색상을 기본값으로 초기화합니다.                        ^|
if "(%posMenuX%,%posMenuY%)" equ "(4,1)" echo ^| 업데이트 서버의 IP를 설정합니다.                                            ^|
echo *-----------------------------------------------------------------------------*
echo 현재 설정된 서버IP : %serverIP%
echo ※사용자설정저장:F는 현재 설정을 로컬 파일에 저장합니다.
echo   프로그램을 종료 후 재시작할 때 저장된 설정을 불러옵니다.
goto inputSettingProgramCode
:SettingProgramSelected
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" goto TextColorSetting
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" goto BgColorSetting
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" set bgcolor=0& set textcolor=7& color 07 & goto SettingProgram
if "(%posMenuX%,%posMenuY%)" equ "(4,1)" set /p serverIP=서버IP(ex:192.168.201.100) : & goto SettingProgram
:TextColorSetting
set /a MaxX=2
set /a MaxY=8
set /a posMenuX=1
set /a posMenuY=1
set backuptextcolor=%textcolor%
goto drawTextColorSettingScreen
:inputTextColorSetting
choice /c wsadrq /n >nul
if %errorlevel% equ 1 set /a posMenuY=posMenuY-1 & goto drawTextColorSettingScreen
if %errorlevel% equ 2 set /a posMenuY=posMenuY+1 & goto drawTextColorSettingScreen
if %errorlevel% equ 3 set /a posMenuX=posMenuX-1 & goto drawTextColorSettingScreen
if %errorlevel% equ 4 set /a posMenuX=posMenuX+1 & goto drawTextColorSettingScreen
if %errorlevel% equ 5 goto TextColorSettingSelected
if %errorlevel% equ 6 set textcolor=%backuptextcolor%& color %bgcolor%%backuptextcolor% & goto SettingProgram
:drawTextColorSettingScreen
cls
if %posMenuX% lss 1 set /a posMenuX=MaxX
if %posMenuX% gtr %MaxX% set /a posMenuX=1
if %posMenuY% lss 1 set /a posMenuY=MaxY
if %posMenuY% gtr %MaxY% set /a posMenuY=1
echo *-------------------------------------------------------------------------*
echo ^| 텍스트 색상 바꾸기 [위:W, 아래:S, 왼쪽:A, 오른쪽:D, 확인:R, 뒤로가기:Q] ^|
echo ^|-------------------------------------------------------------------------^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" (set /p "=검은색[*]    "<nul & set textcolor=0) else (set /p "=검은색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" (set /p "=회색       [*]    "<nul & set textcolor=8) else (set /p "=회색       [ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,2)" (set /p "=파란색[*]    "<nul & set textcolor=1) else (set /p "=파란색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,2)" (set /p "=연한 파란색[*]    "<nul & set textcolor=9) else (set /p "=연한 파란색[ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,3)" (set /p "=녹색  [*]    "<nul & set textcolor=2) else (set /p "=녹색  [ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,3)" (set /p "=연한 녹색  [*]    "<nul & set textcolor=A) else (set /p "=연한 녹색  [ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,4)" (set /p "=청록색[*]    "<nul & set textcolor=3) else (set /p "=청록색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,4)" (set /p "=연한 청록색[*]    "<nul & set textcolor=B) else (set /p "=연한 청록색[ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,5)" (set /p "=빨간색[*]    "<nul & set textcolor=4) else (set /p "=빨간색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,5)" (set /p "=연한 빨간색[*]    "<nul & set textcolor=C) else (set /p "=연한 빨간색[ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,6)" (set /p "=자주색[*]    "<nul & set textcolor=5) else (set /p "=자주색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,6)" (set /p "=연한 자주색[*]    "<nul & set textcolor=D) else (set /p "=연한 자주색[ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,7)" (set /p "=노란색[*]    "<nul & set textcolor=6) else (set /p "=노란색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,7)" (set /p "=연한 노란색[*]    "<nul & set textcolor=E) else (set /p "=연한 노란색[ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,8)" (set /p "=흰색  [*]    "<nul & set textcolor=7) else (set /p "=흰색  [ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,8)" (set /p "=밝은 흰색  [*]    "<nul & set textcolor=F) else (set /p "=밝은 흰색  [ ]    "<nul)
echo                                          ^|
if "%textcolor%" equ "%bgcolor%" (
    echo ^|-------------------------------------------------------------------------^| & echo ^| 텍스트색을 배경색과 같게 지정할 수 없습니다.                            ^|
) else (
    color %bgcolor%%textcolor%
)
echo *-------------------------------------------------------------------------*
goto inputTextColorSetting
:TextColorSettingSelected
if "%textcolor%" equ "%bgcolor%" goto inputTextColorSetting
goto SettingProgram
:BgColorSetting
set /a MaxX=2
set /a MaxY=8
set /a posMenuX=1
set /a posMenuY=1
set backupbgcolor=%bgcolor%
goto drawBgColorSettingScreen
:inputBgColorSetting
choice /c wsadrq /n >nul
if %errorlevel% equ 1 set /a posMenuY=posMenuY-1 & goto drawBgColorSettingScreen
if %errorlevel% equ 2 set /a posMenuY=posMenuY+1 & goto drawBgColorSettingScreen
if %errorlevel% equ 3 set /a posMenuX=posMenuX-1 & goto drawBgColorSettingScreen
if %errorlevel% equ 4 set /a posMenuX=posMenuX+1 & goto drawBgColorSettingScreen
if %errorlevel% equ 5 goto BgColorSettingSelected
if %errorlevel% equ 6 set bgcolor=%backupbgcolor%& color %backupbgcolor%%textcolor% & goto SettingProgram
:drawBgColorSettingScreen
cls
if %posMenuX% lss 1 set /a posMenuX=MaxX
if %posMenuX% gtr %MaxX% set /a posMenuX=1
if %posMenuY% lss 1 set /a posMenuY=MaxY
if %posMenuY% gtr %MaxY% set /a posMenuY=1
echo *-------------------------------------------------------------------------*
echo ^| 배경 색상 바꾸기 [위:W, 아래:S, 왼쪽:A, 오른쪽:D, 확인:R, 뒤로가기:Q]   ^|
echo ^|-------------------------------------------------------------------------^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" (set /p "=검은색[*]    "<nul & set bgcolor=0) else (set /p "=검은색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" (set /p "=회색       [*]    "<nul & set bgcolor=8) else (set /p "=회색       [ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,2)" (set /p "=파란색[*]    "<nul & set bgcolor=1) else (set /p "=파란색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,2)" (set /p "=연한 파란색[*]    "<nul & set bgcolor=9) else (set /p "=연한 파란색[ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,3)" (set /p "=녹색  [*]    "<nul & set bgcolor=2) else (set /p "=녹색  [ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,3)" (set /p "=연한 녹색  [*]    "<nul & set bgcolor=A) else (set /p "=연한 녹색  [ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,4)" (set /p "=청록색[*]    "<nul & set bgcolor=3) else (set /p "=청록색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,4)" (set /p "=연한 청록색[*]    "<nul & set bgcolor=B) else (set /p "=연한 청록색[ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,5)" (set /p "=빨간색[*]    "<nul & set bgcolor=4) else (set /p "=빨간색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,5)" (set /p "=연한 빨간색[*]    "<nul & set bgcolor=C) else (set /p "=연한 빨간색[ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,6)" (set /p "=자주색[*]    "<nul & set bgcolor=5) else (set /p "=자주색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,6)" (set /p "=연한 자주색[*]    "<nul & set bgcolor=D) else (set /p "=연한 자주색[ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,7)" (set /p "=노란색[*]    "<nul & set bgcolor=6) else (set /p "=노란색[ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,7)" (set /p "=연한 노란색[*]    "<nul & set bgcolor=E) else (set /p "=연한 노란색[ ]    "<nul)
echo                                          ^|
set /p "=| "<nul
if "(%posMenuX%,%posMenuY%)" equ "(1,8)" (set /p "=흰색  [*]    "<nul & set bgcolor=7) else (set /p "=흰색  [ ]    "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,8)" (set /p "=밝은 흰색  [*]    "<nul & set bgcolor=F) else (set /p "=밝은 흰색  [ ]    "<nul)
echo                                          ^|
if "%bgcolor%" equ "%textcolor%" (
    echo ^|-------------------------------------------------------------------------^| & echo ^| 배경색을 텍스트색과 같게 지정할 수 없습니다.                            ^|
) else (
    color %bgcolor%%textcolor%
)
echo *-------------------------------------------------------------------------*
goto inputBgColorSetting
:BgColorSettingSelected
if "%bgcolor%" equ "%textcolor%" goto inputBgColorSetting
goto SettingProgram
:MixFiles
set /a Mixskips=skips
set /a Mixnumber=number
set /a Mixlistnum=listnum
for /f "tokens=*" %%i in (%listname%) do (set temp=%%i & goto MixgetNameFirst)
:MixgetNameFirst
for /f "tokens=2 delims=." %%i in (%listname%) do (set fileExt=%%i& goto MixgetExtension)
:MixrenLoop
if %Mixnumber% gtr %Mixlistnum% (dir /b /a:-d > %listname% & exit /b)
for /f "tokens=* skip=%Mixskips%" %%i in (%listname%) do (set temp=%%i& goto MixgetName)
:MixgetName
rem 파일이름에 .을 2개 이상으로 설정할 시 확장자 변경 오류(파일 이름에 .은 1개씩)
for /f "tokens=2 delims=. skip=%Mixskips%" %%i in (%listname%) do (set fileExt=%%i& set /a Mixskips=Mixskips+1 & goto MixgetExtension)
:MixgetExtension
rem ##########지원하지 않는 확장자는 변경X##########
if "%fileExt%" equ "m4a" goto MixallowExtension
if "%fileExt%" equ "mp3" goto MixallowExtension
if "%fileExt%" equ "wav" goto MixallowExtension
goto MixrenLoop
:MixallowExtension
set /a randint=(%random%*%random%*%random%*0x%time:~-2,2%)/17+(%random%*%random%*%random%*0x%time:~-2,2%)/3
ren "%temp%" "%randint%.%fileExt%"
set /a Mixnumber=Mixnumber+1
goto MixrenLoop
:AfterInit
rem ##########선택 옵션##########
if "%mode%" equ "rename" goto renfile
if "%mode%" equ "copy" goto copyfile
:renfile
echo.
set option=rename
rem ##########파일 개수 계산(디렉터리  제외)##########
set /a skips=1
set /a number=1
set /a listnum=0
set /a m4anum=0
set /a mp3num=0
set /a wavnum=0
dir /b /a:-d > %listname%
for /f "tokens=2 delims=." %%i in (%listname%) do ( 
 if "%%i" equ "m4a" set /a listnum=listnum+1 & set /a m4anum=m4anum+1
 if "%%i" equ "mp3" set /a listnum=listnum+1 & set /a mp3num=mp3num+1
 if "%%i" equ "wav" set /a listnum=listnum+1 & set /a wavnum=wavnum+1
)
if %listnum% lss 1 (set option=renError& goto OnDirectory)
echo 현재 폴더의 오디오 파일 개수 : %listnum%
echo (지원하는 오디오 파일 형식 m4a, mp3, wav)
if %m4anum% geq 1 (if %mp3num% geq 1 (goto ContinueProcess))
if %mp3num% geq 1 (if %wavnum% geq 1 (goto ContinueProcess))
if %m4anum% geq 1 (if %wavnum% geq 1 (goto ContinueProcess))
goto inputStartnumber
:ContinueProcess
choice /m "오디오 파일 형식이 섞여있습니다. 계속하시겠습니까?"
if %errorlevel% equ 1 goto inputStartnumber
if %errorlevel% equ 2 goto OnDirectory
rem ##########시작값 입력##########
:inputStartnumber
if "%mixfile%" equ "ON" call :MixFiles
echo.
echo 시작할 번호를 입력해 주세요. (001부터 시작하려면 1을 입력해주세요.)
set /p number=시작 번호 : 
set /a startnumber=number
set /a listnum=listnum+number-1
rem ##########skip=0은 지원하기 않음, skip=1부터 시작##########
for /f "tokens=*" %%i in (%listname%) do (set temp=%%i & goto getNameFirst)
:getNameFirst
for /f "tokens=2 delims=." %%i in (%listname%) do (set fileExt=%%i& goto getExtension)
:renLoop
if %number% gtr %listnum% goto quit
for /f "tokens=* skip=%skips%" %%i in (%listname%) do (set temp=%%i & goto getName)
:getName
rem 파일이름에 .을 2개 이상으로 설정할 시 확장자 변경 오류(파일 이름에 .은 1개씩)
for /f "tokens=2 delims=. skip=%skips%" %%i in (%listname%) do (set fileExt=%%i& set /a skips=skips+1 & goto getExtension)
:getExtension
rem ##########지원하지 않는 확장자는 변경X##########
if "%fileExt%" equ "m4a" goto allowExtension
if "%fileExt%" equ "mp3" goto allowExtension
if "%fileExt%" equ "wav" goto allowExtension
goto renLoop
:allowExtension
rem ##########숫자 형식 설정 001~999 (010 != 8 error)##########
set Fixednumber=%number%
if %number% lss 100 set Fixednumber=0%number%
if %number% lss 10 set Fixednumber=00%number%
ren "%temp%" "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.%fileExt%"
set /a number=number+1
goto renLoop
:copyfile
echo.
set /a startnumber=0
set option=copyname
call :printfilelist
set /p target=복사할 파일 : 
if not exist %target% echo 입력한 파일이 현재 폴더에 없습니다. & pause>nul & goto OnDirectory
set /p number=복사할 개수 : 
set /a number=%number%
if %number% leq 0 echo 복사할 개수는 0보다 큰 숫자만 입력해주세요. & pause>nul & goto OnDirectory
for /f "tokens=2 delims=." %%i in ("%target%") do set fileExt=%%i
:cpLoop
if %number% lss 1 goto quit
set /a calcnumber=number
set Fixednumber=%calcnumber%
if %calcnumber% lss 100 set Fixednumber=0%calcnumber%
if %calcnumber% lss 10 set Fixednumber=00%calcnumber%
rem ===================================================================================================================================================================================
copy /y "%target%" "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.%fileExt%">nul
set /a number=number-1
goto cpLoop
:quit
if %startnumber% lss 100 set Fixednumber=0%startnumber%
if %startnumber% lss 10 set Fixednumber=00%startnumber%
if "%option%" equ "rename" (del /f %listname% & if not exist "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.xlsx" (goto createExcel))
if "%option%" equ "copyname" (echo ########복사 완료!########)
:Exitprogram
choice /c 12 /n /m "1.계속하기 2.종료하기"
if %errorlevel% equ 1 cls & goto OnDirectory
if %errorlevel% equ 2 echo 프로그램을 종료합니다. & pause>nul
endlocal
exit
:createExcel
choice /m "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.xlsx 파일이 없습니다. 새로 만드시겠습니까?"
if %errorlevel% equ 1 goto baseEnCode
:endRename
echo ########이름 재설정 완료!########
goto Exitprogram
:noadmin
echo 관리자 권한으로 실행해주세요.
pause>nul
exit
:baseEnCode
echo 소리 양식 엑셀파일 생성중...
echo UEsDBBQABgAIAAAAIQB+UjBRiAEAAAwGAAATAAgCW0NvbnRlbnRfVHlwZXNdLnht>>temp64
echo bCCiBAIooAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACsVEtPAjEQ>>temp64
echo vpv4Hza9GrbAwRjDwsHHUU3ExGvdDmxDX+kMCP/e2aLEGB4SuOxm2873mM5+g9HS>>temp64
echo 2WIBCU3wleiVXVGAr4M2flqJt/Fj50YUSMprZYOHSqwAxWh4eTEYryJgwdUeK9EQ>>temp64
echo xVspsW7AKSxDBM87k5CcIv5MUxlVPVNTkP1u91rWwRN46lCLIYaDe5iouaXiYcnL>>temp64
echo ayUfxovibn2upaqEitGaWhELlQuv/5B0wmRiatChnjuGLjEmUBobAHK2jMkwY3oF>>temp64
echo IjaGQm7lTGDxONJvVyVXZmHYmIhXbH0HQ7uz29V33TNfRzIaiheV6Ek59i6XVn6G>>temp64
echo NPsIYVbuBzm2NblFpVPG/+jew58Po8yv3pmFtP4y8AEdxDMGMj9Pl5BhDhAirSzg>>temp64
echo udueQQ8xNyqBfiWe3unZBfzG3qejniMF9+6sNATuJYWIp/d9A9riQSIDm99m2/ht>>temp64
echo 0dA/+UKO1MDRks1zeiU4nvwnKtrqTvyX6w0jR9/JbqHNVg16C7fMWT78AgAA//8D>>temp64
echo AFBLAwQUAAYACAAAACEAtVUwI/QAAABMAgAACwAIAl9yZWxzLy5yZWxzIKIEAiig>>temp64
echo AAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKySTU/DMAyG70j8h8j3>>temp64
echo 1d2QEEJLd0FIuyFUfoBJ3A+1jaMkG92/JxwQVBqDA0d/vX78ytvdPI3qyCH24jSs>>temp64
echo ixIUOyO2d62Gl/pxdQcqJnKWRnGs4cQRdtX11faZR0p5KHa9jyqruKihS8nfI0bT>>temp64
echo 8USxEM8uVxoJE6UchhY9mYFaxk1Z3mL4rgHVQlPtrYawtzeg6pPPm3/XlqbpDT+I>>temp64
echo OUzs0pkVyHNiZ9mufMhsIfX5GlVTaDlpsGKecjoieV9kbMDzRJu/E/18LU6cyFIi>>temp64
echo NBL4Ms9HxyWg9X9atDTxy515xDcJw6vI8MmCix+o3gEAAP//AwBQSwMEFAAGAAgA>>temp64
echo AAAhAJ6B1FARAQAA1gMAABoACAF4bC9fcmVscy93b3JrYm9vay54bWwucmVscyCi>>temp64
echo BAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAALxTTUvEMBC9C/6HMHebtuoisuleRNirVvAa>>temp64
echo 2ukH2yQlM6v23xsqdruw1EvxEpg35L2Xl5nt7st04gM9tc4qSKIYBNrCla2tFbzl>>temp64
echo zzcPIIi1LXXnLCoYkGCXXV9tX7DTHC5R0/YkAoslBQ1z/yglFQ0aTZHr0YZO5bzR>>temp64
echo HEpfy14XB12jTON4I/2cA7IzTrEvFfh9eQsiH/qg/De3q6q2wCdXHA1aviAhiYcu>>temp64
echo PEDk2tfICn7qKHgEeVk+XVOeQyx4Uh9LOZ7JkodkTQ+fzh+oQeSTjwkiOXYWzWzW>>temp64
echo NFMciZ15D/FPXxJFckJly2jSpWju/9vNYjZ3q85qoz2Wr+zDKs5Hdg7/RiPPtjH7>>temp64
echo BgAA//8DAFBLAwQUAAYACAAAACEAapqEWa4CAAAxBgAADwAAAHhsL3dvcmtib29r>>temp64
echo LnhtbKxUy26bQBTdV+o/oNkTwAY/kHFkDKiRkihynGRjqRrDYEYGhs6Ma0dRF130>>temp64
echo A7pKV/2D/pk/onfATtymqtzHZh6XO2fuPecMg9NNkWvvCReUlR6yTkykkTJmCS0X>>temp64
echo HrqZRnoPaULiMsE5K4mH7olAp8PXrwZrxpdzxpYaAJTCQ5mUlWsYIs5IgcUJq0gJ>>temp64
echo X1LGCyxhyxeGqDjBicgIkUVutEyzYxSYlqhBcPkxGCxNaUwCFq8KUsoGhJMcSyhf>>temp64
echo ZLQSe7QiPgauwHy5qvSYFRVAzGlO5X0NirQids8WJeN4nkPbG8vZI8PyBXRBY84E>>temp64
echo S+UJQBlNkS/6tUzDspqWh4OU5uS2oV3DVXWJC3VLjrQcCxkmVJLEQx3YsjV5DnSR>>temp64
echo xleVv6I5fLVsu2UiY/gkxRWHDdQ9yiXhJZZkzEoJNO0I/ldKauxxxkAAbULerSgn>>temp64
echo oLtiZjiAEccunosrLDNtxXMPjd3ZjYAOZ9eTWUDEUrJqtv36efv4afvl4/bx2+yA>>temp64
echo UPxSrT+gFMeKBQM6b6pr1j+zMBwou95SshbPlKmttrmjZcLWHgLz3x+s13X4jiYy>>temp64
echo A7b77Q54oIm9IXSRSQ/1LdOp7z6Arg0OV9SzVtbCXivTW/CS1HymtAMhXQoLfpZY>>temp64
echo NcL+WIzz+IpraqoT4YpWX2WQjTwXsp6BYOqhB8s2R12zb+tm2HZ0u9dv6T273dLH>>temp64
echo dtAKnW4YhL7z4f/aFnR29y9fVZlhLqccx0v4X0xI6mMBNm4agnoPi/Wdnm+2oUQ7>>temp64
echo siLdtvqm7vsdW3eCqO10rWAcOtFzsar99C+fWc+oTxMsV+BQZc5676ox2kWfgmkT>>temp64
echo 2On0g+ncSaB4353+XeI1dJ+TI5Oj2yMTx5cX04sjc8/D6du76Njk0YUfjHb5xi/Z>>temp64
echo MWr11Fh7zthrPvwOAAD//wMAUEsDBBQABgAIAAAAIQD9W4rxUgEAAFoDAAAUAAAA>>temp64
echo eGwvc2hhcmVkU3RyaW5ncy54bWykk01LAzEQhu+C/yHkbpNu8ZPsFrptpQeLuO15>>temp64
echo CbtpN7BJ1k1a7U20XkQQD0IP6knBYwv+Krv9D8YPpGf3ODPMM897GFI/FykYs1xz>>temp64
echo JV1YrWAImIxUzOXQhf1ee2sPAm2ojGmqJHPhhGlY9zY3iNYG2F2pXZgYkx0gpKOE>>temp64
echo CaorKmPSTgYqF9TYMh8ineWMxjphzIgUORjvIEG5hCBSI2ns3SoEI8lPR8z/a3hE>>temp64
echo c48Y76Tlh0Gvc9QiyHgkS6yG4dFxDgZKmk5slyEwk8y6SeUr+ZsFIo+gL8APJIib>>temp64
echo bMwjVo7hKyGYNOUgWUp/Pdb8DvuNMOg3gmYZdpunLOxSUSolroW4Gu5jJ3QcvOts>>temp64
echo hxjbOuhWzuj4W27NGtfK6K4e35e3F6u7eRmIgy0DLC/fiumieJqB1cP9x2Je3Lws>>temp64
echo r65Lyc2mxfPr/wjI/ob3CQAA//8DAFBLAwQUAAYACAAAACEAO20yS8EAAABCAQAA>>temp64
echo IwAAAHhsL3dvcmtzaGVldHMvX3JlbHMvc2hlZXQxLnhtbC5yZWxzhI/BisIwFEX3>>temp64
echo A/5DeHuT1oUMQ1M3IrhV5wNi+toG25eQ9xT9e7McZcDl5XDP5Tab+zypG2YOkSzU>>temp64
echo ugKF5GMXaLDwe9otv0GxOOrcFAktPJBh0y6+mgNOTkqJx5BYFQuxhVEk/RjDfsTZ>>temp64
echo sY4JqZA+5tlJiXkwyfmLG9Csqmpt8l8HtC9Ote8s5H1Xgzo9Uln+7I59Hzxuo7/O>>temp64
echo SPLPhEk5kGA+okg5yEXt8oBiQet39p5rfQ4Epm3My/P2CQAA//8DAFBLAwQUAAYA>>temp64
echo CAAAACEAyrtG2FgHAADHIAAAEwAAAHhsL3RoZW1lL3RoZW1lMS54bWzsWVuLGzcU>>temp64
echo fi/0Pwzz7vg248sSp/iaTbK7CVknpY9aW/ZoVzMykrwbUwIlpdBCKRTS0pdC3/JQ>>temp64
echo SgsttPSlP2YhoU37H3qkGXuktdzcNiUtu4bFI3/n6Oico09nji6/cy+m3jHmgrCk>>temp64
echo 5ZcvlXwPJyM2Jsm05d8ZDgoN3xMSJWNEWYJb/gIL/50rb791GW3JCMfYA/lEbKGW>>temp64
echo H0k52yoWxQiGkbjEZjiB3yaMx0jCI58WxxydgN6YFiulUq0YI5L4XoJiUHtzMiEj>>temp64
echo 7P310adPH33sX1lq71OYIpFCDYwo31e6sSWiseOjskKIhehS7h0j2vJhojE7GeJ7>>temp64
echo 0vcoEhJ+aPkl/ecXr1wuoq1MiMoNsobcQP9lcpnA+Kii5+TTg9WkQRAGtfZKvwZQ>>temp64
echo uY7r1/u1fm2lTwPQaAQrTW2xddYr3SDDGqD0q0N3r96rli28ob+6ZnM7VB8Lr0Gp>>temp64
echo /mANPxh0wYsWXoNSfLiGDzvNTs/Wr0EpvraGr5favaBu6degiJLkaA1dCmvV7nK1>>temp64
echo K8iE0W0nvBkGg3olU56jIBtW2aWmmLBEbsq1GB0yPgCAAlIkSeLJxQxP0AjSuIso>>temp64
echo OeDE2yHTCBJvhhImYLhUKQ1KVfivPoH+piOKtjAypJVdYIlYG1L2eGLEyUy2/Oug>>temp64
echo 1Tcgj3/55fTBT6cPfj798MPTB99nc2tVltw2Sqam3NNHn//59QfeHz9+8/ThF+nU>>temp64
echo Z/HCxD/57pMnv/72T+phxbkrHn/5w5Offnj81We/f/vQob3N0YEJH5IYC28Pn3i3>>temp64
echo WQwLdNiPD/iLSQwjRCwJFIFuh+q+jCzg3gJRF66DbRfe5cAyLuDV+aFl637E55I4>>temp64
echo Zr4RxRZwlzHaYdzpgBtqLsPDw3kydU/O5ybuNkLHrrm7KLEC3J/PgF6JS2U3wpaZ>>temp64
echo tyhKJJriBEtP/caOMHas7j1CLL/ukhFngk2k9x7xOog4XTIkB1Yi5ULbJIa4LFwG>>temp64
echo Qqgt3+ze9TqMulbdw8c2ErYFog7jh5habryK5hLFLpVDFFPT4TtIRi4j9xd8ZOL6>>temp64
echo QkKkp5gyrz/GQrhkbnJYrxH0G8Aw7rDv0kVsI7kkRy6dO4gxE9ljR90IxTOnzSSJ>>temp64
echo TOw1cQQpirxbTLrgu8zeIeoZ4oCSjeG+S7AV7mcTwR0gV9OkPEHUL3PuiOVVzOz9>>temp64
echo uKAThF0s0+axxa5tTpzZ0ZlPrdTewZiiEzTG2LtzzWFBh80sn+dGX4+AVbaxK7Gu>>temp64
echo IztX1XOCBfZ0XbNOkTtEWCm7j6dsgz27izPEs0BJjPgmzXsQdSt14ZRzUulNOjoy>>temp64
echo gXsE6j/IF6dTbgrQYSR3f5PWWxGyzi71LNz5uuBW/J5nj8G+PHzRfQky+IVlgNif>>temp64
echo 2zdDRK0J8oQZIigwXHQLIlb4cxF1rmqxuVNuYm/aPAxQGFn1TkySZxY/Z8qe8N8p>>temp64
echo e9wFzDkUPG7Fr1LqbKKU7TMFzibcf7Cs6aF5cgvDSbLOWRdVzUVV4//vq5pNe/mi>>temp64
echo lrmoZS5qGdfb12upZfLyBSqbvMujez7xxpbPhFC6LxcU7wjd9RHwRjMewKBuR+me>>temp64
echo 5KoFOIvga9ZgsnBTjrSMx5l8l8hoP0IzaA2VdQNzKjLVU+HNmICOkR7WvVR8Rrfu>>temp64
echo O83jXTZOO53lsupqpi4USObjpXA1Dl0qmaJr9bx7t1Kv+6FT3WVdGqBkX8QIYzLb>>temp64
echo iKrDiPpyEKLwT0bolZ2LFU2HFQ2lfhmqZRRXrgDTVlGBV24PXtRbfhikHWRoxkF5>>temp64
echo PlZxSpvJy+iq4JxrpDc5k5oZACX2MgPySDeVrRuXp1aXptpzRNoywkg32wgjDSN4>>temp64
echo Ec6y02y5n2esm3lILfOUK5a7ITej3ngdsVYkcoYbaGIyBU28k5Zfq4ZwrTJCs5Y/>>temp64
echo gY4xfI1nkDtCvXUhOoV7l5Hk6YZ/GWaZcSF7SESpwzXppGwQE4m5R0nc8tXyV9lA>>temp64
echo E80h2rZyBQjhjTWuCbTyphkHQbeDjCcTPJJm2I0R5en0ERg+5Qrnr1r85cFKks0h>>temp64
echo 3PvR+MQ7oHN+G0GKhfWycuCYCLg4KKfeHBO4CVsRWZ5/Zw6mjHbNqyidQ+k4orMI>>temp64
echo ZSeKSeYpXJPoyhz9tPKB8ZStGRy67sKDqTpgX/nUffZRrTxnkGZ+Zlqsok5NN5m+>>temp64
echo vkPesCo/RC2rUurW79Qi57rmkusgUZ2nxDNO3ec4EAzT8sks05TF6zSsODsbtU07>>temp64
echo x4LA8ERtg99WZ4TTEy978oPc2axVB8SyrtSJr+/MzVttdnAI5NGD+8M5lUKHEu6s>>temp64
echo OYKiL72BTGkDtsg9mdWI8M2bc9Ly3y+F7aBbCbuFUiPsF4JqUCo0wna10A7Darkf>>temp64
echo lku9TuU+HCwyisthel8/gCsMushu7fX42s19vLyluTRicZHpm/miNlzf3Jcrrpv7>>temp64
echo obqZ9z0CpPN+rTJoVpudWqFZbQ8KQa/TKDS7tU6hV+vWe4NeN2w0B/d971iDg3a1>>temp64
echo G9T6jUKt3O0WglpJmd9oFupBpdIO6u1GP2jfz8oYWHlKH5kvwL3arit/AwAA//8D>>temp64
echo AFBLAwQUAAYACAAAACEA4ao/RhYEAAA1EQAADQAAAHhsL3N0eWxlcy54bWzMWM1u>>temp64
echo 20YQvhfIOxB7p0lKJE0KooLIMoEAaVHALtDrilxKi+yPQK4cKkWBvEKA9tYCPRTo>>temp64
echo A/StmvQdMssfkZLtSHHiKBeL+zfzzTezM7MePy05M25IXlApIuSc2cggIpEpFYsI>>temp64
echo /XQdmwEyCoVFipkUJEIbUqCnkyffjQu1YeRqSYgyQIQoIrRUajWyrCJZEo6LM7ki>>temp64
echo AlYymXOsYJgvrGKVE5wW+hBn1sC2fYtjKlAtYcSTY4RwnL9cr8xE8hVWdE4ZVZtK>>temp64
echo FjJ4Mnq+EDLHcwZQS8fFiVE6fj5oNVRTt5RwmuSykJk6A6GWzDKakNtYQyu0cNJJ>>temp64
echo ArEPk+R4lj2oDZ+MMylUYSRyLVSENE4NevRSyFci1kvgE1TvmoyL18YNZjAzQNZk>>temp64
echo nEgmc0MB2WCro2cE5qTe8e6ft+//fGP89+9f7377XS9lmFO2qRfr00ucF+C7RmCo>>temp64
echo N1WeayRwCjzqSUsj3EcQPLa6SmsBailjW3pczQRMTMbgeUVyEcPAaL6vNyvgQUCQ>>temp64
echo 1qirfQd2L3K8cQbe8QcKyWiqUSwu+uyfI0NR7UD77DwMw8DxgyAI3aHjuhXZ82Y7>>temp64
echo FSkpSRoh36109szQRB8D+R4E4RdEUAEB7ucyTyExtMF5DnbXU5MxI5mC2MjpYql/>>temp64
echo lVzB37lUCu7PZJxSvJACMx097Yn+SUgokDsipJZw99tA3udGq2g0HLW/wlJBabdz>>temp64
echo ktI1v1cBgG4xH3miNvDk9m2pPoqXxwZ9gOVv0C0HEB8KPLxWskm4Vmfdx53SP/PN>>temp64
echo OORx4+gzWd5PByeOoyaPQVZMCGNXOn/9nG1Toy7RZWaINY+5eg75HbooXTbbT0js>>temp64
echo zWedBuvBZIwZXQhOBJRhkiua6OKewJDUlbfMIIH29dXae4qDByk2yuwTEBxh2BAZ>>temp64
echo nWEuNDGNfAOvVmyjq7S+MPVoWlWVuq05wv5PpVW3UDvaO321/mct5/sQljKnr8Fp>>temp64
echo PSfc75YdWC5U30PuvoXrhzWfkzyuuuO72DkpWm+fxZOhvfsmAZtdwPm3Ag682FF6>>temp64
echo X/h9bYJ3MMNt2A3TuwnWT4ATWnIE+XD19277V4dcpUhIir3cvJOZtxnU0A+kCP3/>>temp64
echo 9o/3f7/p4Z6vKYP+vc6JumndngCZadnleVt37Uq/LqsKsNUCPKUkw2umrreLEeq+>>temp64
echo v686UQiAZteP9EaqSkSEuu8Xupt2fK2DlOpFAe0v/BrrnEbol8vpeTi7jAdmYE8D>>temp64
echo 0x0Szwy96cz03IvpbBaH9sC++LX3zP2MR271JIeC5rijgsFTOG+MbcBfdXMR6g1q>>temp64
echo +NW7BmD3sYcD337mObYZD23HdH0cmIE/9MzYcwYz351eerHXw+498FltW47TPqtL>>temp64
echo xxspygmjovVV66H+LDgJhh8xwmo9YXX/75h8AAAA//8DAFBLAwQUAAYACAAAACEA>>temp64
echo FqrkHPcCAAAOBwAAGAAAAHhsL3dvcmtzaGVldHMvc2hlZXQxLnhtbIxV2Y7aMBR9>>temp64
echo r9R/iPI+2WDYBIymUNR5aFWVLs/GcYhFEqe2gZn5+h7bScoyGvGCY3zuuecuvp4+>>temp64
echo PJeFd2BScVHN/DiIfI9VVKS82s78Xz9XdyPfU5pUKSlExWb+C1P+w/zjh+lRyJ3K>>temp64
echo GdMeGCo183Ot60kYKpqzkqhA1KzCSSZkSTS2chuqWjKSWqOyCJMoGoQl4ZXvGCby>>temp64
echo Fg6RZZyypaD7klXakUhWEA39Kue1atlKegtdSeRuX99RUdag2PCC6xdL6nslnTxt>>temp64
echo KyHJpkDcz3Gf0Jbbbq7oS06lUCLTAehCJ/Q65nE4DsE0n6YcEZi0e5JlM/8xnqwS>>temp64
echo P5xPbX5+c3ZUJ9+eJps1KxjVLEWZfO9ViHJNiZE2uj/ZfjP5LtyfpkQbIXaG7Alm>>temp64
echo EbwqS2K8Eqr5gS1YAfQiQZX/Wh34hIiwU3H63Spa2aJ+l17KMrIv9EIUf3iqcyiL>>temp64
echo guFw2Ov3hhDVnP4Qxy+Mb3ON42GQ4MDmb5K+LJmiqCKUBT3jlYoCLvDrldx0I4pA>>temp64
echo nu16dPQ96NwwpVfckPke3SstytZ3Q+GMgbTGWBvjJAqSeGSE3UjRayiwthTjk/Bu>>temp64
echo ZOk3LFgblhiENxpDrI0Ca5uCURvFO8EPGjOsrfJR0O/H/Whg8v++89CVwXbAkmgy>>temp64
echo n0px9HA7kXBVE3PX4wmYbUExHnTO6e6TcBV5q7T36DtqCB4Nw8yHAoAV/j3M76fh>>temp64
echo AS1GG8QnhwB7h4jOEYtrRHyOWF4j+ueIz9eI5ByxcojhiY5ehwiRjy4p5uacJOXN>>temp64
echo 1m7DN1ibxi64wUX4DpHY1MSXkbeH/3MzuojcIdBenYPhReTXiPFF5A6Bbu04ToS4>>temp64
echo 0N10cL1R53gXNKeYBpmotJkzyJ1+qTGZKrEQVfO4mMtZky37SuSWV8orWGYvPlIs>>temp64
echo 3XDA6IChqM04sLdUaFzudpfj6WDoITMq4EnodtPwrpne115NaibX/BXOx74nJMd4>>temp64
echo sW/DzK+F1JJwDX8TDpXyKY3tqOtesvk/AAAA//8DAFBLAwQUAAYACAAAACEAthMO>>temp64
echo obsBAAB9BAAAGAAoAGN1c3RvbVhtbC9pdGVtUHJvcHMyLnhtbCCiJAAooCAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC0lN1q3DAQhe8LfYdF97L8bznE>>temp64
echo G5r1FgINlDaF3MrSaNfUkowkd1tK372ykxKSbNiWtldmLOacmeNPPr/4qobVF7Cu>>temp64
echo N7pBSRSjFWhuRK93Dfp08xZTtHKeacEGo6FB2qCL9etX58KdCeaZ88bClQe1Ci/6>>temp64
echo 8LxqG/R9uy3STbwtMaVthXO6rTGts0tcpellFrfpJt20P9AqWOsg4xq09348I8Tx>>temp64
echo PSjmIjOCDofSWMV8KO2OGCl7Dq3hkwLtSRrHJeFTsFe3akDreZ677g8g3eNyHm2y>>temp64
echo /TMX1XNrnJE+4kbdG9wJK/Bs3o5wo32wu/k2AiL/THW0YUHre3Bkdnrjve27yYM7>>temp64
echo 5XE4HKJDtuQRAkjI7fW7j0tk/2W4F0XLrBOFpBnOKtHhvASJa4gznFdQ1SIucyiK>>temp64
echo F5tT2eUSigTHrKI4L2iOaZylWHZ1UQDQjkP99+uIe1CumWY7WJDx4SOeTPgXgUfZ>>temp64
echo 6LU0I/P7GZKKvGfWa7CbgIg1w28rH2F7ZPxzmPIZexbwAyqnMhknOyxkCE5gWFZ2>>temp64
echo JIkS8ieNHqxyJzuOh9SHq2I1G4jpxOxJnlzJuX70y1j/BAAA//8DAFBLAwQUAAYA>>temp64
echo CAAAACEAXJYnIsMAAAAoAQAAHgAIAWN1c3RvbVhtbC9fcmVscy9pdGVtMi54bWwu>>temp64
echo cmVscyCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAITPwWrDMAwG4Huh72B0X5z2MEqJ>>temp64
echo 00sZ5DZGC70aR0lMY8tYSmnffqanFgY7SkLfLzWHe5jVDTN7igY2VQ0Ko6Pex9HA>>temp64
echo +fT1sQPFYmNvZ4po4IEMh3a9an5wtlKWePKJVVEiG5hE0l5rdhMGyxUljGUyUA5W>>temp64
echo SplHnay72hH1tq4/dX41oH0zVdcbyF2/AXV6pJL8v03D4B0eyS0Bo/wRod3CQuES>>temp64
echo 5u9MiYts84hiwAuGZ2tblXtBt41++6/9BQAA//8DAFBLAwQUAAYACAAAACEAdD85>>temp64
echo esIAAAAoAQAAHgAIAWN1c3RvbVhtbC9fcmVscy9pdGVtMS54bWwucmVscyCiBAEo>>temp64
echo oAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAITPwYoCMQwG4LvgO5Tcnc54EJHpeFkWvIm44LV0>>temp64
echo MjPFaVOaKPr2Fk8rLOwxCfn+pN0/wqzumNlTNNBUNSiMjnofRwM/5+/VFhSLjb2d>>temp64
echo KaKBJzLsu+WiPeFspSzx5BOrokQ2MImkndbsJgyWK0oYy2SgHKyUMo86WXe1I+p1>>temp64
echo XW90/m1A92GqQ28gH/oG1PmZSvL/Ng2Dd/hF7hYwyh8R2t1YKFzCfMyUuMg2jygG>>temp64
echo vGB4t5qq3Au6a/XHf90LAAD//wMAUEsDBBQABgAIAAAAIQBN8/5ItAEAAPwEAAAn>>temp64
echo AAAAeGwvcHJpbnRlclNldHRpbmdzL3ByaW50ZXJTZXR0aW5nczEuYmlu7FPNbtNA>>temp64
echo EP7sRAiEBJw4oB4iTlwiNdRt1KOTbamj+gf/oF5NMpSVXK+1XlctVd8DwQv0LXgR>>temp64
echo 3gVm3UQCCSGBeuDArmZnPJ7vm5n9OUKCXUzxklcf+xjhBY7YN0KMdzwlliAsWAz7>>temp64
echo Emgo1tMeAR7OcHDvK0bDwRe4Dh7g00Pv/goOHuPEdVmfuANefXg2+I6Gs+ax2rU1>>temp64
echo sHzj8SrIfkojgqh4jhtnONzCs6efg9+lf7T+aWvu+/oheJPvDlv4T/UP7sCfnPMN>>temp64
echo B2dhvrBtPMFH5wozfhMT7PGc4JDv+7i/9QJztjzsQLB3zFHzPmrMnn327fCcsp6s>>temp64
echo 398urpkxqJvOzGSNwzgNs7hI5wdIDzJxfIyilppaayVlQzqTHwi+xx+nNFN6Rbqi>>temp64
echo tkWkakJIK1nmlw0hy/1I+KlA3JkNc7mkosFCvbXQ2CKR0jnplhBrSbUpjVQ1kjjN>>temp64
echo Uz/I+wy38NddWUlzyUn0WVlhrqqqNIyKLFtUNAkXuMELrnbZE6Xy9L2ZKWPUGUTX>>temp64
echo VHSBKI64L2pV1fUhIgn2trcvWCyp0qFa0a3117dli5FvPBH+6my/AwAA//8DAFBL>>temp64
echo AwQUAAYACAAAACEAvYRiI5AAAADbAAAAEwAoAGN1c3RvbVhtbC9pdGVtMS54bWwg>>temp64
echo oiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbI47DsIwEAWv>>temp64
echo gtKTLejQ4jSBClHlAsY4iqWs1/IuH98eB0GBlHqeZh52JLx1HNVHHUryncETZxo8>>temp64
echo pdmql82L5iiHZlJNewBxkycrLQWXWXjU1jGBTDb7xCEqPHbwtWm1wVhd0hjsg1Rf>>temp64
echo MT27O9XUOVyzzWVJIfwgHm9B1ycfghf/XMcLQPg7bt4AAAD//wMAUEsDBBQABgAI>>temp64
echo AAAAIQCT2dfq8wAAAE8BAAAYACgAY3VzdG9tWG1sL2l0ZW1Qcm9wczEueG1sIKIk>>temp64
echo ACigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGSQwWrDMBBE74X+>>temp64
echo g9m7LTWJ5STYDjWOIdfSQq9CXscCS2skObSU/ntlekp7WmaHnTdsefowU3JD5zXZ>>temp64
echo Cp4yDglaRb221wreXrt0D4kP0vZyIosVWIJT/fhQ9v7YyyB9IIeXgCaJCx3npa3g>>temp64
echo qytEk28Knord8zbdifacNoKf00ORd4If8qZt99+QRLSNMb6CMYT5yJhXIxrpM5rR>>temp64
echo RnMgZ2SI0l0ZDYNW2JJaDNrANpwLppaIN+9mgnrt83v9goO/l2u1xel/FKOVI09D>>temp64
echo yBQZ5kfpcCYdw29bpsiGyAmfM7K1hgdWl+wPZNV3T6h/AAAA//8DAFBLAwQUAAYA>>temp64
echo CAAAACEASY52fpwBAAATAwAAEAAIAWRvY1Byb3BzL2FwcC54bWwgogQBKKAAAQAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAACcksFO3DAQhu+VeIfId9ZZWiG0cozQUsShVVfahbvrTDYW>>temp64
echo jm3ZQ7TbW68tbwCP0AfgoeAdOknEkoWeepuZ/9fvz2OL001jsxZiMt4VbDrJWQZO>>temp64
echo +9K4dcGuVheHJyxLqFyprHdQsC0kdioPPohF9AEiGkgZRbhUsBoxzDhPuoZGpQnJ>>temp64
echo jpTKx0YhtXHNfVUZDede3zbgkB/l+TGHDYIroTwMu0A2JM5a/N/Q0uuOL12vtoGA>>temp64
echo pTgLwRqtkG4pvxodffIVZp83GqzgY1EQ3RL0bTS4lbng41YstbIwp2BZKZtA8NeB>>temp64
echo uATVLW2hTExStDhrQaOPWTI/aG1HLPuuEnQ4BWtVNMohYXW2oelrGxJG+XR/9/zz>>temp64
echo z9Pvh+dfj4KTZRj35dg9rs0nOe0NVOwbu4ABhYR9yJVBC+lbtVAR/8E8HTP3DAPx>>temp64
echo gLOsAXA4c8zXX5pOepM9901QbkvCrvpi3E26Cit/rhBeFro/FMtaRSjpDXYL3w3E>>temp64
echo Je0y2i5kXiu3hvLF817onv96+ONyejzJP+b0sqOZ4K+/Wf4FAAD//wMAUEsDBBQA>>temp64
echo BgAIAAAAIQB1elGgSAEAAFgCAAARAAgBZG9jUHJvcHMvY29yZS54bWwgogQBKKAA>>temp64
echo AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAACEkl9LwzAUxd8Fv0PJe5s0++MIbQcqe3IgOlF8C8nd>>temp64
echo VmzSkES7fXvTdqsdCj7mnnN/99xLsuVBVdEXWFfWOkdpQlAEWtSy1LscvWxW8QJF>>temp64
echo znMteVVryNERHFoW11eZMEzUFh5tbcD6ElwUSNoxYXK0994wjJ3Yg+IuCQ4dxG1t>>temp64
echo FffhaXfYcPHBd4ApIXOswHPJPcctMDYDEZ2QUgxI82mrDiAFhgoUaO9wmqT4x+vB>>temp64
echo KvdnQ6eMnKr0RxN2OsUds6XoxcF9cOVgbJomaSZdjJA/xW/rh+du1bjU7a0EoCKT>>temp64
echo ggkL3Ne2oAsypRkeVdrrVdz5dTj0tgR5eyyenzL8uxowXeqeBTIKOVif+qy8Tu7u>>temp64
echo NytUUEJpTOYxpRuyYGTGpvP3duhFf5urL6jT6H+JNzGdbQhhZMLS2Yh4BhRd7su/>>temp64
echo UHwDAAD//wMAUEsDBBQABgAIAAAAIQDSjhGnCAoAABIvAAATACgAY3VzdG9tWG1s>>temp64
echo L2l0ZW0yLnhtbCCiJAAooCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AADsWkuP3MYRvhvwfyCYM5eP4cxwBhoZ0qyUCJEswbtxcjOa3c0dRhxyzMfuLIwA>>temp64
echo CuQABuRDgMCADzKgQwIjQYIc7CQ6JH/Is/oPqe7mm/MgOXIcBJEO0nBY1dXV1V9V>>temp64
echo fTW33lsvPemShpEb+DNZP9Fkifo4IK5/MZOT2FEs+b3bt3A8xYEfUz8+v17RM7yg>>temp64
echo SyTBw49msiwtUf5v6aX30ZLO5M2fX998+pK/U/ruwelM1taaDn+1++PRXe3u6V1d>>temp64
echo H5jzkWlMxqaha9Z4ML9vzc17p3XZD3NbwVRYuqT2lEY4dFcx38rN888ksfrmD/+U>>temp64
echo Nl9/vvndXzYvPtu8+P1JXe4MByuwlT9OXcEspBPbMbCtmcSiyBkbJpkQOrJH2hBP>>temp64
echo DKIPZAl850dTHM/kRRyvpqoacc9EJ0sXh0EUOPEJDpZq4DgupqqhaSN1SWNEUIzU>>temp64
echo kt2ZoiXqo2gVgvVh7NKIK78Tx6FrJzGN5NvvvnNrHZGpsEqKUXhBY3Yu0Qph2HB3>>temp64
echo o4u1uLPCIIC9x2FC+UfHpR6JmOucAUbUNqzRaGAYY2oR0zGMiWkalBrUcQxZ8iND>>temp64
echo RI0fDcR/hDPB3tywq6urk6vBSRBeMN/p6i8ePRShlzlsHbV/d3XsfoV9YPdMHg1s>>temp64
echo MnSsgTIYE1sxR9RRJlQbKOaYjidEG5l0OMxshP3NZMOxTYcOdUVDY0sxh5apWNrA>>temp64
echo UBx7MhxSatmYTvLjcperIIwlvzioVuup2XE35Vstn8tTjy7hpnMDZnLpyLMFIKZX>>temp64
echo Hl0zKMhDjH6cAG7kn6s6SIATpvIR8tEFV55vdosu5HmZ2kxNSJ2ZzELmESUuOqPh>>temp64
echo JVyoR+lVgthz/ccYJyGEgyY39rFV+D6K4s4KPOyMR44+HGJKTEKwbWqTMeCWA/E+>>temp64
echo GBhOS0sG03O0nqMYL+54Xi/rH88/6CX3Y+rTEDGAPHeX7NJ2d9y9SzjIn6BoMQ9I>>temp64
echo Ww2D6dkChZT83I0XP4sAwFs7qpA7hdN2va2SKgO5NGr4/2tBxZ+locQii3+OShHb>>temp64
echo Xojj+yFcbQcPqUH3g3B5Sh2UeAClHyfIcwFGSYFw3xMckmWBnYezVvMCqzHcfjgN>>temp64
echo gYor3A5dXd8JViheMDwfq09QGEM8zqGyCAM42t0A1jpT7TR0Dzq2Ub7f8B3QuQOs>>temp64
echo 0NT1CV3PZAvSoOt5yPYgGedZlLjRykPXon7aqWLhEkKhYsvFXCjPQh95B+RCishj>>temp64
echo 37tOJfNQhqTh0TKihzSCQgIzrJBsFIGFEDLT94OYCoQVl6giVr9n7FpWE0F5OzUE>>temp64
echo zr0y6eaVhpoOnmnI/rDeaZFeci/p+lY3xWgd+MEyO15WIFcDo9UamZb7rKBrBtSD>>temp64
echo JWTxc3TBwBhNK/F689W3m7++vvn6mfTm+cvv/vFalIl5zDnIi0q14gMAt0+GaVJV>>temp64
echo WFZVWFpVWF5Vyon1V1xPZtYjwEq3FPpRtGKanIlh2JozVAjU6FCVQbllW4al2IjY>>temp64
echo CNsjCw1NoYeGyzMaMxltYukmJgNlOLKo4tCJprAnikVGhu44lmNbQgb5eBGEfBkb>>temp64
echo 9Dj2QMEDqoOIpStoPB4pGJn2aKKbFjYBvsExUJZXLmj0U3p9FYTMUu6GHuUUL2VW>>temp64
echo eHoOO6inQlhynVVBunxbZLljs97+KyzKkCImoSU6BGj31nGIcEyJdE7XMffTbuTK>>temp64
echo 9L+Na5l5G7z0kPoX8UK6RF4CsGZArc4BnMNXCfaKUuEIlGtUXIW3ILC6wP8WTR2g>>temp64
echo bov0kV7l51c4LjrCSfWasvARtFFdfNRU1MFFTeH/pIdEPm1VX7Zq56T/15f/6/Vl>>temp64
echo tYssLg2jVw7UlSDK6wSJt6ES9KHSPPCSpc8RuXFpPDeC7uQTQiZjy8BIGekmZNiJ>>temp64
echo rbHkipXBxJoQx9J1zdBEqq5iet3QaBFc8dpiJmdt8ClwYnztK2p35Eu2UAjpI9ZZ>>temp64
echo QLeaswlr+MSIzlJBy2uJ+SIAPuFhEDxNVgVrtpfS+JAlD1liXZCojFPpchZOfDtI>>temp64
echo oNRn5UC50a6fTglE600p5Ehhcp6Mmltr070283izIy8CaHQ4gL775m83L19Jm8+f>>temp64
echo 3Tz/9ZY0vk39Djg96vwYncDPsOW5sfcfQBdaP5JS8VQcW2/C67To4bIY4UQsdFT+>>temp64
echo xSHygxF/M/kOxhA8UKSWg4xb3yqcmgeeKmQ9XjubjqBJfogwLgiiIpDHhwP55tPX>>temp64
echo m78/k25efbH55ltJhPXeeC6v819dmHaoKGoUCOtcgNhxgJpCccQJeJgYPIWurzHE>>temp64
echo CKlSHgocKDpQNpyosF6JX+K9bC/AT3NC7EdA66UkU4Nh6m9lr1EDdJypm3bOJRTX>>temp64
echo j2LoFOGCiSVIwYutktDjniRYTb0UqfqJrhbvAoFTYuXKAvyb/M0AWK4DfFuWf9XA>>temp64
echo Jod5tT22CW7wYYA5a5yvShLbc2FOGFK+p5RBVGHXkfox7BD4vYGqmapmqASfABgV>>temp64
echo tHxzPJG6dduG38by3HlVG6qsFNvGk3yKloHj/Pyj2hc5zVfKWOmUpPlyljt2TTMI>>temp64
echo nmKAjzgI96Qifcc0g0AHDbEiNDTriwoTsH0eAsu7QCDGjG3uaIHIT5X5ZbW8qSyf>>temp64
echo lkiV9JcDtBjhVhmkf3355je/vXn9Snrz5Rc3L77a6YFp7MZefQJRJUEE/cW5VsHi>>temp64
echo VFd69XLzpz/u1h8l9i8pZhxFpXhr51xSzKK7KRDefSqoov0cT9O1O8/aQ/5FAvjd>>temp64
echo xxa4+vQiCK/3yrawRewsHbC/HWUhvXRZQd9RW343fT+IObBlT7L5QfZQ2vHnfOFG>>temp64
echo gkCSgMx3mYsiKV5QyU+WNg2lwJEidAnPglDKjIxOpHN4A61WHhNgfQgoAcJpFUBX>>temp64
echo AkMACRKulKzg5wFQJYK2fAnkwHWXKMKLXNnJu+9sM02wfvVdiKeostvDZL3HRqTw>>temp64
echo SxA2j7p79Olz6jLDrWWqtlc4iqbuDA4u6XU/Wo0LReIRYXHUDyj2T44OsTQtCqa3>>temp64
echo OYFLy5ZWv6tIfVNNpU9guAvXMf2u0dlNy1PXdZRPhzJeu9I3VWCX89nZ+7WlM+lS>>temp64
echo y9RXVnRH+6Uhfir7YJ+bE+cdtgoQ3NofTtnADdrDfVvd0RsyizoKV/vA9uJ3T+d3>>temp64
echo oijALkAeuQcFRHzd+7hBV6phd44tdeMMxspurR8EfJvfFwBK+MkIjErEAvmvnlLv>>temp64
echo 5u+lobRPrrXI2XUU0+WDtAdgS7YWzVwKSWGXXKswK/YhIqW++zxNVw98tzvqagrq>>temp64
echo oJuGLb7paUvdVS3VVHGqiLy+UCU8exxgCR1ZwHxAHRqyH1HVsmIb6Es1EZgKd4a+>>temp64
echo TBZo496yMPnrLctK83KF3WW/MB/63sF6y0kL2rcL6u486t6q2Fn3F4bD7i8Mp91f>>temp64
echo GI67vzCcd3dhMS3ve9GZdHvG+FCO6lEs5AYcswOeVbrfM752nXBuXNC3UBGxhYSN>>temp64
echo /c634Mn33EpuZz5iVbf9qv32vwEAAP//AwBQSwECLQAUAAYACAAAACEAflIwUYgB>>temp64
echo AAAMBgAAEwAAAAAAAAAAAAAAAAAAAAAAW0NvbnRlbnRfVHlwZXNdLnhtbFBLAQIt>>temp64
echo ABQABgAIAAAAIQC1VTAj9AAAAEwCAAALAAAAAAAAAAAAAAAAAMEDAABfcmVscy8u>>temp64
echo cmVsc1BLAQItABQABgAIAAAAIQCegdRQEQEAANYDAAAaAAAAAAAAAAAAAAAAAOYG>>temp64
echo AAB4bC9fcmVscy93b3JrYm9vay54bWwucmVsc1BLAQItABQABgAIAAAAIQBqmoRZ>>temp64
echo rgIAADEGAAAPAAAAAAAAAAAAAAAAADcJAAB4bC93b3JrYm9vay54bWxQSwECLQAU>>temp64
echo AAYACAAAACEA/VuK8VIBAABaAwAAFAAAAAAAAAAAAAAAAAASDAAAeGwvc2hhcmVk>>temp64
echo U3RyaW5ncy54bWxQSwECLQAUAAYACAAAACEAO20yS8EAAABCAQAAIwAAAAAAAAAA>>temp64
echo AAAAAACWDQAAeGwvd29ya3NoZWV0cy9fcmVscy9zaGVldDEueG1sLnJlbHNQSwEC>>temp64
echo LQAUAAYACAAAACEAyrtG2FgHAADHIAAAEwAAAAAAAAAAAAAAAACYDgAAeGwvdGhl>>temp64
echo bWUvdGhlbWUxLnhtbFBLAQItABQABgAIAAAAIQDhqj9GFgQAADURAAANAAAAAAAA>>temp64
echo AAAAAAAAACEWAAB4bC9zdHlsZXMueG1sUEsBAi0AFAAGAAgAAAAhABaq5Bz3AgAA>>temp64
echo DgcAABgAAAAAAAAAAAAAAAAAYhoAAHhsL3dvcmtzaGVldHMvc2hlZXQxLnhtbFBL>>temp64
echo AQItABQABgAIAAAAIQC2Ew6huwEAAH0EAAAYAAAAAAAAAAAAAAAAAI8dAABjdXN0>>temp64
echo b21YbWwvaXRlbVByb3BzMi54bWxQSwECLQAUAAYACAAAACEAXJYnIsMAAAAoAQAA>>temp64
echo HgAAAAAAAAAAAAAAAACoHwAAY3VzdG9tWG1sL19yZWxzL2l0ZW0yLnhtbC5yZWxz>>temp64
echo UEsBAi0AFAAGAAgAAAAhAHQ/OXrCAAAAKAEAAB4AAAAAAAAAAAAAAAAAryEAAGN1>>temp64
echo c3RvbVhtbC9fcmVscy9pdGVtMS54bWwucmVsc1BLAQItABQABgAIAAAAIQBN8/5I>>temp64
echo tAEAAPwEAAAnAAAAAAAAAAAAAAAAALUjAAB4bC9wcmludGVyU2V0dGluZ3MvcHJp>>temp64
echo bnRlclNldHRpbmdzMS5iaW5QSwECLQAUAAYACAAAACEAvYRiI5AAAADbAAAAEwAA>>temp64
echo AAAAAAAAAAAAAACuJQAAY3VzdG9tWG1sL2l0ZW0xLnhtbFBLAQItABQABgAIAAAA>>temp64
echo IQCT2dfq8wAAAE8BAAAYAAAAAAAAAAAAAAAAAJcmAABjdXN0b21YbWwvaXRlbVBy>>temp64
echo b3BzMS54bWxQSwECLQAUAAYACAAAACEASY52fpwBAAATAwAAEAAAAAAAAAAAAAAA>>temp64
echo AADoJwAAZG9jUHJvcHMvYXBwLnhtbFBLAQItABQABgAIAAAAIQB1elGgSAEAAFgC>>temp64
echo AAARAAAAAAAAAAAAAAAAALoqAABkb2NQcm9wcy9jb3JlLnhtbFBLAQItABQABgAI>>temp64
echo AAAAIQDSjhGnCAoAABIvAAATAAAAAAAAAAAAAAAAADktAABjdXN0b21YbWwvaXRl>>temp64
echo bTIueG1sUEsFBgAAAAASABIAzAQAAJo3AAAAAA==>>temp64
if %startnumber% lss 100 set Fixednumber=0%startnumber%
if %startnumber% lss 10 set Fixednumber=00%startnumber%
certutil -decode -f temp64 "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.xlsx">nul
del temp64
echo 완료!
goto endRename