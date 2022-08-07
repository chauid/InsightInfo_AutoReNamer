@echo off
chcp 65001>nul
setlocal ENABLEDELAYEDEXPANSION
set current=%~dp0
set batchname=%~nx0
rem ##########CurrentVersion:121:##########
set /a version=121
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
powershell Invoke-WebRequest -Uri 192.168.0.75/files/AutoReName.bat -OutFile %current%NewVersion.bat
powershell Invoke-WebRequest -Uri 192.168.0.75/files/update%ReName%log.txt -OutFile %current%%ReName%update.txt
start %current%NewVersion.bat update
del %current%%batchname%
exit
:FirstEx
powershell (Invoke-WebRequest 192.168.0.75/files/AutoReName.bat).RawContent > ReName.txt
for /f "delims=: tokens=2 skip=2" %%i in ('find "CurrentVersion" ReName.txt')  do set ReName=%%i & goto getVersion
:getVersion
del ReName.txt
set /a ReName=ReName
if %ReName% equ 0 echo 서버와 연결할 수 없습니다. 또는 인터넷 익스플로러 최초 실행이 필요합니다. & pause>nul & explorer "C:\Program Files\Internet Explorer\iexplore.exe" & exit
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
goto endRename