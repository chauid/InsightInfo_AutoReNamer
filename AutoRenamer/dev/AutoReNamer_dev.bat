@echo off
chcp 65001>nul
setlocal ENABLEDELAYEDEXPANSION
set current=%~dp0
set batchname=%~nx0
rem ##########CurrentVersion:139:##########
set /a version=139
title AutoReName_ver%version:~0,1%.%version:~1,2%
bcdedit > nul
if %errorlevel% equ 1 goto noadmin
cd %current%
echo Initialize...
rem ##########업데이트##########
if "%1" neq "update" goto CheckAlter
if not exist %userprofile%\hashcode\ ( mkdir hashcode )
timeout /t 1 /nobreak >nul
cd /d %userprofile%\hashcode\
certutil /hashfile %current%\%batchname% SHA256>hashcode%version%.hash
for /f "tokens=* skip=1" %%i in (hashcode%version%.hash) do echo %%i>hashcode%version%.hash & goto :genhash
:genhash
timeout /t 2 /nobreak > nul
cd /d %current%
ren "%batchname%" "AutoReNamer.bat" & start %current%AutoReNamer.bat & exit
goto init
:UpdateProgram
echo 새로운 버전을 다운로드 중...
powershell Invoke-WebRequest -Uri %serverIP%/files/AutoReNamer.bat -OutFile %current%NewVersion.bat
powershell Invoke-WebRequest -Uri %serverIP%/files/update%ReName%log.txt -OutFile %current%AutoRenamer%ReName:~0,1%.%ReName:~1,2%updatelog.txt
echo 프로그램을 재시작합니다.
start %current%NewVersion.bat update
del "%current%%batchname%"
exit
:UpdateNow
echo 서버와 연결중... [접속서버IP:%serverIP%]
powershell (Invoke-WebRequest %serverIP%/files/AutoReNamer.bat).RawContent > ReNamer.txt
for /f "delims=: tokens=2 skip=2" %%i in ('find "CurrentVersion" ReNamer.txt')  do set ReName=%%i & goto getVersion
:getVersion
del ReNamer.txt
set /a ReName=ReName
if %ReName% equ 0 echo 서버와 연결할 수 없습니다. 인터넷 연결을 확인하세요. 또는 인터넷 익스플로러 최초 실행이 필요합니다. & timeout /t 5 >nul & cls & goto Setting
echo 현재 버전:%version:~0,1%.%version:~1,2%, 최신버전:%ReName:~0,1%.%ReName:~1,2%
if %ReName% equ %version% echo 현재 최신 버전입니다. & timeout /t 4 > nul & cls & goto Setting
if %ReName% lss %version% echo 서버의 버전보다 높습니다. 버전을 확인하세요. & timeout /t 2 >nul & start http://%serverIP%/ & goto Setting
choice /c yn /m "업데이트 가능한 버전이 있습니다. 업데이트를 진행하시겠습니까?"
if %errorlevel% equ 1 goto UpdateProgram
if %errorlevel% equ 2 cls & goto startScreen
:init
set serverIP=34.168.133.173
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
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ver %version:~0,1%.%version:~1,2%■■■■■ 
WScript sleep.vbs
echo ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
WScript sleep.vbs
echo 1.시작하기  2.설정  3.종료 
del sleep.vbs
choice /c 1234 /n /m "선택 : "
if %errorlevel% equ 1 goto OnDirectory
if %errorlevel% equ 2 set Callby=Main& goto Setting
if %errorlevel% equ 3 echo 프로그램을 종료합니다. & timeout /t 2 >nul & exit
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
goto LoadDirList
:endhash
del temphash.hash
if not exist %userprofile%\hashcode\ goto ExitPro
cd /d %userprofile%\hashcode\
if not exist hashcode%version%.hash goto ExitPro
for /f "tokens=*" %%i in (hashcode%version%.hash) do set origin=%%i& goto Alteration
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
echo 현재 경로를 작업공간으로 설정하기 : S  ^| 현재 경로에서 파일 보기 : P  ^| 설정 : U  ^| 종료하기 : Q
echo 파일탐색기에서 현재 경로 열기 : E
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set Todir=
set /p Todir=입력 : 
if "%Todir%" equ "" set Todir=0
if "%Todir%" equ " " set Todir=0
if "%Todir%" equ "S" goto quitExplore
if "%Todir%" equ "s" goto quitExplore
if "%Todir%" equ "P" call :printfilelist & pause>nul & cls & goto OnDirectory
if "%Todir%" equ "p" call :printfilelist & pause>nul & cls & goto OnDirectory
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
:Alteration
if "%filehash%" neq "%origin%" call :ExitPro
goto init
:NoDir
echo 현재 경로 : %cd%
echo ---------------------------------------------------------------------------
echo %dirlistnum%. [..]상위 디렉터리로 가기
echo ---------------------------------------------------------------------------
echo 현재 설정 : [워커코드:%workercode%, 날짜:%setdate%, 실행모드:%mode%, 파일섞기:%mixfile%]
echo.
echo 현재 경로의 디렉터리 수 : %dirnum% ^| 파일 수 : %filenum%
echo 현재 경로를 작업공간으로 설정하기 : S  ^| 현재 경로에서 파일 보기 : P  ^| 설정 : U  ^| 종료하기 : Q
echo 파일탐색기에서 현재 경로 열기 : E
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set Todir=
set /p Todir=입력 : 
if "%Todir%" equ "S" goto quitExplore
if "%Todir%" equ "s" goto quitExplore
if "%Todir%" equ "P" call :printfilelist & pause>nul & cls & goto OnDirectory
if "%Todir%" equ "p" call :printfilelist & pause>nul & cls & goto OnDirectory
if "%Todir%" equ "U" set Callby=Explorer& goto Setting
if "%Todir%" equ "u" set Callby=Explorer& goto Setting
if "%Todir%" equ "E" explorer %cd% & goto OnDirectory
if "%Todir%" equ "e" explorer %cd% & goto OnDirectory
if "%Todir%" equ "Q" echo 프로그램을 종료합니다. & timeout /t 2 >nul & exit
if "%Todir%" equ "q" echo 프로그램을 종료합니다. & timeout /t 2 >nul & exit
set /a temp=Todir-1
if %temp% neq 0 (echo 현재 디렉터리에 디렉터리가 없습니다. & pause>nul & cls & goto NoDir)
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
set /a MaxX=3
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
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" (set /p "=업데이트[*]  "<nul) else (set /p "=업데이트[ ]  "<nul)
echo      ^|
echo ^|---------------------------------------------------------^|
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" echo ^| 워커코드, 날짜, 실행모드, 파일섞기 기능을 설정합니다.   ^|
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" echo ^| 터미널 텍스트 및 배경 색을 설정합니다.                  ^|
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" echo ^| 프로그램 업데이트 및 재시작                             ^|
echo *---------------------------------------------------------*
goto inputSettingCode
:SettingCodeSelected
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" goto SettingRename
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" goto SettingProgram
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" goto UpdateNow
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
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" (
    echo ^| 이름 바꾸기 실행모드 : 폴더 내에 있는 모든 음원 파일들의  ^| 
    echo ^| 이름을 소음/소리 데이터 이름양식으로 바꿉니다.            ^| 
    echo ^| 이름 양식 :                                               ^| 
    echo ^| [대분류]_[소분류]_[날짜]_[파일번호]_[소음/소리].[확장자]  ^| 
    echo ^| ex^)01_02_220630_001_NN.wav                                ^| 
    echo ^| -^>소음-교통수단-철로운송수단, 22년 06월 30일에 녹음한 파일^| 
    echo ^| 중 1번째 웨이브 파일                                      ^|
    echo ^| ※음원파일만 이름을 바꿉니다.                             ^|
    echo ^| ^(지원하는 음원파일 형식: mp3, m4a, wav^)                   ^|
    echo *-----------------------------------------------------------*
)
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" (
    echo ^| 파일 복사 실행모드 : 하나의 파일을 지정하여 설정한 소음/소^|
    echo ^| 리 데이터 이름양식으로 입력한 개수만큼 복사합니다.        ^|
    echo ^| ex^)[파일이름].[확장자] -^> 01_03_220701_001.[확장자]       ^|
    echo ^| 파일확장자는 원본 파일의 확장자를 따릅니다.               ^|
    echo ^| 모든 확장자의 파일에 대하여 복사합니다.                   ^|
    echo ^| ※파일 지정 시 원하는 파일의 초성만 입력하고 Tab키를 누르 ^|
    echo ^| 면 자동 완성됩니다.                                       ^|
    echo ^| ※파일복사 모드는 파일섞기 설정과 함께 작동하지 않습니다. ^|
    echo *-----------------------------------------------------------*
)
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
cd /d "%current%"
echo 현재 설정이 저장되었습니다. & pause>nul
goto Setting
:SettingProgram
rem ##########프로그램 설정//글자색상, 배경색상##########
set /a MaxX=3
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
echo                       ^|
echo ^|-----------------------------------------------------------------------------^|
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" echo ^| 터미널의 텍스트 색상을 변경합니다.                                          ^|
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" echo ^| 터미널의 배경 색상을 변경합니다.                                            ^|
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" echo ^| 설정된 텍스트와 배경 색상을 기본값으로 초기화합니다.                        ^|
echo *-----------------------------------------------------------------------------*
echo ※사용자설정저장:F는 현재 설정을 로컬 파일에 저장합니다.
echo   프로그램을 종료 후 재시작할 때 저장된 설정을 불러옵니다.
goto inputSettingProgramCode
:SettingProgramSelected
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" goto TextColorSetting
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" goto BgColorSetting
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" set bgcolor=0& set textcolor=7& color 07 & goto SettingProgram
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
:ExitPro
echo 파일 변조가 감지되었습니다. & timeout /t 2 >nul
exit
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
:CheckAlter
cd /d "%current%"
certutil /hashfile %batchname% SHA256>temphash.hash
for /f "tokens=* skip=1" %%i in (temphash.hash) do set filehash=%%i & goto endhash
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
echo AAAhABWIhCltAwAArAgAAA8AAAB4bC93b3JrYm9vay54bWysVVFvmzAQfp+0/4D8>>temp64
echo TsEESIJKqxBAq9ROVZu1L5EqF0yxCpgZk6Sa9t93hpA2yzRl7VBiY9/x8d3dd+b0>>temp64
echo fFMW2oqKhvHKR/jERBqtEp6y6slH3xaxPkFaI0mVkoJX1EcvtEHnZ58/na65eH7k>>temp64
echo /FkDgKrxUS5l7RlGk+S0JM0Jr2kFloyLkkhYiiejqQUlaZNTKsvCsEzTNUrCKtQj>>temp64
echo eOIYDJ5lLKEhT9qSVrIHEbQgEug3OaubAa1MjoEriXhuaz3hZQ0Qj6xg8qUDRVqZ>>temp64
echo eBdPFRfksYCwN9jRNgJ+LvyxCYM1vAlMB68qWSJ4wzN5AtBGT/ogfmwaGO+lYHOY>>temp64
echo g+OQbEPQFVM13LES7jtZuTss9xUMmx9GwyCtTiseJO+daM6Om4XOTjNW0Lteuhqp>>temp64
echo 66+kVJUqkFaQRkYpkzT10RiWfE33NkRbBy0rwGo5o5GJjLOdnK+FltKMtIVcgJAH>>temp64
echo eOgM151ajvIEYcwKSUVFJJ3zSoIOt3F9VHMd9jznoHDthn5vmaDQWKAviBVGknjk>>temp64
echo sbkmMtdaUfgo8pb30IS3NUnoMqQrWvBadcUyIDLJY0hOs5y1kt/QCjIjlildLd+I>>temp64
echo lhx2yD/IliQqFwYkoyfc3/+eGOAtvEGa11JocH8RXkJ5bskKigWSSLe9fAHVwKOH>>temp64
echo KhEefvhhj8cTexzE+syM5jqsXH0WTx3dtSwch9PxJHSsnxCMcL2Ek1bmWx0oaB/Z>>temp64
echo UPQD0xXZDBZsei1LX2n8MLeXrubfhsH2UwWsTrw7RtfNq2LUUtvcsyrlax/p2IKg>>temp64
echo XvaX6854z1KZ+2g0cW1w6fe+UPaUA2MLW2oTOkMx89Eeo7BnFMOlq2GPkfGGUne2>>temp64
echo ArVu1lTVfXSrzlsMh7iauyQjTXjqHeIixV0Rh8cSUiSgfzV1jlNsWlPlQTfyspHd>>temp64
echo DNJjQA/b5mxsTm3djEaObk+mlj6xR5Y+t0MrcsZRGAWOqo/6Nnj/44TsOsAbPjqK>>temp64
echo ZU6EXAiSPMOn6oZmAWkg2j4g4PuWbOBMAnMEFO0Yx7qNp6YeBK6tO2E8csY4nEdO>>temp64
echo /EpWhZ+983yaGN3TlMgWele1bbf21Bhvd3ebWb+xrdNe73k3ocr79um/Od5C9AU9>>temp64
echo 0jm+O9Jx/vVqcXWk72W0eLiPj3WeXQXhbOtv/DE7Rlc9NXaaM4aan/0CAAD//wMA>>temp64
echo UEsDBBQABgAIAAAAIQCegdRQEQEAANYDAAAaAAgBeGwvX3JlbHMvd29ya2Jvb2su>>temp64
echo eG1sLnJlbHMgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC8U01LxDAQvQv+hzB3m7bq>>temp64
echo IrLpXkTYq1bwGtrpB9skJTOr9t8bKna7sNRL8RKYN+S9l5eZ7e7LdOIDPbXOKkii>>temp64
echo GATawpWtrRW85c83DyCItS115ywqGJBgl11fbV+w0xwuUdP2JAKLJQUNc/8oJRUN>>temp64
echo Gk2R69GGTuW80RxKX8teFwddo0zjeCP9nAOyM06xLxX4fXkLIh/6oPw3t6uqtsAn>>temp64
echo VxwNWr4gIYmHLjxA5NrXyAp+6ih4BHlZPl1TnkMseFIfSzmeyZKHZE0Pn84fqEHk>>temp64
echo k48JIjl2Fs1s1jRTHImdeQ/xT18SRXJCZcto0qVo7v/bzWI2d6vOaqM9lq/swyrO>>temp64
echo R3YO/0Yjz7Yx+wYAAP//AwBQSwMEFAAGAAgAAAAhALwuXKmNAwAAIggAABgAAAB4>>temp64
echo bC93b3Jrc2hlZXRzL3NoZWV0MS54bWyck8lu2zAQhu8F+g4E79YeL4LloEhqNJei>>temp64
echo aLqcaYqyCJOiStJLWuTdO6Qk24CBQIghcyiN5pt/OKPl/UkKdGDacNUUOA4ijFhD>>temp64
echo VcmbbYF//lhP5hgZS5qSCNWwAr8wg+9XHz8sj0rvTM2YRUBoTIFra9s8DA2tmSQm>>temp64
echo UC1rwFMpLYmFW70NTasZKX2QFGESRdNQEt7gjpDrMQxVVZyyR0X3kjW2g2gmiAX9>>temp64
echo puatGWiSjsFJonf7dkKVbAGx4YLbFw/FSNL8adsoTTYC6j7FGaHopOFK4J8Oafzz>>temp64
echo m0ySU62MqmwA5LDTfFv+IlyEhJ5Jt/WPwsRZqNmBuwZeUMn7JMV3Z1ZygaXvhE3P>>temp64
echo MHdcOt/zssD/ov43ARu7Jbosg+8Vr5Ylhw67qpBmVYE/xfk6weFq6efnF2dHc7VH>>temp64
echo lmyemWDUMsgRY/RXKflMiWvd/O7q9qubR9E9dCO8UWrnYE8QFkFW4yEuK6GWH9gD>>temp64
echo E/D25wy+gj9eB2xBRHhWcb0fFK390H/TqGQV2Qv7oMRvXtoalEXBbDZLs3QGonrv>>temp64
echo d3X8wvi2tuCeBQk4/FDl5csjMxSmHJQFqctKlYAUsCLJ3dcKQ0pO3h47fApd2zBj>>temp64
echo 19zBMKJ7Y5UccveILhje9MFg++AkCpJ47oSNREBXPQLsgFhclTeSAkfrKWB7SgzA>>temp64
echo kcEg1geDHY5gPlTxRvHTPgzsoHweZFmcRVN3/m8nD30b/gMAAP//AAAA//9sku0O>>temp64
echo giAYRm+FvRcQ4ncN3TLrPhy52dq0CbO6+16kkUB/GLLjA+cBLoe+V22nuprP05PM>>temp64
echo FTAg8tGNEmeHHMigcFICUcNN3JtJfwF5sbQTh+u77aXoR1yLdkkGNRc64KgTKsjw>>temp64
echo nwokri51xulScyq+RGMITLdE5BKnkGAu0YZE6hLnkIhd4mKIYnOOxBIU+7ClxG4p>>temp64
echo //ytvmbXlqzc3tM3RLLZtvT0DYGjzWBeQ20Yknv+IVF4/oZIgeLlrLr09x4+AAAA>>temp64
echo //8AAAD//zSOQQrCQAxFrzLkANYiIkqnG1ddFISeYLRpJ6iTkEZFT+9U7O6/v/jv>>temp64
echo VxI5odHlpG7gZE3voQRnb0EPiY+cnqgTcYKiriSM2AYdKU3uhoN5WK924JTGuGRj>>temp64
echo +bVbcGc24/tCEUOPOtMGsoltgf9uh/YQJ0FQO/pk+R4cK2GyYFnvQVhNA1n2HSi/>>temp64
echo 1KYv51PFi/U6RUSrvwAAAP//AwBQSwMEFAAGAAgAAAAhAMq7RthYBwAAxyAAABMA>>temp64
echo AAB4bC90aGVtZS90aGVtZTEueG1s7Flbixs3FH4v9D8M8+74NuPLEqf4mk2yuwlZ>>temp64
echo J6WPWlv2aFczMpK8G1MCJaXQQikU0tKXQt/yUEoLLbT0pT9mIaFN+x96pBl7pLXc>>temp64
echo 3DYlLbuGxSN/5+jonKNPZ44uv3Mvpt4x5oKwpOWXL5V8DycjNibJtOXfGQ4KDd8T>>temp64
echo EiVjRFmCW/4CC/+dK2+/dRltyQjH2AP5RGyhlh9JOdsqFsUIhpG4xGY4gd8mjMdI>>temp64
echo wiOfFsccnYDemBYrpVKtGCOS+F6CYlB7czIhI+z99dGnTx997F9Zau9TmCKRQg2M>>temp64
echo KN9XurElorHjo7JCiIXoUu4dI9ryYaIxOxnie9L3KBISfmj5Jf3nF69cLqKtTIjK>>temp64
echo DbKG3ED/ZXKZwPiooufk04PVpEEQBrX2Sr8GULmO69f7tX5tpU8D0GgEK01tsXXW>>temp64
echo K90gwxqg9KtDd6/eq5YtvKG/umZzO1QfC69Bqf5gDT8YdMGLFl6DUny4hg87zU7P>>temp64
echo 1q9BKb62hq+X2r2gbunXoIiS5GgNXQpr1e5ytSvIhNFtJ7wZBoN6JVOeoyAbVtml>>temp64
echo ppiwRG7KtRgdMj4AgAJSJEniycUMT9AI0riLKDngxNsh0wgSb4YSJmC4VCkNSlX4>>temp64
echo rz6B/qYjirYwMqSVXWCJWBtS9nhixMlMtvzroNU3II9/+eX0wU+nD34+/fDD0wff>>temp64
echo Z3NrVZbcNkqmptzTR5//+fUH3h8/fvP04Rfp1GfxwsQ/+e6TJ7/+9k/qYcW5Kx5/>>temp64
echo +cOTn354/NVnv3/70KG9zdGBCR+SGAtvD594t1kMC3TYjw/4i0kMI0QsCRSBbofq>>temp64
echo vows4N4CUReug20X3uXAMi7g1fmhZet+xOeSOGa+EcUWcJcx2mHc6YAbai7Dw8N5>>temp64
echo MnVPzucm7jZCx665uyixAtyfz4BeiUtlN8KWmbcoSiSa4gRLT/3GjjB2rO49Qiy/>>temp64
echo 7pIRZ4JNpPce8TqIOF0yJAdWIuVC2ySGuCxcBkKoLd/s3vU6jLpW3cPHNhK2BaIO>>temp64
echo 44eYWm68iuYSxS6VQxRT0+E7SEYuI/cXfGTi+kJCpKeYMq8/xkK4ZG5yWK8R9BvA>>temp64
echo MO6w79JFbCO5JEcunTuIMRPZY0fdCMUzp80kiUzsNXEEKYq8W0y64LvM3iHqGeKA>>temp64
echo ko3hvkuwFe5nE8EdIFfTpDxB1C9z7ojlVczs/bigE4RdLNPmscWubU6c2dGZT63U>>temp64
echo 3sGYohM0xti7c81hQYfNLJ/nRl+PgFW2sSuxriM7V9VzggX2dF2zTpE7RFgpu4+n>>temp64
echo bIM9u4szxLNASYz4Js17EHUrdeGUc1LpTTo6MoF7BOo/yBenU24K0GEkd3+T1lsR>>temp64
echo ss4u9Szc+brgVvyeZ4/Bvjx80X0JMviFZYDYn9s3Q0StCfKEGSIoMFx0CyJW+HMR>>temp64
echo da5qsblTbmJv2jwMUBhZ9U5MkmcWP2fKnvDfKXvcBcw5FDxuxa9S6myilO0zBc4m>>temp64
echo 3H+wrOmheXILw0myzlkXVc1FVeP/76uaTXv5opa5qGUuahnX29drqWXy8gUqm7zL>>temp64
echo o3s+8caWz4RQui8XFO8I3fUR8EYzHsCgbkfpnuSqBTiL4GvWYLJwU460jMeZfJfI>>temp64
echo aD9CM2gNlXUDcyoy1VPhzZiAjpEe1r1UfEa37jvN4102Tjud5bLqaqYuFEjm46Vw>>temp64
echo NQ5dKpmia/W8e7dSr/uhU91lXRqgZF/ECGMy24iqw4j6chCi8E9G6JWdixVNhxUN>>temp64
echo pX4ZqmUUV64A01ZRgVduD17UW34YpB1kaMZBeT5WcUqbycvoquCca6Q3OZOaGQAl>>temp64
echo 9jID8kg3la0bl6dWl6bac0TaMsJIN9sIIw0jeBHOstNsuZ9nrJt5SC3zlCuWuyE3>>temp64
echo o954HbFWJHKGG2hiMgVNvJOWX6uGcK0yQrOWP4GOMXyNZ5A7Qr11ITqFe5eR5OmG>>temp64
echo fxlmmXEhe0hEqcM16aRsEBOJuUdJ3PLV8lfZQBPNIdq2cgUI4Y01rgm08qYZB0G3>>temp64
echo g4wnEzySZtiNEeXp9BEYPuUK569a/OXBSpLNIdz70fjEO6BzfhtBioX1snLgmAi4>>temp64
echo OCin3hwTuAlbEVmef2cOpox2zasonUPpOKKzCGUniknmKVyT6Moc/bTygfGUrRkc>>temp64
echo uu7Cg6k6YF/51H32Ua08Z5BmfmZarKJOTTeZvr5D3rAqP0Qtq1Lq1u/UIue65pLr>>temp64
echo IFGdp8QzTt3nOBAM0/LJLNOUxes0rDg7G7VNO8eCwPBEbYPfVmeE0xMve/KD3Nms>>temp64
echo VQfEsq7Uia/vzM1bbXZwCOTRg/vDOZVChxLurDmCoi+9gUxpA7bIPZnViPDNm3PS>>temp64
echo 8t8vhe2gWwm7hVIj7BeCalAqNMJ2tdAOw2q5H5ZLvU7lPhwsMorLYXpfP4ArDLrI>>temp64
echo bu31+NrNfby8pbk0YnGR6Zv5ojZc39yXK66b+6G6mfc9AqTzfq0yaFabnVqhWW0P>>temp64
echo CkGv0yg0u7VOoVfr1nuDXjdsNAf3fe9Yg4N2tRvU+o1CrdztFoJaSZnfaBbqQaXS>>temp64
echo DurtRj9o38/KGFh5Sh+ZL8C92q4rfwMAAP//AwBQSwMEFAAGAAgAAAAhAEYxPyon>>temp64
echo BAAAgxEAAA0AAAB4bC9zdHlsZXMueG1szFjNbttGEL4X6DsQe6f5I5ImBVFBZJlA>>temp64
echo gLQoYBfodUUupUWWu8Jy5VIpCuQVArS3FuihQB+gb9Wk79BZ/oiUbEeKU8e5WNy/>>temp64
echo mW++mZ2Z9eRZVTDjhsiSCh4j58xGBuGpyChfxuj768QMkVEqzDPMBCcx2pISPZt+>>temp64
echo /dWkVFtGrlaEKANE8DJGK6XWY8sq0xUpcHkm1oTDSi5kgRUM5dIq15LgrNSHCma5>>temp64
echo th1YBaYcNRLGRXqKkALLV5u1mYpijRVdUEbVtpaFjCIdv1hyIfGCAdTK8XBqVE4g>>temp64
echo XaOSnZJ69paegqZSlCJXZyDXEnlOU3IbbmRFFk57SSD5YZIc37LdPdsr+UBJniXJ>>temp64
echo DdXuQ9NJLrgqjVRsuIqRC0A1BeNXXPzIE70EHm53TSfla+MGM5hxkTWdpIIJaShw>>temp64
echo HTDn6BmOC9LsePfX2/e/vzH++fuPd7/8qpdyXFC2bRab0yssS4iEVmCkN9Vx0Eoo>>temp64
echo KHhFT1oaYYOzRxA+trpaawlqKWM7ejzNBExMJxBHikiewMBov6+3a+CBQ8g3qOt9>>temp64
echo R3YvJd46rn/6gVIwmmkUy4sh++fIUFQ70D47j6IodIIwDCNv5HheTfai3U55RiqS>>temp64
echo xSjwap0DMzTRp0C+B0H0PyKogQD3CyEzSDNdcJ6D3c3UdMJIriA2JF2u9K8Sa/i7>>temp64
echo EErBVZxOMoqXgmOmo6c7MTwJ6QkyUYzUCjJJF8iH3GgVrYaT9tdYaijd9oJkdFPc>>temp64
echo qwBAd5hPPNEY+OT27ag+iZfHBn2E5S/QLUcQHws8vFGiTbhWb92HnTI888U45HHj>>temp64
echo 6BNZPkwHTxxHbR6DrJgSxq50/voh36VGXaKr3OCbIinUC8jv0JPpstl9QmJvP5s0>>temp64
echo 2AymE8zokheEQxkmUtFUF/cUhqSpvFUOCXSor9E+UBw+SLFR5R+B4ATDRsjoDfOg>>temp64
echo iWnlG3i9ZltdpfWFaUazuqo0bc0J9n8srbqF2tPe62v0P+84P4SwEpK+BqcNnHC/>>temp64
echo W/ZgeVB9j7n7Fq5vN8WCyKTute9i50nR+ocsPhnau28SsNkHXHAr4MCLPaX3hd/n>>temp64
echo JngPM9yG/TC9m2D9BHhCS04gH67+wW3/7JDrFAlJcZCb9zLzLoMa+oEUo3/f/vb+>>temp64
echo zzcD3IsNZdC/NzlRN627EyAzq/o8b+uuXem3al0BdlqAp4zkeMPU9W4xRv33N3Un>>temp64
echo CgHQ7vqO3ghVi4hR//1Sd9NOoHWQSr0sof2FX2MjaYx+upydR/PLxDVDexaa3oj4>>temp64
echo ZuTP5qbvXczm8ySyXfvi58GL+RPey/UDHwqa441LBq9q2Rrbgr/q52I0GDTw63cN>>temp64
echo wB5ij9zAfu47tpmMbMf0AhyaYTDyzcR33HngzS79xB9g9x/4rrYtx2le6Bq8P1a0>>temp64
echo IIzyzledh4az4CQYfsAIq/OE1f/3ZPofAAAA//8DAFBLAwQUAAYACAAAACEA1HEG>>temp64
echo 104BAACEAwAAFAAAAHhsL3NoYXJlZFN0cmluZ3MueG1spJO/TsMwEId3JN7B8k7t>>temp64
echo pOKvklRq2qIOVIi0c2QlbmsptkPsFrohoAvqwoDUpUwgMdKxr0TCO2BEhZjxeHf6>>temp64
echo fffdcF7jmmdgSgvFpPChU8MQUJHIlImRDwf9zt4RBEoTkZJMCurDGVWwEezueEpp>>temp64
echo YLJC+XCsdX6CkErGlBNVkzkVZjKUBSfalMUIqbygJFVjSjXPkIvxAeKECQgSORHa>>temp64
echo 7HUgmAh2OaHhbyPwFAs8HVy0wzjqd8/aHtKBl4+NhmbJeQGGUuhuasIQ6Flu3IQM>>temp64
echo pdjeAlHgoW/ADyRKW3TKEmrHCCXnVGg7SJ6Rrccfv9NBM44Gzahlw+6wjMY9wq2u>>temp64
echo xHUbBReXixtQ3r5V9+tqtQSfT48f6/fq4aW8m9twHWyTxvUYO/ExdmPXxYfufoxN>>temp64
echo GfVqV2Rqgy3nm2q1qJ5fq83yfxxkvij4AgAA//8DAFBLAwQUAAYACAAAACEAO20y>>temp64
echo S8EAAABCAQAAIwAAAHhsL3dvcmtzaGVldHMvX3JlbHMvc2hlZXQxLnhtbC5yZWxz>>temp64
echo hI/BisIwFEX3A/5DeHuT1oUMQ1M3IrhV5wNi+toG25eQ9xT9e7McZcDl5XDP5Tab>>temp64
echo +zypG2YOkSzUugKF5GMXaLDwe9otv0GxOOrcFAktPJBh0y6+mgNOTkqJx5BYFQux>>temp64
echo hVEk/RjDfsTZsY4JqZA+5tlJiXkwyfmLG9Csqmpt8l8HtC9Ote8s5H1Xgzo9Uln+>>temp64
echo 7I59Hzxuo7/OSPLPhEk5kGA+okg5yEXt8oBiQet39p5rfQ4Epm3My/P2CQAA//8D>>temp64
echo AFBLAwQUAAYACAAAACEATfP+SLQBAAD8BAAAJwAAAHhsL3ByaW50ZXJTZXR0aW5n>>temp64
echo cy9wcmludGVyU2V0dGluZ3MxLmJpbuxTzW7TQBD+7EQIhAScOKAeIk5cIjXUbdSj>>temp64
echo k22po/oH/6BeTTKUlVyvtV5XLVXfA8EL9C14Ed4FZt1EAgkhgXrgwK5mZzye75uZ>>temp64
echo /TlCgl1M8ZJXH/sY4QWO2DdCjHc8JZYgLFgM+xJoKNbTHgEeznBw7ytGw8EXuA4e>>temp64
echo 4NND7/4KDh7jxHVZn7gDXn14NviOhrPmsdq1NbB84/EqyH5KI4KoeI4bZzjcwrOn>>temp64
echo n4PfpX+0/mlr7vv6IXiT7w5b+E/1D+7An5zzDQdnYb6wbTzBR+cKM34TE+zxnOCQ>>temp64
echo 7/u4v/UCc7Y87ECwd8xR8z5qzJ599u3wnLKerN/fLq6ZMaibzsxkjcM4DbO4SOcH>>temp64
echo SA8ycXyMopaaWmslZUM6kx8IvscfpzRTekW6orZFpGpCSCtZ5pcNIcv9SPipQNyZ>>temp64
echo DXO5pKLBQr210NgikdI56ZYQa0m1KY1UNZI4zVM/yPsMt/DXXVlJc8lJ9FlZYa6q>>temp64
echo qjSMiixbVDQJF7jBC6522ROl8vS9mSlj1BlE11R0gSiOuC9qVdX1ISIJ9ra3L1gs>>temp64
echo qdKhWtGt9de3ZYuRbzwR/upsvwMAAP//AwBQSwMEFAAGAAgAAAAhANKOEacICgAA>>temp64
echo Ei8AABMAKABjdXN0b21YbWwvaXRlbTEueG1sIKIkACigIAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAOxaS4/cxhG+G/B/IJgzl4/hzHAGGhnSrJQIkSzB>>temp64
echo u3FyM5rdzR1GHHLMx+4sjAAK5AAG5EOAwIAPMqBDAiNBghzsJDokf8iz+g+p7uab>>temp64
echo 8yA5chwEkQ7ScFjV1dXVX1V9NbfeWy896ZKGkRv4M1k/0WSJ+jggrn8xk5PYUSz5>>temp64
echo vdu3cDzFgR9TPz6/XtEzvKBLJMHDj2ayLC1R/m/ppffRks7kzZ9f33z6kr9T+u7B>>temp64
echo 6UzW1poOf7X749Fd7e7pXV0fmPORaUzGpqFr1ngwv2/NzXunddkPc1vBVFi6pPaU>>temp64
echo Rjh0VzHfys3zzySx+uYP/5Q2X3+++d1fNi8+27z4/Uld7gwHK7CVP05dwSykE9sx>>temp64
echo sK2ZxKLIGRsmmRA6skfaEE8Mog9kCXznR1Mcz+RFHK+mqhpxz0QnSxeHQRQ48QkO>>temp64
echo lmrgOC6mqqFpI3VJY0RQjNSS3ZmiJeqjaBWC9WHs0ogrvxPHoWsnMY3k2+++c2sd>>temp64
echo kamwSopReEFjdi7RCmHYcHeji7W4s8IggL3HYUL5R8elHomY65wBRtQ2rNFoYBhj>>temp64
echo ahHTMYyJaRqUGtRxDFnyI0NEjR8NxH+EM8He3LCrq6uTq8FJEF4w3+nqLx49FKGX>>temp64
echo OWwdtX93dex+hX1g90weDWwydKyBMhgTWzFH1FEmVBso5piOJ0QbmXQ4zGyE/c1k>>temp64
echo w7FNhw51RUNjSzGHlqlY2sBQHHsyHFJq2ZhO8uNyl6sgjCW/OKhW66nZcTflWy2f>>temp64
echo y1OPLuGmcwNmcunIswUgplceXTMoyEOMfpwAbuSfqzpIgBOm8hHy0QVXnm92iy7k>>temp64
echo eZnaTE1InZnMQuYRJS46o+ElXKhH6VWC2HP9xxgnIYSDJjf2sVX4Porizgo87IxH>>temp64
echo jj4cYkpMQrBtapMx4JYD8T4YGE5LSwbTc7Seoxgv7nheL+sfzz/oJfdj6tMQMYA8>>temp64
echo d5fs0nZ33L1LOMifoGgxD0hbDYPp2QKFlPzcjRc/iwDAWzuqkDuF03a9rZIqA7k0>>temp64
echo avj/a0HFn6WhxCKLf45KEdteiOP7IVxtBw+pQfeDcHlKHZR4AKUfJ8hzAUZJgXDf>>temp64
echo ExySZYGdh7NW8wKrMdx+OA2BiivcDl1d3wlWKF4wPB+rT1AYQzzOobIIAzja3QDW>>temp64
echo OlPtNHQPOrZRvt/wHdC5A6zQ1PUJXc9kC9Kg63nI9iAZ51mUuNHKQ9eiftqpYuES>>temp64
echo QqFiy8VcKM9CH3kH5EKKyGPfu04l81CGpOHRMqKHNIJCAjOskGwUgYUQMtP3g5gK>>temp64
echo hBWXqCJWv2fsWlYTQXk7NQTOvTLp5pWGmg6eacj+sN5pkV5yL+n6VjfFaB34wTI7>>temp64
echo XlYgVwOj1RqZlvusoGsG1IMlZPFzdMHAGE0r8Xrz1bebv76++fqZ9Ob5y+/+8VqU>>temp64
echo iXnMOciLSrXiAwC3T4ZpUlVYVlVYWlVYXlXKifVXXE9m1iPASrcU+lG0YpqciWHY>>temp64
echo mjNUCNToUJVBuWVbhqXYiNgI2yMLDU2hh4bLMxozGW1i6SYmA2U4sqji0ImmsCeK>>temp64
echo RUaG7jiWY1tCBvl4EYR8GRv0OPZAwQOqg4ilK2g8HikYmfZoopsWNgG+wTFQllcu>>temp64
echo aPRTen0VhMxS7oYe5RQvZVZ4eg47qKdCWHKdVUG6fFtkuWOz3v4rLMqQIiahJToE>>temp64
echo aPfWcYhwTIl0Ttcx99Nu5Mr0v41rmXkbvPSQ+hfxQrpEXgKwZkCtzgGcw1cJ9opS>>temp64
echo 4QiUa1RchbcgsLrA/xZNHaBui/SRXuXnVzguOsJJ9Zqy8BG0UV181FTUwUVN4f+k>>temp64
echo h0Q+bVVftmrnpP/Xl//r9WW1iywuDaNXDtSVIMrrBIm3oRL0odI88JKlzxG5cWk8>>temp64
echo N4Lu5BNCJmPLwEgZ6SZk2ImtseSKlcHEmhDH0nXN0ESqrmJ63dBoEVzx2mImZ23w>>temp64
echo KXBifO0ranfkS7ZQCOkj1llAt5qzCWv4xIjOUkHLa4n5IgA+4WEQPE1WBWu2l9L4>>temp64
echo kCUPWWJdkKiMU+lyFk58O0ig1GflQLnRrp9OCUTrTSnkSGFynoyaW2vTvTbzeLMj>>temp64
echo LwJodDiAvvvmbzcvX0mbz5/dPP/1ljS+Tf0OOD3q/BidwM+w5bmx9x9AF1o/klLx>>temp64
echo VBxbb8LrtOjhshjhRCx0VP7FIfKDEX8z+Q7GEDxQpJaDjFvfKpyaB54qZD1eO5uO>>temp64
echo oEl+iDAuCKIikMeHA/nm09ebvz+Tbl59sfnmW0mE9d54Lq/zX12YdqgoahQI61yA>>temp64
echo 2HGAmkJxxAl4mBg8ha6vMcQIqVIeChwoOlA2nKiwXolf4r1sL8BPc0LsR0DrpSRT>>temp64
echo g2Hqb2WvUQN0nKmbds4lFNePYugU4YKJJUjBi62S0OOeJFhNvRSp+omuFu8CgVNi>>temp64
echo 5coC/Jv8zQBYrgN8W5Z/1cAmh3m1PbYJbvBhgDlrnK9KEttzYU4YUr6nlEFUYdeR>>temp64
echo +jHsEPi9gaqZqmaoBJ8AGBW0fHM8kbp124bfxvLceVUbqqwU28aTfIqWgeP8/KPa>>temp64
echo FznNV8pY6ZSk+XKWO3ZNMwieYoCPOAj3pCJ9xzSDQAcNsSI0NOuLChOwfR4Cy7tA>>temp64
echo IMaMbe5ogchPlflltbypLJ+WSJX0lwO0GOFWGaR/ffnmN7+9ef1KevPlFzcvvtrp>>temp64
echo gWnsxl59AlElQQT9xblWweJUV3r1cvOnP+7WHyX2LylmHEWleGvnXFLMorspEN59>>temp64
echo Kqii/RxP07U7z9pD/kUC+N3HFrj69CIIr/fKtrBF7CwdsL8dZSG9dFlB31Fbfjd9>>temp64
echo P4g5sGVPsvlB9lDa8ed84UaCQJKAzHeZiyIpXlDJT5Y2DaXAkSJ0Cc+CUMqMjE6k>>temp64
echo c3gDrVYeE2B9CCgBwmkVQFcCQwAJEq6UrODnAVAlgrZ8CeTAdZcowotc2cm772wz>>temp64
echo TbB+9V2Ip6iy28NkvcdGpPBLEDaPunv06XPqMsOtZaq2VziKpu4MDi7pdT9ajQtF>>temp64
echo 4hFhcdQPKPZPjg6xNC0Kprc5gUvLlla/q0h9U02lT2C4C9cx/a7R2U3LU9d1lE+H>>temp64
echo Ml670jdVYJfz2dn7taUz6VLL1FdWdEf7pSF+Kvtgn5sT5x22ChDc2h9O2cAN2sN9>>temp64
echo W93RGzKLOgpX+8D24ndP53eiKMAuQB65BwVEfN37uEFXqmF3ji114wzGym6tHwR8>>temp64
echo m98XAEr4yQiMSsQC+a+eUu/m76WhtE+utcjZdRTT5YO0B2BLthbNXApJYZdcqzAr>>temp64
echo 9iEipb77PE1XD3y3O+pqCuqgm4YtvulpS91VLdVUcaqIvL5QJTx7HGAJHVnAfEAd>>temp64
echo GrIfUdWyYhvoSzURmAp3hr5MFmjj3rIw+esty0rzcoXdZb8wH/rewXrLSQvatwvq>>temp64
echo 7jzq3qrYWfcXhsPuLwyn3V8Yjru/MJx3d2ExLe970Zl0e8b4UI7qUSzkBhyzA55V>>temp64
echo ut8zvnadcG5c0LdQEbGFhI39zrfgyffcSm5nPmJVt/2q/fa/AQAA//8DAFBLAwQU>>temp64
echo AAYACAAAACEAthMOobsBAAB9BAAAGAAoAGN1c3RvbVhtbC9pdGVtUHJvcHMxLnht>>temp64
echo bCCiJAAooCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC0lN1q3DAQ>>temp64
echo he8LfYdF97L8bznEG5r1FgINlDaF3MrSaNfUkowkd1tK372ykxKSbNiWtldmLOac>>temp64
echo meNPPr/4qobVF7CuN7pBSRSjFWhuRK93Dfp08xZTtHKeacEGo6FB2qCL9etX58Kd>>temp64
echo CeaZ88bClQe1Ci/68LxqG/R9uy3STbwtMaVthXO6rTGts0tcpellFrfpJt20P9Aq>>temp64
echo WOsg4xq09348I8TxPSjmIjOCDofSWMV8KO2OGCl7Dq3hkwLtSRrHJeFTsFe3akDr>>temp64
echo eZ677g8g3eNyHm2y/TMX1XNrnJE+4kbdG9wJK/Bs3o5wo32wu/k2AiL/THW0YUHr>>temp64
echo e3Bkdnrjve27yYM75XE4HKJDtuQRAkjI7fW7j0tk/2W4F0XLrBOFpBnOKtHhvASJ>>temp64
echo a4gznFdQ1SIucyiKF5tT2eUSigTHrKI4L2iOaZylWHZ1UQDQjkP99+uIe1CumWY7>>temp64
echo WJDx4SOeTPgXgUfZ6LU0I/P7GZKKvGfWa7CbgIg1w28rH2F7ZPxzmPIZexbwAyqn>>temp64
echo MhknOyxkCE5gWFZ2JIkS8ieNHqxyJzuOh9SHq2I1G4jpxOxJnlzJuX70y1j/BAAA>>temp64
echo //8DAFBLAwQUAAYACAAAACEAvYRiI5AAAADbAAAAEwAoAGN1c3RvbVhtbC9pdGVt>>temp64
echo Mi54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbI47>>temp64
echo DsIwEAWvgtKTLejQ4jSBClHlAsY4iqWs1/IuH98eB0GBlHqeZh52JLx1HNVHHUry>>temp64
echo ncETZxo8pdmql82L5iiHZlJNewBxkycrLQWXWXjU1jGBTDb7xCEqPHbwtWm1wVhd>>temp64
echo 0hjsg1RfMT27O9XUOVyzzWVJIfwgHm9B1ycfghf/XMcLQPg7bt4AAAD//wMAUEsD>>temp64
echo BBQABgAIAAAAIQCT2dfq8wAAAE8BAAAYACgAY3VzdG9tWG1sL2l0ZW1Qcm9wczIu>>temp64
echo eG1sIKIkACigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGSQwWrD>>temp64
echo MBBE74X+g9m7LTWJ5STYDjWOIdfSQq9CXscCS2skObSU/ntlekp7WmaHnTdsefow>>temp64
echo U3JD5zXZCp4yDglaRb221wreXrt0D4kP0vZyIosVWIJT/fhQ9v7YyyB9IIeXgCaJ>>temp64
echo Cx3npa3gqytEk28Knord8zbdifacNoKf00ORd4If8qZt99+QRLSNMb6CMYT5yJhX>>temp64
echo IxrpM5rRRnMgZ2SI0l0ZDYNW2JJaDNrANpwLppaIN+9mgnrt83v9goO/l2u1xel/>>temp64
echo FKOVI09DyBQZ5kfpcCYdw29bpsiGyAmfM7K1hgdWl+wPZNV3T6h/AAAA//8DAFBL>>temp64
echo AwQUAAYACAAAACEA8pxPNUwBAABbAgAAEQAIAWRvY1Byb3BzL2NvcmUueG1sIKIE>>temp64
echo ASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAhJJfT4MwFMXfTfwOpO/QUrYFG2DxT/bkEuMw>>temp64
echo Gt+a9m4jQiFtle3bW2BDFk187D3n/u65N02Wh6r0vkCbolYpCgOCPFCiloXapegl>>temp64
echo X/kx8ozlSvKyVpCiIxi0zK6vEtEwUWt40nUD2hZgPEdShokmRXtrG4axEXuouAmc>>temp64
echo QzlxW+uKW/fUO9xw8cF3gCkhC1yB5ZJbjjug34xEdEJKMSKbT132ACkwlFCBsgaH>>temp64
echo QYh/vBZ0Zf5s6JWJsyrssXE7neJO2VIM4ug+mGI0tm0btFEfw+UP8dv6cdOv6heq>>temp64
echo u5UAlCVSMKGB21pnNCYzmuBJpbteyY1du0NvC5B3x2yzvn3OE/xbcKQ++IAD6bko>>temp64
echo bAh+Vl6j+4d8hTJKKPXJwqc0JzEjczZbvHdzL/q7aEOhOk3/lxj7JMrDiIVzFt1M>>temp64
echo iGdA1ue+/A7ZNwAAAP//AwBQSwMEFAAGAAgAAAAhAEmOdn6cAQAAEwMAABAACAFk>>temp64
echo b2NQcm9wcy9hcHAueG1sIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnJLBTtwwEIbv>>temp64
echo lXiHyHfWWVohtHKM0FLEoVVX2oW760w2Fo5t2UO021uvLW8Aj9AH4KHgHTpJxJKF>>temp64
echo nnqbmf/X789ji9NNY7MWYjLeFWw6yVkGTvvSuHXBrlYXhycsS6hcqax3ULAtJHYq>>temp64
echo Dz6IRfQBIhpIGUW4VLAaMcw4T7qGRqUJyY6UysdGIbVxzX1VGQ3nXt824JAf5fkx>>temp64
echo hw2CK6E8DLtANiTOWvzf0NLrji9dr7aBgKU4C8EarZBuKb8aHX3yFWafNxqs4GNR>>temp64
echo EN0S9G00uJW54ONWLLWyMKdgWSmbQPDXgbgE1S1toUxMUrQ4a0Gjj1kyP2htRyz7>>temp64
echo rhJ0OAVrVTTKIWF1tqHpaxsSRvl0f/f888/T74fnX4+Ck2UY9+XYPa7NJzntDVTs>>temp64
echo G7uAAYWEfciVQQvpW7VQEf/BPB0z9wwD8YCzrAFwOHPM11+aTnqTPfdNUG5Lwq76>>temp64
echo YtxNugorf64QXha6PxTLWkUo6Q12C98NxCXtMtouZF4rt4byxfNe6J7/evjjcno8>>temp64
echo yT/m9LKjmeCvv1n+BQAA//8DAFBLAwQUAAYACAAAACEAdD85esIAAAAoAQAAHgAI>>temp64
echo AWN1c3RvbVhtbC9fcmVscy9pdGVtMS54bWwucmVscyCiBAEooAABAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAITPwYoCMQwG4LvgO5Tcnc54EJHpeFkWvIm44LV0MjPFaVOaKPr2Fk8r>>temp64
echo LOwxCfn+pN0/wqzumNlTNNBUNSiMjnofRwM/5+/VFhSLjb2dKaKBJzLsu+WiPeFs>>temp64
echo pSzx5BOrokQ2MImkndbsJgyWK0oYy2SgHKyUMo86WXe1I+p1XW90/m1A92GqQ28g>>temp64
echo H/oG1PmZSvL/Ng2Dd/hF7hYwyh8R2t1YKFzCfMyUuMg2jygGvGB4t5qq3Au6a/XH>>temp64
echo f90LAAD//wMAUEsDBBQABgAIAAAAIQBcliciwwAAACgBAAAeAAgBY3VzdG9tWG1s>>temp64
echo L19yZWxzL2l0ZW0yLnhtbC5yZWxzIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAhM/B>>temp64
echo asMwDAbge6HvYHRfnPYwSonTSxnkNkYLvRpHSUxjy1hKad9+pqcWBjtKQt8vNYd7>>temp64
echo mNUNM3uKBjZVDQqjo97H0cD59PWxA8ViY29nimjggQyHdr1qfnC2UpZ48olVUSIb>>temp64
echo mETSXmt2EwbLFSWMZTJQDlZKmUedrLvaEfW2rj91fjWgfTNV1xvIXb8BdXqkkvy/>>temp64
echo TcPgHR7JLQGj/BGh3cJC4RLm70yJi2zziGLAC4Zna1uVe0G3jX77r/0FAAD//wMA>>temp64
echo UEsBAi0AFAAGAAgAAAAhAH5SMFGIAQAADAYAABMAAAAAAAAAAAAAAAAAAAAAAFtD>>temp64
echo b250ZW50X1R5cGVzXS54bWxQSwECLQAUAAYACAAAACEAtVUwI/QAAABMAgAACwAA>>temp64
echo AAAAAAAAAAAAAADBAwAAX3JlbHMvLnJlbHNQSwECLQAUAAYACAAAACEAFYiEKW0D>>temp64
echo AACsCAAADwAAAAAAAAAAAAAAAADmBgAAeGwvd29ya2Jvb2sueG1sUEsBAi0AFAAG>>temp64
echo AAgAAAAhAJ6B1FARAQAA1gMAABoAAAAAAAAAAAAAAAAAgAoAAHhsL19yZWxzL3dv>>temp64
echo cmtib29rLnhtbC5yZWxzUEsBAi0AFAAGAAgAAAAhALwuXKmNAwAAIggAABgAAAAA>>temp64
echo AAAAAAAAAAAA0QwAAHhsL3dvcmtzaGVldHMvc2hlZXQxLnhtbFBLAQItABQABgAI>>temp64
echo AAAAIQDKu0bYWAcAAMcgAAATAAAAAAAAAAAAAAAAAJQQAAB4bC90aGVtZS90aGVt>>temp64
echo ZTEueG1sUEsBAi0AFAAGAAgAAAAhAEYxPyonBAAAgxEAAA0AAAAAAAAAAAAAAAAA>>temp64
echo HRgAAHhsL3N0eWxlcy54bWxQSwECLQAUAAYACAAAACEA1HEG104BAACEAwAAFAAA>>temp64
echo AAAAAAAAAAAAAABvHAAAeGwvc2hhcmVkU3RyaW5ncy54bWxQSwECLQAUAAYACAAA>>temp64
echo ACEAO20yS8EAAABCAQAAIwAAAAAAAAAAAAAAAADvHQAAeGwvd29ya3NoZWV0cy9f>>temp64
echo cmVscy9zaGVldDEueG1sLnJlbHNQSwECLQAUAAYACAAAACEATfP+SLQBAAD8BAAA>>temp64
echo JwAAAAAAAAAAAAAAAADxHgAAeGwvcHJpbnRlclNldHRpbmdzL3ByaW50ZXJTZXR0>>temp64
echo aW5nczEuYmluUEsBAi0AFAAGAAgAAAAhANKOEacICgAAEi8AABMAAAAAAAAAAAAA>>temp64
echo AAAA6iAAAGN1c3RvbVhtbC9pdGVtMS54bWxQSwECLQAUAAYACAAAACEAthMOobsB>>temp64
echo AAB9BAAAGAAAAAAAAAAAAAAAAABLKwAAY3VzdG9tWG1sL2l0ZW1Qcm9wczEueG1s>>temp64
echo UEsBAi0AFAAGAAgAAAAhAL2EYiOQAAAA2wAAABMAAAAAAAAAAAAAAAAAZC0AAGN1>>temp64
echo c3RvbVhtbC9pdGVtMi54bWxQSwECLQAUAAYACAAAACEAk9nX6vMAAABPAQAAGAAA>>temp64
echo AAAAAAAAAAAAAABNLgAAY3VzdG9tWG1sL2l0ZW1Qcm9wczIueG1sUEsBAi0AFAAG>>temp64
echo AAgAAAAhAPKcTzVMAQAAWwIAABEAAAAAAAAAAAAAAAAAni8AAGRvY1Byb3BzL2Nv>>temp64
echo cmUueG1sUEsBAi0AFAAGAAgAAAAhAEmOdn6cAQAAEwMAABAAAAAAAAAAAAAAAAAA>>temp64
echo ITIAAGRvY1Byb3BzL2FwcC54bWxQSwECLQAUAAYACAAAACEAdD85esIAAAAoAQAA>>temp64
echo HgAAAAAAAAAAAAAAAADzNAAAY3VzdG9tWG1sL19yZWxzL2l0ZW0xLnhtbC5yZWxz>>temp64
echo UEsBAi0AFAAGAAgAAAAhAFyWJyLDAAAAKAEAAB4AAAAAAAAAAAAAAAAA+TYAAGN1>>temp64
echo c3RvbVhtbC9fcmVscy9pdGVtMi54bWwucmVsc1BLBQYAAAAAEgASAMwEAAAAOQAA>>temp64
echo AAA=>>temp64
if %startnumber% lss 100 set Fixednumber=0%startnumber%
if %startnumber% lss 10 set Fixednumber=00%startnumber%
certutil -decode -f temp64 "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.xlsx">nul
del temp64
echo 완료!
goto endRename