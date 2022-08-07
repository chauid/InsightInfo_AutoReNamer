@echo off
chcp 65001>nul
setlocal ENABLEDELAYEDEXPANSION
set batchpath=%~dp0
:OnDirectory
title Current Path : %cd%
set /a dirnum=0
set /a dirlistnum=1
rem #####디렉터리 리스트 배열[1~N]#####
set dirlist=NULL
for /f %%i in ('dir /a:d /b') do set /a dirnum=dirnum+1
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
echo 현재 경로의 디렉터리 수 : %dirnum%
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set /p Todir=Choice : 
set /a temp=Todir-1
if %Todir% gtr %dirnum% (echo 1~%dirnum%까지만 선택 가능합니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
if %temp% lss 0 (echo 1~%dirnum%까지만 선택 가능합니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
goto MvDir
:NoDir
echo 현재 경로 : %cd%
echo --------------------------------------------------------------------
echo %dirlistnum%. [..]상위 디렉터리로 가기
echo ----------------------------------------------------------------------
echo 현재 경로의 디렉터리 수 : %dirnum%
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set /p Todir=Choice : 
set /a temp=Todir-1
if %temp% neq 0 (echo 현재 디렉터리에 디렉터리가 없습니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
goto MvDir
:MvDir
cd !dirlist[%Todir%]!
cls
goto OnDirectory
:quit
endlocal
pause>nul