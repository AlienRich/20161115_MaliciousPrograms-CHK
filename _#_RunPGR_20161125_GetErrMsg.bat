@ECHO OFF

set FilePath=%CD%


for /f %%r in ('whoami') do (set RunID=%%r)
COLOR 0E
TITLE "第一段複製 ::: %RunID%"

set IPList=.\_#_IP-List.txt
set CopyOKCSV=.\--CopyOKCSV.csv
set CopyOKIP=.\--CopyOKIP.txt
set CopyErrCSV=.\--CopyErrCSV.csv
set RoboLog=.\--Robo.Log

del %CopyOKCSV%
del %CopyOKIP%
del %CopyErrCSV%
del %RoboLog%

for /F %%i IN (%IPList%) do (
	echo roboCopy ::: %%i
	start robocopy c:\FTool-Check-ATM \\%%i\c$\FTool-Check-ATM /mir /r:3 /w:0
	if exist \\%%i\c$\FTool-Check-ATM\FTool-light.exe echo %%i,%RunID%,CopyOK!!
	if not exist \\%%i\c$\FTool-Check-ATM\FTool-light.exe echo %%i,%RunID%,CopyErr!!
	ping 127.0.0.1 -w 800 -n 5
	)

COLOR 3F
TITLE "第二段複製【確認】 ::: %RunID%"

for /F %%i IN (%IPList%) do (
	echo roboCopy ::: %%i
	start robocopy c:\FTool-Check-ATM \\%%i\c$\FTool-Check-ATM /mir /r:3 /w:0 /LOG+:%RoboLog%
	if exist \\%%i\c$\FTool-Check-ATM\FTool-light.exe echo %%i,%RunID%,CopyOK!!>>%CopyOKCSV%
	if not exist \\%%i\c$\FTool-Check-ATM\FTool-light.exe echo %%i,%RunID%,CopyErr!!>>%CopyErrCSV%
	if exist \\%%i\c$\FTool-Check-ATM\FTool-light.exe echo %%i>>%CopyOKIP%
	ping 127.0.0.1 -w 800 -n 3
	)

::::	start "確認檔案複製完成，\\IP\c$\FTool-Check-ATM_--CopyErrCSV.csv!!" cmd.exe ECHO 確認檔案複製完成，\\IP\c$\FTool-Check-ATM_--CopyErrCSV.csv!! && ECHO 確認檔案複製完成，\\IP\c$\FTool-Check-ATM_--CopyErrCSV.csv!! && ECHO 確認檔案複製完成，\\IP\c$\FTool-Check-ATM_--CopyErrCSV.csv!! && PAUSE
::::	MSG.exe * /w "確認檔案複製完成，\\IP\c$\FTool-Check-ATM_--CopyErrCSV.csv!!"

ECHO 準備發動弱掃!!
ECHO 準備發動弱掃!!
ECHO 準備發動弱掃!!


COLOR 4F
TITLE "第三段【發動弱掃】 ::: %RunID%"

for /F "tokens=1,2,3 delims=/ " %%a IN ('date /t') do set RunDate=%%a%%b%%c
for /F "tokens=1,2,3 delims=: " %%a IN ('time /t') do set RunTime=%%b%%c
ECHO "ScanIP","%RunID%","狀態">.\_%RunDate%-%RunTime%_已發動執行.csv

start powershell.exe ".\_#_Get-Process-5Min.ps1"

	for /F %%i IN (%CopyOKIP%) do (
	echo PSExec ::: %%i ::: 發動弱掃
	if exist \\%%i\c$\FTool-Check-ATM\agent_run.bat start .\psexec \\%%i C:\FTool-Check-ATM\agent_run.bat
	echo "%%i","%RunID%","已發動執行!!">>.\_%RunDate%-%RunTime%_已發動執行_IP-OK.csv
	ping 127.0.0.1 -w 1000 -n 60
	tasklist /s %%i /v /fi "IMAGENAME eq FTool-light.exe" /fo csv>>.\_%RunDate%-%RunTime%_已發動執行_TaskInfo.csv
	)
::::	for /f "tokens=1,2,3,4,5,6,7,8,9 skip=1" %%a in ('tasklist /s %%i /v /fi "IMAGENAME eq FTool-light.exe" /fo csv') do set FToolPPP=%%a%%b%%c%%d
