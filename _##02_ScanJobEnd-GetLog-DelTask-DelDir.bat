@ECHO OFF

set FilePath=%CD%
set LogFilePath=%CD%\_@_Get-ScanLog
mkdir %LogFilePath%
Set LogType7z=201?????_*_*.*.*.*_Data.7z
set NoLog=%CD%\--RunJobButNoLog.txt
set YesLog=%CD%\--RunJobLogOK.txt


for /f %%r in ('whoami') do (set RunID=%%r)

set IPList=.\_#_IP-List.txt
set CopyOKCSV=.\--CopyOKCSV.csv
set CopyOKIP=.\--CopyOKIP.txt
set CopyErrCSV=.\--CopyErrCSV.csv
set RoboLog=.\--Robo.Log

::::	del %CopyOKCSV%
::::	del %CopyOKIP%
::::	del %CopyErrCSV%
::::	del %RoboLog%
::::	檔案名稱範例	20170118_xcarddb_169.254.95.120_Data.7z


	COLOR 0B
TITLE "清除殘留TASK、Get執行結果 ::: %RunID%"
for /F %%i IN (%CopyOKIP%) do (
	echo TaskKill ::: %%i
	if exist \\%%i\c$\*.* start robocopy C:\temp \\%%i\c$\temp _#_TaskKill-_FTool.bat /r:3 /w:0
	ping 127.0.0.1 -w 800 -n 5
	if exist \\%%i\c$\temp\_#_TaskKill-_FTool.bat start .\psexec \\%%i C:\temp\_#_TaskKill-_FTool.bat
	DIR /B \\%%i\c$\%LogType7z% >> %YesLog%
	DIR /B \\%%i\c$\%LogType7z%
	if not exist \\%%i\c$\%LogType7z% (Echo %%i_未產生LOG>>%NoLog%) ELSE (robocopy \\%%i\c$ %LogFilePath% %LogType7z% /mov /r:3 /w:0)
	)