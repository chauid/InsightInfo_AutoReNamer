@echo off
chcp 65001
setlocal ENABLEDELAYEDEXPANSION
set menu[1][1]=menu1
set menu[2][1]=menu2
set menu[3][1]=menu3
set menu[4][1]=menu4
set menu[1][2]=menu5
set menu[2][2]=menu6
set menu[3][2]=menu7
set menu[4][2]=menu8
set /a MaxX=4
set /a MaxY=2
:initSet
set /a posMenuX=1
set /a posMenuY=1
goto drawScreen
:input
echo.
choice /c wsadr /n /m "위:W, 아래:S, 왼쪽:A, 오른쪽:D, 확인:R"
if %errorlevel% equ 1 set /a posMenuY=posMenuY-1 & goto drawScreen
if %errorlevel% equ 2 set /a posMenuY=posMenuY+1 & goto drawScreen
if %errorlevel% equ 3 set /a posMenuX=posMenuX-1 & goto drawScreen
if %errorlevel% equ 4 set /a posMenuX=posMenuX+1 & goto drawScreen
if %errorlevel% equ 5 goto Selected
goto quit
:drawScreen
cls
if %posMenuX% lss 1 set /a posMenuX=posMenuX+1
if %posMenuY% lss 1 set /a posMenuY=posMenuY+1
if %posMenuX% gtr %MaxX% set /a posMenuX=posMenuX-1
if %posMenuY% gtr %MaxY% set /a posMenuY=posMenuY-1
rem echo (%posMenuX%,%posMenuY%)
echo 메뉴 선택
if "(%posMenuX%,%posMenuY%)" equ "(1,1)" (set /p "=menu1* "<nul) else (set /p "=menu1  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,1)" (set /p "=menu2* "<nul) else (set /p "=menu2  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(3,1)" (set /p "=menu3* "<nul) else (set /p "=menu3  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(4,1)" (set /p "=menu4* "<nul) else (set /p "=menu4  "<nul)
echo.
if "(%posMenuX%,%posMenuY%)" equ "(1,2)" (set /p "=menu5* "<nul) else (set /p "=menu5  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(2,2)" (set /p "=menu6* "<nul) else (set /p "=menu6  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(3,2)" (set /p "=menu7* "<nul) else (set /p "=menu7  "<nul)
if "(%posMenuX%,%posMenuY%)" equ "(4,2)" (set /p "=menu8* "<nul) else (set /p "=menu8  "<nul)
goto input
:Selected
echo !menu[%posMenuX%][%posMenuY%]!를 선택하였습니다. 
pause>nul & cls
goto initSet
:quit
endlocal
exit