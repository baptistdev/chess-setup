rem echo " ******** .Net Frame Work **********"
rem CALL powershell -Command "(New-Object Net.WebClient).DownloadFile('https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe', '%CD%\Dev\Downloads\DNF.exe')"
rem pause
rem start %CD%\Dev\Downloads\DNF.exe ACCEPT=YES /VERYSILENT /MERGETASKS=!runcode 
rem echo " ********Installed  .Net Frame Work **********"
rem pause

REM echo "*******Python**********}
REM pause
REM curl -O https://www.python.org/ftp/python/3.6.5/python-3.6.5-amd64.exe
REM move %CD%\python-3.6.5-amd64.exe %CD%\Dev\Downloads

REM pause
REM start %CD%\Dev\Downloads\python-3.6.5-amd64.exe  /VERYSILENT /MERGETASKS=!runcode
REM echo "******** Installed Python ********"
REM pause


echo "Installing VSCode.........."
CALL powershell -Command "(New-Object Net.WebClient).DownloadFile('https://vscode-update.azurewebsites.net/latest/win32-x64/stable', '%CD%\Dev\Downloads\VScodeSetup.exe')"
start %CD%\Dev\Downloads\VSCodeSetup.exe /VERYSILENT /MERGETASKS=!runcode
echo "VSCode installed.........."
pause

echo "Installing git.........."
REM -- TODO --
REM This is failing: we are not able to download from git site.Ideally a git build solution or curl the url may workout
start %CD%/Git-2.13.1.2-64-bit.exe /VERYSILENT /MERGETASKS=!runcode
echo "git installed.........."
pause

echo "Installing nodejs.........."
CALL powershell -Command "(New-Object Net.WebClient).DownloadFile('https://nodejs.org/dist/v8.11.3/node-v8.11.3-x64.msi', '%CD%\Dev\Downloads\nodejs.msi')"
MSIEXEC.exe /i %CD%Dev\Downloads\nodejs.msi ACCEPT=YES /passive
echo "nodejs installed.........."
pause

echo "Cloning necessary repositories.........."


call git config --global http.sslVerify false

echo "Cloning ember-masonry-grid.........."
call git clone https://git.bbh.org.in/git/ember-masonry-grid %CD%\Dev\ember-masonry-grid
echo "Cloned ember-masonry-grid......... "
pause


echo "Cloning bbhverse.........."
call git clone https://git.bbh.org.in/git/bbhverse %CD%\Dev\bbhverse
echo " Cloned bbhverse.........."
pause


echo "Cloning loopback.........."
call git clone https://git.bbh.org.in/git/loopback %CD%\Dev\loopback
echo "Cloned loopback........."


echo "Cloning qms.........."
call git clone https://git.bbh.org.in/git/qms %CD%\Dev\qms
echo "Cloned qms..........."
pause


echo "Cloning ember-searchable-select.........."
call git clone https://github.com/baptistdev/ember-searchable-select.git %CD%\Dev\ember-searchable-select
echo "Cloned ember-searchable-select........"
pause
echo "cloning finished.........."

pause
chdir %CD%\Dev\bbhverse
echo "Installing npm in bbhverse.........."
call npm install
pause

chdir %CD%\Dev\ember-masonry-grid
echo "Installing npm in ember-masonry-grid.........."
call npm install
call npm install -g ember-cli
pause

chdir %CD%\Dev\loopback
echo "Installing npm in loopback.........."
call npm install
pause

chdir %CD%\Dev\ember-searchable-select
echo "Installing npm in ember-searchable-select.........."
call npm cache clean --force
call npm install
call npm install
pause

chdir %CD%\Dev\qms
echo "Geting latest version of npm.........."
call npm i npm@latest -g
pause
echo "Removing package-lock.json"
del package-lock.json
pause
echo "..........Installing npm in qms..........."
call npm install
call npm install

pause
echo "..........Installing bower in qms..........."
call npm install bower
pause
echo "..........Installing bower dependencies..........."
call bower install
pause

echo "Installing npm in dev\qms\server"
chdir %CD%\Dev\qms\server
call npm install
pause
chdir %CD%\Dev\qms

echo " copying roboto"
mkdir %CD%\Dev\qms\bower_components\materialize\dist\fonts\roboto
xcopy %CD%\roboto %CD%\Dev\qms\bower_components\materialize\dist\fonts\roboto
pause
echo " Starting server....."
call ember s
pause
exit