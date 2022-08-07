@echo off
chcp 65001>nul
setlocal ENABLEDELAYEDEXPANSION
set current=%~dp0
set batchname=%~nx0
rem ##########CurrentVersion:120:##########
set /a version=120
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
powershell Invoke-WebRequest -Uri 192.168.0.75/files/update%version%log.txt -OutFile %current%\%version%update.txt
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
if %ReName% equ 0 echo 인터넷 익스플로러 최초 실행이 필요합니다. & pause>nul & explorer "C:\Program Files\Internet Explorer\iexplore.exe" & exit
echo 현재 버전:%version%, 최신버전:%ReName%
if %ReName% equ %version% echo 현재 최신 버전입니다. & timeout /t 3 > nul & goto init
if %ReName% lss %version% echo 서버의 버전보다 높습니다. 버전을 확인하세요. & pause>nul & start http://192.168.0.75/ & goto init
choice /c yn /m "업데이트 가능한 버전이 있습니다. 업데이트를 진행하시겠습니까?"
if %errorlevel% equ 0 goto quit
if %errorlevel% equ 1 goto UpdateProgram
if %errorlevel% equ 2 goto init
:init
set listname=filelist.txt
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
:InputSoundtype
echo 소리/소음 분류 (오디오 확장자는 .m4a, .mp3, .wav만 지원합니다.)
choice /c 12 /n /m "1.소음 2.소리"
if %errorlevel% equ 0 exit
if %errorlevel% equ 1 cls & goto TypeNoise
if %errorlevel% equ 2 cls & goto TypeSound
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
:Cat01
if "%category2%" equ "01" goto inputWorkerCode
if "%category2%" equ "02" goto inputWorkerCode
if "%category2%" equ "03" goto inputWorkerCode
if "%category2%" equ "04" goto inputWorkerCode
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype

if "%category1%" equ "02" (
 echo  01 ^| 경장비소음 
 echo  02 ^| 중장비소음 
 set /p category2=소분류ID : 
 goto Cat02
)
:Cat02
if "%category2%" equ "01" goto inputWorkerCode
if "%category2%" equ "02" goto inputWorkerCode
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
if "%category1%" equ "03" (
 echo  01 ^| 공장 
 set /p category2=소분류ID : 
 goto Cat03
)
:Cat03
if "%category2%" equ "01" goto inputWorkerCode
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
if "%category1%" equ "04" (
 echo  01 ^| 실내시설 
 echo  02 ^| 실외시설 
 set /p category2=소분류ID : 
 goto Cat04
)
:Cat04
if "%category2%" equ "01" goto inputWorkerCode
if "%category2%" equ "02" goto inputWorkerCode
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
if "%category1%" equ "05" (
 echo  01 ^| 실내기타소음 
 echo  02 ^| 실외기타소음 
 set /p category2=소분류ID : 
 goto Cat05
)
:Cat05
if "%category2%" equ "01" goto inputWorkerCode
if "%category2%" equ "02" goto inputWorkerCode
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
goto inputNoiseCat
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
:inputNoiseCat
echo --------------------
set /p category2=소분류ID : 
goto inputWorkerCode
:TypeSound
set last=SS
set category1=00
echo 소리 대분류표
echo --------------------
echo  01 ^| 사람의 비언어적소리 
echo  02 ^| 동물 및 자연물소리 
echo  03 ^| 전자제품 및 생활환경소리 
echo  04 ^| 기타소리 
echo --------------------
set /p category2=대분류ID : 
if "%category2%" equ "01" goto inputWorkerCode
if "%category2%" equ "02" goto inputWorkerCode
if "%category2%" equ "03" goto inputWorkerCode
if "%category2%" equ "04" goto inputWorkerCode
echo 해당 코드가 존재하지 않습니다. & pause>nul
cls & goto InputSoundtype
:inputWorkerCode
rem ##########워커코드 입력 (default:000)##########
set /p workercode=워커코드 : 
rem ##########날짜 입력##########
set /p setdate=날짜(ex:220628) : 
rem ##########선택 옵션##########
choice /c 12 /n /m "1.이름재설정, 2.파일복사 : "
if %errorlevel% equ 0 exit
if %errorlevel% equ 1 goto rename
if %errorlevel% equ 2 goto copyname
:rename
echo.
set option=rename
rem ##########파일 개수 계산(디렉터리  제외)##########
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
if %listnum% lss 1 (set option=renError & goto quit)
echo 현재 폴더의 오디오 파일 개수 : %listnum%, wav:%wavnum%, m4a:%m4anum%, mp3:%mp3num%
echo (지원하는 오디오 파일 형식 m4a, mp3, wav)
if %m4anum% geq 1 (if %mp3num% geq 1 (goto ContinueProcess))
if %mp3num% geq 1 (if %wavnum% geq 1 (goto ContinueProcess))
if %m4anum% geq 1 (if %wavnum% geq 1 (goto ContinueProcess))
:ContinueProcess
choice /m "오디오 파일 형식이 섞여있습니다. 계속하시겠습니까?"
if %errorlevel% equ 0 exit
if %errorlevel% equ 1 goto inputStartnumber
if %errorlevel% equ 2 set option=cancel goto quit
rem ##########시작값 입력##########
:inputStartnumber
echo.
echo 시작할 번호를 입력해 주세요. (001부터 시작하려면 1을 입력해주세요.)
set /p number=시작 번호 : 
set /a startnumber=number
set /a listnum=listnum+number-1
rem ##########skip=0은 지원하기 않음, skip=1부터 시작##########
for /f "tokens=*" %%i in (%listname%) do (set temp=%%i & goto getNameFirst)
:getNameFirst
for /f "tokens=2 delims=." %%i in (%listname%) do (set fileExt=%%i & goto getExtension)
:renLoop
if %number% gtr %listnum% goto quit
for /f "tokens=* skip=%skips%" %%i in (%listname%) do (set temp=%%i & goto getName)
:getName
rem 파일이름에 .을 2개 이상으로 설정할 시 확장자 변경 오류(파일 이름에 .은 1개씩)
for /f "tokens=2 delims=. skip=%skips%" %%i in (%listname%) do (set fileExt=%%i & set /a skips=skips+1 & goto getExtension)
:getExtension
rem ##########지원하지 않는 확장자는 변경X##########
if "%fileExt%" equ "m4a " goto allowExtension
if "%fileExt%" equ "mp3 " goto allowExtension
if "%fileExt%" equ "wav " goto allowExtension
goto renLoop
:allowExtension
rem ##########숫자 형식 설정 001~999 (010 != 8 error)##########
set Fixednumber=%number%
if %number% lss 100 set Fixednumber=0%number%
if %number% lss 10 set Fixednumber=00%number%
ren "%temp%" "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.%fileExt%"
set /a number=number+1
goto renLoop
:copyname
echo.
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
if %startnumber% lss 100 set Fixednumber=0%startnumber%
if %startnumber% lss 10 set Fixednumber=00%startnumber%
if %option% equ rename (del /f %listname% & if not exist "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.xlsx" (goto createExcel))
if %option% equ cancel (del /f %listname% & echo 이름바꾸기가 취소되었습니다.)
if %option% equ renError (del /f %listname% & echo 해당 디렉터리에 지원하는 오디오 파일이 없습니다.)
if %option% equ copyname echo ########복사 완료!########
:Exitprogram
choice /c 12 /n /m "1.계속하기 2.종료하기"
if %errorlevel% equ 0 exit
if %errorlevel% equ 1 cls & goto OnDirectory
if %errorlevel% equ 2 echo 프로그램을 종료합니다. & pause>nul
endlocal
exit
:createExcel
choice /m "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.xlsx 파일이 없습니다. 새로 만드시겠습니까?"
if %errorlevel% equ 0 exit
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
echo BgAA//8DAFBLAwQUAAYACAAAACEATxNW9jQCAACCBAAADwAAAHhsL3dvcmtib29r>>temp64
echo LnhtbKxUy27bMBC8F+g/ELw7ekSyHcFS4NguaiAoDOd10YWm1hZhilRJKrYR9N+7>>temp64
echo kuo2bS4p2ot2lxSHM7MkJ9fHSpJnMFZoldLgwqcEFNeFULuUPtx/GowpsY6pgkmt>>temp64
echo IKUnsPQ6+/hhctBmv9F6TxBA2ZSWztWJ51leQsXsha5B4cxWm4o5LM3Os7UBVtgS>>temp64
echo wFXSC31/6FVMKNojJOY9GHq7FRzmmjcVKNeDGJDMIX1bitqe0Sr+HriKmX1TD7iu>>temp64
echo aoTYCCncqQOlpOLJcqe0YRuJso9BfEbG9A10JbjRVm/dBUJ5Pck3egPfC4JecjbZ>>temp64
echo CgmPve2E1fUXVrW7SEoks25RCAdFSodY6gP8NmCa+qYREmeDKAp96mU/W7EyWCDv>>temp64
echo qXRgFHMw08qhTT8M/ldLOuxZqbEBZA1fG2EA+946k03wy3jCNnbFXEkaI1M6S/IH>>temp64
echo iwrzu3U+res5cyy/1ZzJfImsTJ1PG6fXoFB5XsBz/spf9rZ5f+Ew460pHhrRk+3z>>temp64
echo P03JJu3pfRRwsL8cbEtyfBKq0IeU4l04vcoP3fCTKFyJ5o/CGOf7sc8gdqVLaTwc>>temp64
echo x93er6C7845bdJG0alN6196BAC9WG5dtKykxicDELIugQzgvQ7/4ypA2dD/GYRx0>>temp64
echo f8DR3VqXTTCi3yKlL0HkT0f+VTTwF5fxIBpfhYNxdBkOZtE8XMSjxXxxE3/7v6cY>>temp64
echo 256cH4KWZcmMuzeM7/H5WMP2hllU2wtCntiIM2vvvCr7DgAA//8DAFBLAwQUAAYA>>temp64
echo CAAAACEAwWoUrhwCAACgBAAAFAAAAHhsL3NoYXJlZFN0cmluZ3MueG1srFRNb9Mw>>temp64
echo GL4j8R8sn8aBOg0IJpRm0rqCJjSBmlWIUxU1XhupsUPsFnpBY7RsKpFgoqAI2qqH>>temp64
echo DQbiMFg1qAR/qHb+Ay5FaKSDA93BSfw+7/v4/XgcY+mBVwV1HDCXkgxMpzQIMClR>>temp64
echo xyXlDCysX7+4CAHjNnHsKiU4AxuYwSXz/DmDMQ5ULGEZWOHcv4YQK1WwZ7MU9TFR>>temp64
echo yAYNPJurbVBGzA+w7bAKxtyrIl3TriDPdgkEJVojPAP1SxDUiHuvhrO/DabBXNPg>>temp64
echo pnwSircfgWiN5JcDIPv7ygAW4qipPpFs78Xtruh0ZLR3wUDcNNAkahppOX7VLuGk>>temp64
echo WUv/tPgVVRB3S7cDsEEJX3VU+RDwhq+qJDRLya+uQPQHaRyGsvdNfGglaScJ9kKg>>temp64
echo QNl/fjoon3Zlf1c9x4dNsKClH+qXZ5KWO5F8t6sogPzeES+6SaZpO+QbhY+GcSsc>>temp64
echo Hw0m7ZGDl+JoeLozkI8fyeZXcdwU+9G/XbaG8vX7v7hMJ6C6LkYq+7g7FOFm/OwQ>>temp64
echo TQufDGYUzZSTz2WLd9dWkpQTs7W+upZLAndu5W/m8rOTzNocl2nQSCI3CstFq7Bs>>temp64
echo zZxgOVnqeZjwWa4VXHfPWha6proBxNaBbH6SvUjptCV3BkC+2h5/DkHcjZRuRD8E>>temp64
echo 4nhTtDtgOsV5dKhpRS1dvKqWrmtp9dLUsqzUfbs+D+3JCzUPz0lR/B8PUn8Y8wcA>>temp64
echo AAD//wMAUEsDBBQABgAIAAAAIQA7bTJLwQAAAEIBAAAjAAAAeGwvd29ya3NoZWV0>>temp64
echo cy9fcmVscy9zaGVldDEueG1sLnJlbHOEj8GKwjAURfcD/kN4e5PWhQxDUzciuFXn>>temp64
echo A2L62gbbl5D3FP17sxxlwOXlcM/lNpv7PKkbZg6RLNS6AoXkYxdosPB72i2/QbE4>>temp64
echo 6twUCS08kGHTLr6aA05OSonHkFgVC7GFUST9GMN+xNmxjgmpkD7m2UmJeTDJ+Ysb>>temp64
echo 0Kyqam3yXwe0L0617yzkfVeDOj1SWf7sjn0fPG6jv85I8s+ESTmQYD6iSDnIRe3y>>temp64
echo gGJB63f2nmt9DgSmbczL8/YJAAD//wMAUEsDBBQABgAIAAAAIQDKu0bYWAcAAMcg>>temp64
echo AAATAAAAeGwvdGhlbWUvdGhlbWUxLnhtbOxZW4sbNxR+L/Q/DPPu+DbjyxKn+JpN>>temp64
echo srsJWSelj1pb9mhXMzKSvBtTAiWl0EIpFNLSl0Lf8lBKCy209KU/ZiGhTfsfeqQZ>>temp64
echo e6S13Nw2JS27hsUjf+fo6JyjT2eOLr9zL6beMeaCsKTlly+VfA8nIzYmybTl3xkO>>temp64
echo Cg3fExIlY0RZglv+Agv/nStvv3UZbckIx9gD+URsoZYfSTnbKhbFCIaRuMRmOIHf>>temp64
echo JozHSMIjnxbHHJ2A3pgWK6VSrRgjkvhegmJQe3MyISPs/fXRp08ffexfWWrvU5gi>>temp64
echo kUINjCjfV7qxJaKx46OyQoiF6FLuHSPa8mGiMTsZ4nvS9ygSEn5o+SX95xevXC6i>>temp64
echo rUyIyg2yhtxA/2VymcD4qKLn5NOD1aRBEAa19kq/BlC5juvX+7V+baVPA9BoBCtN>>temp64
echo bbF11ivdIMMaoPSrQ3ev3quWLbyhv7pmcztUHwuvQan+YA0/GHTBixZeg1J8uIYP>>temp64
echo O81Oz9avQSm+toavl9q9oG7p16CIkuRoDV0Ka9XucrUryITRbSe8GQaDeiVTnqMg>>temp64
echo G1bZpaaYsERuyrUYHTI+AIACUiRJ4snFDE/QCNK4iyg54MTbIdMIEm+GEiZguFQp>>temp64
echo DUpV+K8+gf6mI4q2MDKklV1giVgbUvZ4YsTJTLb866DVNyCPf/nl9MFPpw9+Pv3w>>temp64
echo w9MH32dza1WW3DZKpqbc00ef//n1B94fP37z9OEX6dRn8cLEP/nukye//vZP6mHF>>temp64
echo uSsef/nDk59+ePzVZ79/+9Chvc3RgQkfkhgLbw+feLdZDAt02I8P+ItJDCNELAkU>>temp64
echo gW6H6r6MLODeAlEXroNtF97lwDIu4NX5oWXrfsTnkjhmvhHFFnCXMdph3OmAG2ou>>temp64
echo w8PDeTJ1T87nJu42QseuubsosQLcn8+AXolLZTfClpm3KEokmuIES0/9xo4wdqzu>>temp64
echo PUIsv+6SEWeCTaT3HvE6iDhdMiQHViLlQtskhrgsXAZCqC3f7N71Ooy6Vt3DxzYS>>temp64
echo tgWiDuOHmFpuvIrmEsUulUMUU9PhO0hGLiP3F3xk4vpCQqSnmDKvP8ZCuGRucliv>>temp64
echo EfQbwDDusO/SRWwjuSRHLp07iDET2WNH3QjFM6fNJIlM7DVxBCmKvFtMuuC7zN4h>>temp64
echo 6hnigJKN4b5LsBXuZxPBHSBX06Q8QdQvc+6I5VXM7P24oBOEXSzT5rHFrm1OnNnR>>temp64
echo mU+t1N7BmKITNMbYu3PNYUGHzSyf50Zfj4BVtrErsa4jO1fVc4IF9nRds06RO0RY>>temp64
echo KbuPp2yDPbuLM8SzQEmM+CbNexB1K3XhlHNS6U06OjKBewTqP8gXp1NuCtBhJHd/>>temp64
echo k9ZbEbLOLvUs3Pm64Fb8nmePwb48fNF9CTL4hWWA2J/bN0NErQnyhBkiKDBcdAsi>>temp64
echo VvhzEXWuarG5U25ib9o8DFAYWfVOTJJnFj9nyp7w3yl73AXMORQ8bsWvUupsopTt>>temp64
echo MwXOJtx/sKzpoXlyC8NJss5ZF1XNRVXj/++rmk17+aKWuahlLmoZ19vXa6ll8vIF>>temp64
echo Kpu8y6N7PvHGls+EULovFxTvCN31EfBGMx7AoG5H6Z7kqgU4i+Br1mCycFOOtIzH>>temp64
echo mXyXyGg/QjNoDZV1A3MqMtVT4c2YgI6RHta9VHxGt+47zeNdNk47neWy6mqmLhRI>>temp64
echo 5uOlcDUOXSqZomv1vHu3Uq/7oVPdZV0aoGRfxAhjMtuIqsOI+nIQovBPRuiVnYsV>>temp64
echo TYcVDaV+GaplFFeuANNWUYFXbg9e1Ft+GKQdZGjGQXk+VnFKm8nL6KrgnGukNzmT>>temp64
echo mhkAJfYyA/JIN5WtG5enVpem2nNE2jLCSDfbCCMNI3gRzrLTbLmfZ6ybeUgt85Qr>>temp64
echo lrshN6PeeB2xViRyhhtoYjIFTbyTll+rhnCtMkKzlj+BjjF8jWeQO0K9dSE6hXuX>>temp64
echo keTphn8ZZplxIXtIRKnDNemkbBATiblHSdzy1fJX2UATzSHatnIFCOGNNa4JtPKm>>temp64
echo GQdBt4OMJxM8kmbYjRHl6fQRGD7lCuevWvzlwUqSzSHc+9H4xDugc34bQYqF9bJy>>temp64
echo 4JgIuDgop94cE7gJWxFZnn9nDqaMds2rKJ1D6TiiswhlJ4pJ5ilck+jKHP208oHx>>temp64
echo lK0ZHLruwoOpOmBf+dR99lGtPGeQZn5mWqyiTk03mb6+Q96wKj9ELatS6tbv1CLn>>temp64
echo uuaS6yBRnafEM07d5zgQDNPyySzTlMXrNKw4Oxu1TTvHgsDwRG2D31ZnhNMTL3vy>>temp64
echo g9zZrFUHxLKu1Imv78zNW212cAjk0YP7wzmVQocS7qw5gqIvvYFMaQO2yD2Z1Yjw>>temp64
echo zZtz0vLfL4XtoFsJu4VSI+wXgmpQKjTCdrXQDsNquR+WS71O5T4cLDKKy2F6Xz+A>>temp64
echo Kwy6yG7t9fjazX28vKW5NGJxkemb+aI2XN/clyuum/uhupn3PQKk836tMmhWm51a>>temp64
echo oVltDwpBr9MoNLu1TqFX69Z7g143bDQH933vWIODdrUb1PqNQq3c7RaCWkmZ32gW>>temp64
echo 6kGl0g7q7UY/aN/PyhhYeUofmS/AvdquK38DAAD//wMAUEsDBBQABgAIAAAAIQAK>>temp64
echo MPIDTQQAAAUWAAANAAAAeGwvc3R5bGVzLnhtbORYwY7bNhC9F+g/CLx7JdmSVjIs>>temp64
echo B/F6BQRIgwK7BXqlJcomQpGGRG/lFAXyCwHaWwPkUKAf0L9q0n/okJIs2Zva3q13>>temp64
echo kW19sUiRM2/eDIejGT0rM2bckLyggofIPrOQQXgsEsrnIfruOur5yCgk5glmgpMQ>>temp64
echo rUmBno2//mpUyDUjVwtCpAEieBGihZTLoWkW8YJkuDgTS8LhTSryDEsY5nOzWOYE>>temp64
echo J4XalDGzb1memWHKUSVhmMXHCMlw/nq17MUiW2JJZ5RRudaykJHFwxdzLnI8YwC1>>temp64
echo tB0cG6Xt5f1Gg566pSSjcS4KkcozEGqKNKUxuY01MAMTx60kEHs/SbZrWv3K8PEo>>temp64
echo FVwWRixWXIZI4VSgh6+5+IFH6hX4BFWrxqPijXGDGcz0kTkexYKJ3JBANthqqxmO>>temp64
echo M1Kt+Pj7u0/v3xp//vHh48+/qFcpzihbVy+r3QucF+C7WmCgFmnP1RIyCjyqSVMh>>temp64
echo 3EXgP7Q6rbUAtZSxDT2uYgImxiPwvCQ5j2Bg1M/X6yXwwCFIK9R63YHV8xyv7b57>>temp64
echo /IZCMJooFPMLzX4+n4Uo0j/LUmJm9QvKE1KSJESeo6V3ACtKjwG3q6v29DkyJFXB>>temp64
echo Yp2dB0Hg257v+4EzsB1HO/bhEQQnRKCpAD/PRJ5AEmoOwjlwXE2NR4ykEpjN6Xyh>>temp64
echo /qVYKp6FlHBWx6OE4rngmKlIbXZ0d0LygjwVoowkdJWB2OrY7PpHKal1NDvkAjJT>>temp64
echo sx6vpKhPmamRaCAHlwLYBuvBtZVJj2bRLgO3rTpA2SHbdhXc1b4t/u/qr/+cdQec>>temp64
echo 8X/z3t7g+NIi886+ezTr6pQJCTgmjF2pVPl9usnCqvIoU4OvsiiTL+Ayg+JQVQPN>>temp64
echo I9xi9WOVcavBeIQZnfOMcKguSC5prGqWGIakKijKFHJ1V1+lvat4cC/NRpneAcIR>>temp64
echo ljnIaC2zoTir5Rt4uWRrVZ+pO6EeARvtaKLvs3b8vKGkqueOYOgIeFAutvBU7Xh6>>temp64
echo eAuR0zdgZ8eF/+zULcgOlAmfCZYtzINdzK9W2Yzkkf5k6FB7CqLvb8nno36/ISeJ>>temp64
echo jYclH4J7O2CeKvkPczBPTj4Ee3ta3SdM/n5DvszI38LsPWHyIRntiaJt8o++hE4e>>temp64
echo 6/tRHpNoHgH7EdXMrUh5DIJ1bQTVUKco2yrJNqWToRo+Ifrr3a+ffnvbienZijLo>>temp64
echo EVS1kPow3uwAmUnZFni6ZSFVt0yXfhstwExCUrxi8nrzMkTt8zf6YxpuwHrVt/RG>>temp64
echo SC0iRO3zS/XFbnuq/0FK+bKAD2z4N1Y5DdGPl5PzYHoZ9Xu+NfF7zoC4vcCdTHuu>>temp64
echo czGZTqPA6lsXP3Xadv+iaadbjFDJ2s6wYNDay2tja/BX7VyIOoMKvu7eAOwu9qDv>>temp64
echo Wc9d2+pFA8vuOR72e743cHuRa/ennjO5dCO3g929Z5vQMm27aROWtjuUNCOM8sZX>>temp64
echo jYe6s+AkGO4xwmw8Ybb92/HfAAAA//8DAFBLAwQUAAYACAAAACEA5P+cxLwDAACx>>temp64
echo CgAAGAAAAHhsL3dvcmtzaGVldHMvc2hlZXQxLnhtbJRW247iOBB9X2n/Icr75MYd>>temp64
echo ASM1PUzT0qxW2zO7z8YxYHUSZ20D3fP1e2wn0AnRKPuCE3LqVPlUlcuLz2955p2Z>>temp64
echo VFwUSz8OIt9jBRUpLw5L/8f3zaep7ylNipRkomBL/50p//Pq998WFyFf1ZEx7YGh>>temp64
echo UEv/qHU5D0NFjywnKhAlK/BlL2RONF7lIVSlZCS1RnkWJlE0DnPCC98xzGUfDrHf>>temp64
echo c8oeBT3lrNCORLKMaMSvjrxUNVtO+9DlRL6eyk9U5CUodjzj+t2S+l5O59tDISTZ>>temp64
echo Zdj3WzwktOa2L3f0OadSKLHXAehCF+j9nmfhLATTapFy7MDI7km2X/oP8fx56Ier>>temp64
echo hdXnb84u6sOzp8nuhWWMapYiTb73U4j8hRIT2nT04fUPo3fm/jQp2gnxasi2MIvg>>temp64
echo VVkS45VQzc9szTKgn8bI8r82DjwiiPAaxcfnOqKNTeqf0kvZnpwyvRbZPzzVR0QW>>temp64
echo BdPpeBJPJwiq+vqXuDwxfjhqfJ4ECT5Y/ebp+yNTFFlEZMHAeKUigwv8ejk31Ygk>>temp64
echo kDe7Xhx9EoxGw7ElpyelRV67raydXVLZYa3sBvDrYvqF2aAyw1qZzW7udkzpDTdb>>temp64
echo 8L1fcAwrDqx1yFHtuicF9LG7xlpRxPH/pEA2LQXWmmIWTCaTwXBg8tIzkEnFgrVm>>temp64
echo gTQ9jXFs2BCwXnPQ23hWGWOtVZwGw2E8jMamfHqGEOMsc/WDh5qnvw6hq0bbCI9E>>temp64
echo k9VCiouHQwoVoEpijrxkbnzYwsY+9ZHT1wfhaqSrxEemSisS1GaDpLMl0AvG4YMB>>temp64
echo wxtcLH2FJj6vBovwjM6kFWLtEEjPFTFsIh7vEaMm4ss9YtxEbO4Rkybi6z1i2kQ8>>temp64
echo 3SNmTcTWIdBB171ETcSzQ6ASroj4Bgmh8FVmKNJfZgNe+vb8s7qv3R+o/5ufuCVr>>temp64
echo ByRp6doBaaVv0wFp5e9rB6SVwKcOSCuDWwcxxVpXUmtDzw6BzrshbkluaIsM9dfW>>temp64
echo gG3rXGmTVlbXFcRMqfMqSaI4aovdQMQtEb80vk7axpvqM7r3FkKrejsgcbt+uzDt>>temp64
echo Cu5y1da5wnxs6uRWOU5oN4Xd4ZMzebDTWnlUnMzQjCHU9d/qEpHMH+wkDW/w1aI8>>temp64
echo 4uqmOcXA3otCm6uAUeG9xOWhEGtRVPc/czyV5MC+EXnghfIytrezGQ0g3fyOAtMM>>temp64
echo ojQT204SoTGE67cjbncM55WZ5vAkdP1S8b4wfSq9kpRMvvCfcI4qE5LjBmCvb0u/>>temp64
echo FFJLwjX8zTmilNs0treR62Vz9R8AAAD//wMAUEsDBBQABgAIAAAAIQCT2dfq8wAA>>temp64
echo AE8BAAAYACgAY3VzdG9tWG1sL2l0ZW1Qcm9wczIueG1sIKIkACigIAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGSQwWrDMBBE74X+g9m7LTWJ5STYDjWO>>temp64
echo IdfSQq9CXscCS2skObSU/ntlekp7WmaHnTdsefowU3JD5zXZCp4yDglaRb221wre>>temp64
echo Xrt0D4kP0vZyIosVWIJT/fhQ9v7YyyB9IIeXgCaJCx3npa3gqytEk28Knord8zbd>>temp64
echo ifacNoKf00ORd4If8qZt99+QRLSNMb6CMYT5yJhXIxrpM5rRRnMgZ2SI0l0ZDYNW>>temp64
echo 2JJaDNrANpwLppaIN+9mgnrt83v9goO/l2u1xel/FKOVI09DyBQZ5kfpcCYdw29b>>temp64
echo psiGyAmfM7K1hgdWl+wPZNV3T6h/AAAA//8DAFBLAwQUAAYACAAAACEAXJYnIsMA>>temp64
echo AAAoAQAAHgAIAWN1c3RvbVhtbC9fcmVscy9pdGVtMi54bWwucmVscyCiBAEooAAB>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAITPwWrDMAwG4Huh72B0X5z2MEqJ00sZ5DZGC70aR0lM>>temp64
echo Y8tYSmnffqanFgY7SkLfLzWHe5jVDTN7igY2VQ0Ko6Pex9HA+fT1sQPFYmNvZ4po>>temp64
echo 4IEMh3a9an5wtlKWePKJVVEiG5hE0l5rdhMGyxUljGUyUA5WSplHnay72hH1tq4/>>temp64
echo dX41oH0zVdcbyF2/AXV6pJL8v03D4B0eyS0Bo/wRod3CQuES5u9MiYts84hiwAuG>>temp64
echo Z2tblXtBt41++6/9BQAA//8DAFBLAwQUAAYACAAAACEAdD85esIAAAAoAQAAHgAI>>temp64
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
echo f90LAAD//wMAUEsDBBQABgAIAAAAIQBN8/5ItAEAAPwEAAAnAAAAeGwvcHJpbnRl>>temp64
echo clNldHRpbmdzL3ByaW50ZXJTZXR0aW5nczEuYmlu7FPNbtNAEP7sRAiEBJw4oB4i>>temp64
echo TlwiNdRt1KOTbamj+gf/oF5NMpSVXK+1XlctVd8DwQv0LXgR3gVm3UQCCSGBeuDA>>temp64
echo rmZnPJ7vm5n9OUKCXUzxklcf+xjhBY7YN0KMdzwlliAsWAz7Emgo1tMeAR7OcHDv>>temp64
echo K0bDwRe4Dh7g00Pv/goOHuPEdVmfuANefXg2+I6Gs+ax2rU1sHzj8SrIfkojgqh4>>temp64
echo jhtnONzCs6efg9+lf7T+aWvu+/oheJPvDlv4T/UP7sCfnPMNB2dhvrBtPMFH5woz>>temp64
echo fhMT7PGc4JDv+7i/9QJztjzsQLB3zFHzPmrMnn327fCcsp6s398urpkxqJvOzGSN>>temp64
echo wzgNs7hI5wdIDzJxfIyilppaayVlQzqTHwi+xx+nNFN6RbqitkWkakJIK1nmlw0h>>temp64
echo y/1I+KlA3JkNc7mkosFCvbXQ2CKR0jnplhBrSbUpjVQ1kjjNUz/I+wy38NddWUlz>>temp64
echo yUn0WVlhrqqqNIyKLFtUNAkXuMELrnbZE6Xy9L2ZKWPUGUTXVHSBKI64L2pV1fUh>>temp64
echo Ign2trcvWCyp0qFa0a3117dli5FvPBH+6my/AwAA//8DAFBLAwQUAAYACAAAACEA>>temp64
echo 0o4RpwgKAAASLwAAEwAoAGN1c3RvbVhtbC9pdGVtMS54bWwgoiQAKKAgAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7FpLj9zGEb4b8H8gmDOXj+HMcAYa>>temp64
echo GdKslAiRLMG7cXIzmt3NHUYccszH7iyMAArkAAbkQ4DAgA8yoEMCI0GCHOwkOiR/>>temp64
echo yLP6D6nu5pvzIDlyHASRDtJwWNXV1dVfVX01t95bLz3pkoaRG/gzWT/RZIn6OCCu>>temp64
echo fzGTk9hRLPm927dwPMWBH1M/Pr9e0TO8oEskwcOPZrIsLVH+b+ml99GSzuTNn1/f>>temp64
echo fPqSv1P67sHpTNbWmg5/tfvj0V3t7uldXR+Y85FpTMamoWvWeDC/b83Ne6d12Q9z>>temp64
echo W8FUWLqk9pRGOHRXMd/KzfPPJLH65g//lDZff7753V82Lz7bvPj9SV3uDAcrsJU/>>temp64
echo Tl3BLKQT2zGwrZnEosgZGyaZEDqyR9oQTwyiD2QJfOdHUxzP5EUcr6aqGnHPRCdL>>temp64
echo F4dBFDjxCQ6WauA4LqaqoWkjdUljRFCM1JLdmaIl6qNoFYL1YezSiCu/E8ehaycx>>temp64
echo jeTb775zax2RqbBKilF4QWN2LtEKYdhwd6OLtbizwiCAvcdhQvlHx6UeiZjrnAFG>>temp64
echo 1Das0WhgGGNqEdMxjIlpGpQa1HEMWfIjQ0SNHw3Ef4Qzwd7csKurq5OrwUkQXjDf>>temp64
echo 6eovHj0UoZc5bB21f3d17H6FfWD3TB4NbDJ0rIEyGBNbMUfUUSZUGyjmmI4nRBuZ>>temp64
echo dDjMbIT9zWTDsU2HDnVFQ2NLMYeWqVjawFAcezIcUmrZmE7y43KXqyCMJb84qFbr>>temp64
echo qdlxN+VbLZ/LU48u4aZzA2Zy6cizBSCmVx5dMyjIQ4x+nABu5J+rOkiAE6byEfLR>>temp64
echo BVeeb3aLLuR5mdpMTUidmcxC5hElLjqj4SVcqEfpVYLYc/3HGCchhIMmN/axVfg+>>temp64
echo iuLOCjzsjEeOPhxiSkxCsG1qkzHglgPxPhgYTktLBtNztJ6jGC/ueF4v6x/PP+gl>>temp64
echo 92Pq0xAxgDx3l+zSdnfcvUs4yJ+gaDEPSFsNg+nZAoWU/NyNFz+LAMBbO6qQO4XT>>temp64
echo dr2tkioDuTRq+P9rQcWfpaHEIot/jkoR216I4/shXG0HD6lB94NweUodlHgApR8n>>temp64
echo yHMBRkmBcN8THJJlgZ2Hs1bzAqsx3H44DYGKK9wOXV3fCVYoXjA8H6tPUBhDPM6h>>temp64
echo sggDONrdANY6U+00dA86tlG+3/Ad0LkDrNDU9Qldz2QL0qDrecj2IBnnWZS40cpD>>temp64
echo 16J+2qli4RJCoWLLxVwoz0IfeQfkQorIY9+7TiXzUIak4dEyooc0gkICM6yQbBSB>>temp64
echo hRAy0/eDmAqEFZeoIla/Z+xaVhNBeTs1BM69MunmlYaaDp5pyP6w3mmRXnIv6fpW>>temp64
echo N8VoHfjBMjteViBXA6PVGpmW+6ygawbUgyVk8XN0wcAYTSvxevPVt5u/vr75+pn0>>temp64
echo 5vnL7/7xWpSJecw5yItKteIDALdPhmlSVVhWVVhaVVheVcqJ9VdcT2bWI8BKtxT6>>temp64
echo UbRimpyJYdiaM1QI1OhQlUG5ZVuGpdiI2AjbIwsNTaGHhsszGjMZbWLpJiYDZTiy>>temp64
echo qOLQiaawJ4pFRobuOJZjW0IG+XgRhHwZG/Q49kDBA6qDiKUraDweKRiZ9miimxY2>>temp64
echo Ab7BMVCWVy5o9FN6fRWEzFLuhh7lFC9lVnh6Djuop0JYcp1VQbp8W2S5Y7Pe/iss>>temp64
echo ypAiJqElOgRo99ZxiHBMiXRO1zH3027kyvS/jWuZeRu89JD6F/FCukReArBmQK3O>>temp64
echo AZzDVwn2ilLhCJRrVFyFtyCwusD/Fk0doG6L9JFe5edXOC46wkn1mrLwEbRRXXzU>>temp64
echo VNTBRU3h/6SHRD5tVV+2auek/9eX/+v1ZbWLLC4No1cO1JUgyusEibehEvSh0jzw>>temp64
echo kqXPEblxaTw3gu7kE0ImY8vASBnpJmTYia2x5IqVwcSaEMfSdc3QRKquYnrd0GgR>>temp64
echo XPHaYiZnbfApcGJ87Stqd+RLtlAI6SPWWUC3mrMJa/jEiM5SQctrifkiAD7hYRA8>>temp64
echo TVYFa7aX0viQJQ9ZYl2QqIxT6XIWTnw7SKDUZ+VAudGun04JROtNKeRIYXKejJpb>>temp64
echo a9O9NvN4syMvAmh0OIC+++ZvNy9fSZvPn908//WWNL5N/Q44Per8GJ3Az7DlubH3>>temp64
echo H0AXWj+SUvFUHFtvwuu06OGyGOFELHRU/sUh8oMRfzP5DsYQPFCkloOMW98qnJoH>>temp64
echo nipkPV47m46gSX6IMC4IoiKQx4cD+ebT15u/P5NuXn2x+eZbSYT13ngur/NfXZh2>>temp64
echo qChqFAjrXIDYcYCaQnHECXiYGDyFrq8xxAipUh4KHCg6UDacqLBeiV/ivWwvwE9z>>temp64
echo QuxHQOulJFODYepvZa9RA3ScqZt2ziUU149i6BThgoklSMGLrZLQ454kWE29FKn6>>temp64
echo ia4W7wKBU2LlygL8m/zNAFiuA3xbln/VwCaHebU9tglu8GGAOWucr0oS23NhThhS>>temp64
echo vqeUQVRh15H6MewQ+L2BqpmqZqgEnwAYFbR8czyRunXbht/G8tx5VRuqrBTbxpN8>>temp64
echo ipaB4/z8o9oXOc1XyljplKT5cpY7dk0zCJ5igI84CPekIn3HNINABw2xIjQ064sK>>temp64
echo E7B9HgLLu0Agxoxt7miByE+V+WW1vKksn5ZIlfSXA7QY4VYZpH99+eY3v715/Up6>>temp64
echo 8+UXNy++2umBaezGXn0CUSVBBP3FuVbB4lRXevVy86c/7tYfJfYvKWYcRaV4a+dc>>temp64
echo UsyiuykQ3n0qqKL9HE/TtTvP2kP+RQL43ccWuPr0Igiv98q2sEXsLB2wvx1lIb10>>temp64
echo WUHfUVt+N30/iDmwZU+y+UH2UNrx53zhRoJAkoDMd5mLIileUMlPljYNpcCRInQJ>>temp64
echo z4JQyoyMTqRzeAOtVh4TYH0IKAHCaRVAVwJDAAkSrpSs4OcBUCWCtnwJ5MB1lyjC>>temp64
echo i1zZybvvbDNNsH71XYinqLLbw2S9x0ak8EsQNo+6e/Tpc+oyw61lqrZXOIqm7gwO>>temp64
echo Lul1P1qNC0XiEWFx1A8o9k+ODrE0LQqmtzmBS8uWVr+rSH1TTaVPYLgL1zH9rtHZ>>temp64
echo TctT13WUT4cyXrvSN1Vgl/PZ2fu1pTPpUsvUV1Z0R/ulIX4q+2CfmxPnHbYKENza>>temp64
echo H07ZwA3aw31b3dEbMos6Clf7wPbid0/nd6IowC5AHrkHBUR83fu4QVeqYXeOLXXj>>temp64
echo DMbKbq0fBHyb3xcASvjJCIxKxAL5r55S7+bvpaG0T661yNl1FNPlg7QHYEu2Fs1c>>temp64
echo Cklhl1yrMCv2ISKlvvs8TVcPfLc76moK6qCbhi2+6WlL3VUt1VRxqoi8vlAlPHsc>>temp64
echo YAkdWcB8QB0ash9R1bJiG+hLNRGYCneGvkwWaOPesjD56y3LSvNyhd1lvzAf+t7B>>temp64
echo estJC9q3C+ruPOreqthZ9xeGw+4vDKfdXxiOu78wnHd3YTEt73vRmXR7xvhQjupR>>temp64
echo LOQGHLMDnlW63zO+dp1wblzQt1ARsYWEjf3Ot+DJ99xKbmc+YlW3/ar99r8BAAD/>>temp64
echo /wMAUEsDBBQABgAIAAAAIQC2Ew6huwEAAH0EAAAYACgAY3VzdG9tWG1sL2l0ZW1Q>>temp64
echo cm9wczEueG1sIKIkACigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo ALSU3WrcMBCF7wt9h0X3svxvOcQbmvUWAg2UNoXcytJo19SSjCR3W0rfvbKTEpJs>>temp64
echo 2Ja2V2Ys5pyZ408+v/iqhtUXsK43ukFJFKMVaG5Er3cN+nTzFlO0cp5pwQajoUHa>>temp64
echo oIv161fnwp0J5pnzxsKVB7UKL/rwvGob9H27LdJNvC0xpW2Fc7qtMa2zS1yl6WUW>>temp64
echo t+km3bQ/0CpY6yDjGrT3fjwjxPE9KOYiM4IOh9JYxXwo7Y4YKXsOreGTAu1JGscl>>temp64
echo 4VOwV7dqQOt5nrvuDyDd43IebbL9MxfVc2uckT7iRt0b3Akr8GzejnCjfbC7+TYC>>temp64
echo Iv9MdbRhQet7cGR2euO97bvJgzvlcTgcokO25BECSMjt9buPS2T/ZbgXRcusE4Wk>>temp64
echo Gc4q0eG8BIlriDOcV1DVIi5zKIoXm1PZ5RKKBMesojgvaI5pnKVYdnVRANCOQ/33>>temp64
echo 64h7UK6ZZjtYkPHhI55M+BeBR9notTQj8/sZkoq8Z9ZrsJuAiDXDbysfYXtk/HOY>>temp64
echo 8hl7FvADKqcyGSc7LGQITmBYVnYkiRLyJ40erHInO46H1IerYjUbiOnE7EmeXMm5>>temp64
echo fvTLWP8EAAD//wMAUEsDBBQABgAIAAAAIQBJjnZ+nAEAABMDAAAQAAgBZG9jUHJv>>temp64
echo cHMvYXBwLnhtbCCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJySwU7cMBCG75V4h8h3>>temp64
echo 1llaIbRyjNBSxKFVV9qFu+tMNhaObdlDtNtbry1vAI/QB+Ch4B06ScSShZ56m5n/>>temp64
echo 1+/PY4vTTWOzFmIy3hVsOslZBk770rh1wa5WF4cnLEuoXKmsd1CwLSR2Kg8+iEX0>>temp64
echo ASIaSBlFuFSwGjHMOE+6hkalCcmOlMrHRiG1cc19VRkN517fNuCQH+X5MYcNgiuh>>temp64
echo PAy7QDYkzlr839DS644vXa+2gYClOAvBGq2Qbim/Gh198hVmnzcarOBjURDdEvRt>>temp64
echo NLiVueDjViy1sjCnYFkpm0Dw14G4BNUtbaFMTFK0OGtBo49ZMj9obUcs+64SdDgF>>temp64
echo a1U0yiFhdbah6WsbEkb5dH/3/PPP0++H51+PgpNlGPfl2D2uzSc57Q1U7Bu7gAGF>>temp64
echo hH3IlUEL6Vu1UBH/wTwdM/cMA/GAs6wBcDhzzNdfmk56kz33TVBuS8Ku+mLcTboK>>temp64
echo K3+uEF4Wuj8Uy1pFKOkNdgvfDcQl7TLaLmReK7eG8sXzXuie/3r443J6PMk/5vSy>>temp64
echo o5ngr79Z/gUAAP//AwBQSwMEFAAGAAgAAAAhAC5JkL1IAQAAWAIAABEACAFkb2NQ>>temp64
echo cm9wcy9jb3JlLnhtbCCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAISSX0vDMBTF3wW/>>temp64
echo Q8l7mzT7S2g7UNmTA3EVxbeQ3G3FJi1JtNu3N2232qHgY+4593fPvSRZHVUZfIGx>>temp64
echo RaVTFEcEBaBFJQu9T9FLvg6XKLCOa8nLSkOKTmDRKru9SUTNRGXgyVQ1GFeADTxJ>>temp64
echo WybqFB2cqxnGVhxAcRt5h/birjKKO/80e1xz8cH3gCkhc6zAcckdxy0wrAciOiOl>>temp64
echo GJD1pyk7gBQYSlCgncVxFOMfrwOj7J8NnTJyqsKdar/TOe6YLUUvDu6jLQZj0zRR>>temp64
echo M+li+Pwxfts8brtVw0K3txKAskQKJgxwV5mMLsmUJnhUaa9Xcus2/tC7AuTdKds+>>temp64
echo J/h31WO61D0LZOBzsD71RXmd3D/ka5RRQmlI5iGlOVkyMmPT+Xs79Kq/zdUX1Hn0>>temp64
echo v8RFSOOcLNiUMDobES+ArMt9/ReybwAAAP//AwBQSwMEFAAGAAgAAAAhAL2EYiOQ>>temp64
echo AAAA2wAAABMAKABjdXN0b21YbWwvaXRlbTIueG1sIKIkACigIAAAAAAAAAAAAAAA>>temp64
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAGyOOw7CMBAFr4LSky3o0OI0gQpR5QLGOIql>>temp64
echo rNfyLh/fHgdBgZR6nmYediS8dRzVRx1K8p3BE2caPKXZqpfNi+Yoh2ZSTXsAcZMn>>temp64
echo Ky0Fl1l41NYxgUw2+8QhKjx28LVptcFYXdIY7INUXzE9uzvV1Dlcs81lSSH8IB5v>>temp64
echo QdcnH4IX/1zHC0D4O27eAAAA//8DAFBLAQItABQABgAIAAAAIQB+UjBRiAEAAAwG>>temp64
echo AAATAAAAAAAAAAAAAAAAAAAAAABbQ29udGVudF9UeXBlc10ueG1sUEsBAi0AFAAG>>temp64
echo AAgAAAAhALVVMCP0AAAATAIAAAsAAAAAAAAAAAAAAAAAwQMAAF9yZWxzLy5yZWxz>>temp64
echo UEsBAi0AFAAGAAgAAAAhAJ6B1FARAQAA1gMAABoAAAAAAAAAAAAAAAAA5gYAAHhs>>temp64
echo L19yZWxzL3dvcmtib29rLnhtbC5yZWxzUEsBAi0AFAAGAAgAAAAhAE8TVvY0AgAA>>temp64
echo ggQAAA8AAAAAAAAAAAAAAAAANwkAAHhsL3dvcmtib29rLnhtbFBLAQItABQABgAI>>temp64
echo AAAAIQDBahSuHAIAAKAEAAAUAAAAAAAAAAAAAAAAAJgLAAB4bC9zaGFyZWRTdHJp>>temp64
echo bmdzLnhtbFBLAQItABQABgAIAAAAIQA7bTJLwQAAAEIBAAAjAAAAAAAAAAAAAAAA>>temp64
echo AOYNAAB4bC93b3Jrc2hlZXRzL19yZWxzL3NoZWV0MS54bWwucmVsc1BLAQItABQA>>temp64
echo BgAIAAAAIQDKu0bYWAcAAMcgAAATAAAAAAAAAAAAAAAAAOgOAAB4bC90aGVtZS90>>temp64
echo aGVtZTEueG1sUEsBAi0AFAAGAAgAAAAhAAow8gNNBAAABRYAAA0AAAAAAAAAAAAA>>temp64
echo AAAAcRYAAHhsL3N0eWxlcy54bWxQSwECLQAUAAYACAAAACEA5P+cxLwDAACxCgAA>>temp64
echo GAAAAAAAAAAAAAAAAADpGgAAeGwvd29ya3NoZWV0cy9zaGVldDEueG1sUEsBAi0A>>temp64
echo FAAGAAgAAAAhAJPZ1+rzAAAATwEAABgAAAAAAAAAAAAAAAAA2x4AAGN1c3RvbVht>>temp64
echo bC9pdGVtUHJvcHMyLnhtbFBLAQItABQABgAIAAAAIQBcliciwwAAACgBAAAeAAAA>>temp64
echo AAAAAAAAAAAAACwgAABjdXN0b21YbWwvX3JlbHMvaXRlbTIueG1sLnJlbHNQSwEC>>temp64
echo LQAUAAYACAAAACEAdD85esIAAAAoAQAAHgAAAAAAAAAAAAAAAAAzIgAAY3VzdG9t>>temp64
echo WG1sL19yZWxzL2l0ZW0xLnhtbC5yZWxzUEsBAi0AFAAGAAgAAAAhAE3z/ki0AQAA>>temp64
echo /AQAACcAAAAAAAAAAAAAAAAAOSQAAHhsL3ByaW50ZXJTZXR0aW5ncy9wcmludGVy>>temp64
echo U2V0dGluZ3MxLmJpblBLAQItABQABgAIAAAAIQDSjhGnCAoAABIvAAATAAAAAAAA>>temp64
echo AAAAAAAAADImAABjdXN0b21YbWwvaXRlbTEueG1sUEsBAi0AFAAGAAgAAAAhALYT>>temp64
echo DqG7AQAAfQQAABgAAAAAAAAAAAAAAAAAkzAAAGN1c3RvbVhtbC9pdGVtUHJvcHMx>>temp64
echo LnhtbFBLAQItABQABgAIAAAAIQBJjnZ+nAEAABMDAAAQAAAAAAAAAAAAAAAAAKwy>>temp64
echo AABkb2NQcm9wcy9hcHAueG1sUEsBAi0AFAAGAAgAAAAhAC5JkL1IAQAAWAIAABEA>>temp64
echo AAAAAAAAAAAAAAAAfjUAAGRvY1Byb3BzL2NvcmUueG1sUEsBAi0AFAAGAAgAAAAh>>temp64
echo AL2EYiOQAAAA2wAAABMAAAAAAAAAAAAAAAAA/TcAAGN1c3RvbVhtbC9pdGVtMi54>>temp64
echo bWxQSwUGAAAAABIAEgDMBAAA5jgAAAAA>>temp64
if %startnumber% lss 100 set Fixednumber=0%startnumber%
if %startnumber% lss 10 set Fixednumber=00%startnumber%
certutil -decode -f temp64 "%category1%_%category2%_%workercode%_%setdate%_%Fixednumber%_%last%.xlsx">nul
del temp64
goto endRename