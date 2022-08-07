@echo off
set serverIP=34.168.133.173
if "%time:~0,1%" equ " " (set hours=0%time:~1,1%) else (set hours=%time:~0,2%)
set uploadname=%date:~2,2%%date:~5,2%%date:~-2,2%_%hours%%time:~3,2%
echo compact AutoReNamer (1/2)
zip -r AutoRenamer.zip AutoRenamer>nul
echo Upload AutoReNamer ^| ServerIP:%serverIP% (2/2)
scp AutoRenamer.zip root@%serverIP%:/upload/AutoRenamer%uploadname%.zip
del AutoRenamer.zip
echo.
echo Upload Complete! [Upload File:AutoRenamer%uploadname%.zip]
pause
exit