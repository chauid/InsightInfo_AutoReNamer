@echo off
call :callme & echo dddd
echo haha
pause

:callme
echo hello. you call me!
pause
exit /b

exit