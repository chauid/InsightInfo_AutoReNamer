@echo off
chcp 65001>nul
set serverIP=34.168.133.173
if "%time:~0,1%" equ " " set hours=0%time:~1,1%
set uploadname=%date:~2,2%%date:~5,2%%date:~-2,2%_%hours%%time:~3,2%
zip AutoRenamer.zip AutoRenamer
scp AutoRenamer.zip root@%serverIP%:/upload/AutoRenamer%uploadname%.zip
del AutoRenamer.zip
echo Upload Complete! [Upload File:AutoRenamer%uploadname%.zip]
pause
exit