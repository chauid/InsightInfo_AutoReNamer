@echo off
set /a loop=0
:rand
if %loop% gtr 100 goto quit
set /a randint=(%random%*%random%*%random%*0x%time:~-2,2%)/17+(%random%*%random%*%random%*0x%time:~-2,2%)/3
echo %randint%
set /a loop=loop+1
goto rand
:quit
pause
exit