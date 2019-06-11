@echo off
Title Download a file with Powershell
REM color 0A & Mode 60,3
set "workdir=%CD%\Downloads"
If not exist %workdir% mkdir %workdir%
Set "URL=%1"
Set "FileLocation=%2"
echo(
echo    Please wait a while ... The download is in progress ...
Call :Download %URL% %FileLocation%
echo Done

::**************************************************************************
:Download <url> <File>
Powershell.exe ^
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'; ^
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols; ^
(New-Object System.Net.WebClient).DownloadFile('%1','%2')
exit /b
::**************************************************************************