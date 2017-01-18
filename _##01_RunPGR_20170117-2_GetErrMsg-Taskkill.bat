@ECHO OFF

set FilePath=%CD%


for /f %%r in ('whoami') do (set RunID=%%r)

set IPList=.\_#_IP-List.txt
set CopyOKCSV=.\--CopyOKCSV.csv
set CopyOKIP=.\--CopyOKIP.txt
set CopyErrCSV=.\--CopyErrCSV.csv
set RoboLog=.\--Robo.Log

del %CopyOKCSV%
del %CopyOKIP%
del %CopyErrCSV%
del %RoboLog%


COLOR 78
TITLE "�M���ݯdTASK ::: %RunID%"
for /F %%i IN (%IPList%) do (
	echo TaskKill ::: %%i
	if exist \\%%i\c$\*.* start robocopy C:\temp \\%%i\c$\temp _#_TaskKill-_FTool.bat /r:3 /w:0
	ping 127.0.0.1 -w 800 -n 5
	if exist \\%%i\c$\temp\_#_TaskKill-_FTool.bat echo %%i>>%CopyOKIP%
	if exist \\%%i\c$\temp\_#_TaskKill-_FTool.bat start .\psexec \\%%i C:\temp\_#_TaskKill-_FTool.bat
	)


COLOR 3E
TITLE "�Ĥ@�q�ƻs ::: %RunID%"
for /F %%i IN (%CopyOKIP%) do (
	echo roboCopy ::: %%i
	start robocopy c:\FTool-Check-ATM \\%%i\c$\FTool-Check-ATM /mir /r:3 /w:0
	if exist \\%%i\c$\FTool-Check-ATM\FTool-light.exe echo %%i,%RunID%,CopyOK!!
	if not exist \\%%i\c$\FTool-Check-ATM\FTool-light.exe echo %%i,%RunID%,CopyErr!!
	ping 127.0.0.1 -w 800 -n 10
	)

COLOR 3F
TITLE "�ĤG�q�ƻs�i�T�{�j ::: %RunID%"

for /F %%i IN (%CopyOKIP%) do (
	echo roboCopy ::: %%i
	start robocopy c:\FTool-Check-ATM \\%%i\c$\FTool-Check-ATM /mir /r:3 /w:0 /LOG+:%RoboLog%
	if exist \\%%i\c$\FTool-Check-ATM\FTool-light.exe echo %%i,%RunID%,CopyOK!!>>%CopyOKCSV%
	if not exist \\%%i\c$\FTool-Check-ATM\FTool-light.exe echo %%i,%RunID%,CopyErr!!>>%CopyErrCSV%
	ping 127.0.0.1 -w 800 -n 5
	)

::::	if exist \\%%i\c$\FTool-Check-ATM\FTool-light.exe echo %%i>>%CopyOKIP%
::::	start "�T�{�ɮ׽ƻs�����A\\IP\c$\FTool-Check-ATM_--CopyErrCSV.csv!!" cmd.exe ECHO �T�{�ɮ׽ƻs�����A\\IP\c$\FTool-Check-ATM_--CopyErrCSV.csv!! && ECHO �T�{�ɮ׽ƻs�����A\\IP\c$\FTool-Check-ATM_--CopyErrCSV.csv!! && ECHO �T�{�ɮ׽ƻs�����A\\IP\c$\FTool-Check-ATM_--CopyErrCSV.csv!! && PAUSE
::::	MSG.exe * /w "�T�{�ɮ׽ƻs�����A\\IP\c$\FTool-Check-ATM_--CopyErrCSV.csv!!"

ECHO �ǳƵo�ʮz��!!
ECHO �ǳƵo�ʮz��!!
ECHO �ǳƵo�ʮz��!!


COLOR 4F
TITLE "�ĤT�q�i�o�ʮz���j ::: %RunID%"

for /F "tokens=1,2,3 delims=/ " %%a IN ('date /t') do set RunDate=%%a%%b%%c
for /F "tokens=1,2,3 delims=: " %%a IN ('time /t') do set RunTime=%%b%%c
ECHO "ScanIP","%RunID%","���A">.\_%RunDate%-%RunTime%_�w�o�ʰ���.csv

start powershell.exe ".\_#_Get-Process-5Min.ps1"

	for /F %%i IN (%CopyOKIP%) do (
	echo PSExec ::: %%i ::: �o�ʮz��
	if exist \\%%i\c$\FTool-Check-ATM\agent_run.bat start .\psexec \\%%i C:\FTool-Check-ATM\agent_run.bat
	echo "%%i","%RunID%","�w�o�ʰ���!!">>.\_%RunDate%-%RunTime%_�w�o�ʰ���_IP-OK.csv
	ping 127.0.0.1 -w 1000 -n 45
	tasklist /s %%i /v /fi "IMAGENAME eq FTool-light.exe" /fo csv>>.\_%RunDate%-%RunTime%_�w�o�ʰ���_TaskInfo.csv
	)
::::	for /f "tokens=1,2,3,4,5,6,7,8,9 skip=1" %%a in ('tasklist /s %%i /v /fi "IMAGENAME eq FTool-light.exe" /fo csv') do set FToolPPP=%%a%%b%%c%%d
