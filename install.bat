
@echo off 
setlocal EnableDelayedExpansion
color 0B 
REM color 0B & Mode 80,40

echo -----------------------------------
call :TITLE "     BBH Elixir Installer "
echo -----------------------------------

set fastinstall=false
set mypath=%cd%
if ""=="%1" ( set instance=elixir_01
  ) else ( set instance=%1
  )
set instanceRoot=%mypath%\%instance%

if exist %instanceRoot%\setup\config.bat (
  echo Loading configuration
  CALL %instanceRoot%\setup\config.bat
) else (
  echo Configuration not found loading defaults.
 set localREPO=
    set localREPOUNCUser=
    set localREPOUNCPwd=

  set remoteREPO=https://git.bbh.org.in/git
    set remoteREPOHTTPSUser=
    set remoteREPOHTTPSPwd=

  set publicREPO=https://github.com/baptistdev/
    set publicREPOHTTPSUser=
    set publicREPOHTTPSPwd=
)

if ""=="%localREPO%" (
  set /p localREPO="UNC Share for Local repo [Eg: 192.168.1.22/repos] : "
)
if ""=="%localREPOUNCUser%" (
  set /p localREPOUNCUser="UNC Share ( //%localREPO% ) User [Eg: domain\user] : "
)
if ""=="%localREPOUNCPwd%" (
  set /p localREPOUNCPwd="UNC Share ( //%localREPO% ) Pasword : "
)
if ""=="%gitUser%" (
  set /p gitUser="Git User Name (for commit identity) : "
)
if ""=="%gitEmail%" (
  set /p gitEmail="Git email (for commit identity) : "
)

if ""=="%remoteREPO%" (
  set /p remoteREPO="Remote Repository (%remoteREPO%) : "
)
if ""=="%remoteREPOHTTPSUser%" (
  set /p remoteREPOHTTPSUser="Remote Repository ( %remoteREPO% ) User : "
)
if ""=="%remoteREPOHTTPSPwd%" (
  set /p remoteREPOHTTPSPwd="Remote Repository ( %remoteREPO% ) Pasword : "
)

echo Using Repositories : 
echo   Local  : %localREPO%
echo     User : %localREPOUNCUser% 
echo     Pwd  : %localREPOUNCPwd%
echo     Gituser: %gitUser% 
echo     Gitemail: %gitEmail% 
echo   Remote : %remoteREPO%
echo     User : %remoteREPOHTTPSUser% 
echo     Pwd  : %remoteREPOHTTPSPwd% 

echo Using Instance Setup Folder : 
if exist %instanceRoot%\setup (
    echo   %instanceRoot%\setup
    echo     Already exists
) else (
  MKDIR %instanceRoot%\setup
  echo     Folder Created
)

REM xampp folder
if exist %mypath%\runtime\xampp (
    echo   %mypath%\runtime\xampp
    echo     Already exists
) else (
  MKDIR %mypath%\runtime\xampp
  echo     Folder Created
)


@echo set localREPO=%localREPO%> %instanceRoot%\setup\config.bat
@echo     set localREPOUNCUser=%localREPOUNCUser%>> %instanceRoot%\setup\config.bat
@echo     set localREPOUNCPwd=%localREPOUNCPwd%>> %instanceRoot%\setup\config.bat
@echo     set gitUser=%gitUser%>> %instanceRoot%\setup\config.bat
@echo     set gitEmail=%gitEmail%>> %instanceRoot%\setup\config.bat

@echo set remoteREPO=%remoteREPO%>> %instanceRoot%\setup\config.bat
@echo     set remoteREPOHTTPSUser=%remoteREPOHTTPSUser%>> %instanceRoot%\setup\config.bat
@echo     set remoteREPOHTTPSPwd=%remoteREPOHTTPSPwd%>> %instanceRoot%\setup\config.bat

@echo set instance=%instance%>> %instanceRoot%\setup\config.bat

echo Using Downloads Folder : 
if exist %mypath%\Downloads (
    echo   %mypath%\Downloads
    echo     Already exists
) else (
  MKDIR %mypath%\Downloads
  echo     Folder Created
)

REM echo Checking prerequisites and dependencies. 
REM set list=git node code python .net 
REM (for %%a in (%list%) do ( 
REM    call :CHECKANDINSTALL  %%a 
REM ))

call :CHECKANDINSTALL git https://git-scm.com/download/win %mypath%\Downloads\Git-2.20.1-64-bit.exe
call git config --global user.name --replace-all "%gitUser%"
call git config --global user.email --replace-all "%gitUser%"

call :CHECKANDINSTALL node https://nodejs.org/dist/v10.16.0/node-v10.16.0-x64.msi %mypath%\Downloads\node-v10.16.0-x64.msi RUNMSIINSTALLER  
REM PB : TODO -- Once we have git and node in place relaunch batch file to clone the setup from repo and
REM  -- hand over he installation there... and skip the rest here...


call :CHECKANDINSTALL code https://vscode-update.azurewebsites.net/latest/win32-x64/stable %mypath%\Downloads\vscode-win32-x64-latest-stable.exe
REM call :CHECKANDINSTALL .net https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe %mypath%\Downloads\NDP461-KB3102436-x86-x64-AllOS-ENU.exe
REM call :CHECKANDINSTALL python https://www.python.org/ftp/python/3.6.5/python-3.6.5-amd64.exe %mypath%\Downloads\python-3.6.5-amd64.exe
call :CHECKANDINSTALL python https://www.python.org/ftp/python/2.7.16/python-2.7.16.amd64.msi %mypath%\Downloads\python-2.7.16.amd64.msi RUNMSIINSTALLER
call :CHECKANDINSTALL xampp https://www.apachefriends.org/xampp-files/7.3.5/xampp-windows-x64-7.3.5-1-VC15-installer.exe %mypath%\Downloads\xampp-windows-x64-7.3.5-1-VC15-installer.exe XAMPPINSTALLER

echo -----------------------------------------------------  
call :TITLE " Installing BBH Elixir Instance %instance%"
echo -----------------------------------------------------
echo   %instance%
echo     to location %mypath%



REM Add nodejs to System Path.
REM set PATH=%PATH%;C:\Program Files\nodejs

REM call git config http.sslVerify false


if "true"=="%fastinstall%" (
  echo fastinstall : %fastinstall%
) else (
  REM Net Use \\%localREPO% /user:%localREPOUser% %localREPOPwd%
  
  REM Clone repo list.
  (for %%a in (
    ember-masonry-grid
    bbhverse
    loopback
    qms
    ember-searchable-select
    loopback-component-jsonapi
    config
  ) do ( 
    CALL :GITCLONE %localREPO% %mypath%\%instance% %%a
  ))

  echo Upgrading NPM
  call npm i npm@latest -g
  echo Installing Ember cli
  call :CHECKRUNNABLE ember
  if "%output%"=="true" (
      echo   Already Installed %2
    ) else (
      call npm install -g ember-cli
    ) 

  (for %%a in (
    loopback
    qms
    qms/server
  ) do ( 
    del %mypath%\%instance%\%%a\package-lock.json
    echo npm install FOR %%a
    cd %mypath%\%instance%\%%a
    call npm install   
  ))
  echo Calling Bower install
  call "./node_modules/.bin/bower" install

  REM echo " copying roboto"
  REM mkdir %mypath%\%instance%\qms\bower_components\materialize\dist\fonts\roboto
  REM xcopy %mypath%\%instance%\roboto %mypath%\Dev\qms\bower_components\materialize\dist\fonts\roboto
)

MKDIR %mypath%\%instance%\qms\data\filestore

REM load schema.
%mypath%\runtime\xampp\mysql\bin\mysql -uroot -p mysql -e "CREATE DATABASE elixir;" 
REM MKDIR %mypath%\%instance%\loopback\common\schemaBuilderSource
REM echo mkdir
start /WAIT robocopy %mypath%\%instance%\loopback\common\models %mypath%\%instance%\loopback\common\schemaBuilderSource  /COPYALL /E

cd %mypath%\%instance%\loopback
cd
set NODE_ENV=devmysql
REM start /wait node sage-rw\bin\schemabuilder.js

REM cd ..
REM ember s

REM call :COLORIZEHELP

ehco Review post install steps in readme.
REM Install chrome ember inspector..
REM https://stackoverflow.com/questions/24612297/why-is-my-ember-cli-build-time-so-slow-on-windows


GOTO :EOF

REM Check if app is installed
:CHECKRUNNABLE <app>
set output=false
for /f "delims=" %%i in ('where %1') do set output=%%i
  if exist "%output%" (
    echo %1 [exists] %output%
    set output=true
    REM node %~dp0app.js
  ) else (
    set output=false
    echo %1
    call :ERROR "%%1 doesn't exist"     
  )    
exit /b

:DOWNLOAD <url> <File>
  Title Download a file with Powershell
  set "workdir=%mypath%\Downloads"
  If not exist %workdir% mkdir %workdir%
  Set "URL=%1"
  Set "FileLocation=%2"
  echo(
  echo   Please wait ... download is in progress ...
  Call :Download_ %URL% %FileLocation%
  echo   Download Complete
exit /b

::**************************************************************************
:Download_ <url> <File>
  Powershell.exe ^
  $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'; ^
  [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols; ^
  (New-Object System.Net.WebClient).DownloadFile('%1','%2')
exit /b
::**************************************************************************

:CHECKANDINSTALL <name> <url> <DownloadedFile> <installer>
REM echo Detecting %1
  call :CHECKRUNNABLE %1 
  if "%output%"=="true" (
    echo     %1 already installed
  ) else (
    echo   Installing %1
    if "%4" == "" (
      CALL :GETINSTALLER %2 %3 %1 false
      CALL :RUNINSTALLER %3 %1 false  
    ) else (
      CALL :GETINSTALLER %2 %3 %1 false
      CALL :%4 %3 %1 false
    )
   
  )
exit /b

:GETINSTALLER <url> <File> <name> <notinstalled>
  if exist %2 (
     echo   using previously downloaded installer %2
  ) else (
     echo   downloading %3 installer
     CALL :DOWNLOAD %1 %2
  )
exit /b

:RUNINSTALLER <File> <name> <notinstalled>
  echo   Installing %2
  START /WAIT %1 /VERYSILENT /MERGETASKS=!runcode
  call :CHECKRUNNABLE %2
  if "%output%"=="true" (
    echo   Installed %2
  ) else (
    CALL :FATAL "  INSTALL FAILED %1"
  )  
exit /b

:RUNMSIINSTALLER <File> <name> <notinstalled>
  echo( 
    echo   Installing %2
    MSIEXEC.exe /i %1 ACCEPT=YES /passive
    call :CHECKRUNNABLE %2
    if "%output%"=="true" (
      echo   Installed %2
    ) else (
      CALL :ERROR "  INSTALL FAILED %1"
    )
exit /b

:XAMPPINSTALLER <File> <name> <notinstalled>
  echo( 
    echo   Installing %2 -- please wait --
    REM echo START %1 --unattendedmodeui minimal --disable-components xampp_mercury,xampp_tomcat,xampp_webalizer --mode unattended --launchapps 0 --prefix "%instanceRoot%\runtime\xampp"
    REM START /WAIT %1 --unattendedmodeui minimal --disable-components xampp_mercury,xampp_tomcat,xampp_webalizer --mode unattended --prefix "%instanceRoot%\runtime\xampp"
    REM START /WAIT %1 
    cd %mypath%\runtime\xampp\apache
    call %mypath%\runtime\xampp\apache\apache_installservice.bat
    cd %mypath%\runtime\xampp\mysql
    call %mypath%\runtime\xampp\mysql\mysql_installservice.bat
    REM call :CHECKRUNNABLE %2
    %mypath%\runtime\xampp\mysql\bin\mysql -uroot -p mysql -e "select * from user;"
    if %ERRORLEVEL%==0 (
      echo mysql install Successful 
    ) else (
      CALL :ERROR "  INSTALL FAILED %1"
    )

exit /b

:GITCLONE <from> <to> <repo>
echo Cloning Repo
echo   %3
echo   git clone //%1/%3.git %2\%3
call git clone //%1/%3.git %2\%3
if %ERRORLEVEL%==0 (
  echo Successful : Git Clone %3 
) else (
  if %ERRORLEVEL%==128 (
    echo     %3 Already Exists
  ) else (
    echo Failed : Git Clone %3 -- Trying BBH Online Repository
    echo git clone https://git.bbh.org.in/git/%3.git %2\%3
    call git clone https://git.bbh.org.in/git/%3.git %2\%3
    if %ERRORLEVEL%==0 (
      echo Successful : Git Clone %3 
    ) else (
      echo Failed : Git Clone %3 even from BBH Online Repository
    )
  )
)
exit /b

:FATAL <msg>
  echo [101;93m %~1 [0m  
exit /b

:ERROR <msg>
  echo [107;91m %~1 [0m  
exit /b


:TITLE <msg>
  echo [104;97m %~1 [0m  
exit /b

:COLORIZEHELP
echo [101;93m STYLES [0m
echo ^<ESC^>[0m [0mReset[0m
echo ^<ESC^>[1m [1mBold[0m
echo ^<ESC^>[4m [4mUnderline[0m
echo ^<ESC^>[7m [7mInverse[0m
echo.
echo [101;93m NORMAL FOREGROUND COLORS [0m
echo ^<ESC^>[30m [30mBlack[0m (black)
echo ^<ESC^>[31m [31mRed[0m
echo ^<ESC^>[32m [32mGreen[0m
echo ^<ESC^>[33m [33mYellow[0m
echo ^<ESC^>[34m [34mBlue[0m
echo ^<ESC^>[35m [35mMagenta[0m
echo ^<ESC^>[36m [36mCyan[0m
echo ^<ESC^>[37m [37mWhite[0m
echo.
echo [101;93m NORMAL BACKGROUND COLORS [0m
echo ^<ESC^>[40m [40mBlack[0m
echo ^<ESC^>[41m [41mRed[0m
echo ^<ESC^>[42m [42mGreen[0m
echo ^<ESC^>[43m [43mYellow[0m
echo ^<ESC^>[44m [44mBlue[0m
echo ^<ESC^>[45m [45mMagenta[0m
echo ^<ESC^>[46m [46mCyan[0m
echo ^<ESC^>[47m [47mWhite[0m (white)
echo.
echo [101;93m STRONG FOREGROUND COLORS [0m
echo ^<ESC^>[90m [90mWhite[0m
echo ^<ESC^>[91m [91mRed[0m
echo ^<ESC^>[92m [92mGreen[0m
echo ^<ESC^>[93m [93mYellow[0m
echo ^<ESC^>[94m [94mBlue[0m
echo ^<ESC^>[95m [95mMagenta[0m
echo ^<ESC^>[96m [96mCyan[0m
echo ^<ESC^>[97m [97mWhite[0m
echo.
echo [101;93m STRONG BACKGROUND COLORS [0m
echo ^<ESC^>[100m [100mBlack[0m
echo ^<ESC^>[101m [101mRed[0m
echo ^<ESC^>[102m [102mGreen[0m
echo ^<ESC^>[103m [103mYellow[0m
echo ^<ESC^>[104m [104mBlue[0m
echo ^<ESC^>[105m [105mMagenta[0m
echo ^<ESC^>[106m [106mCyan[0m
echo ^<ESC^>[107m [107mWhite[0m
echo.
echo [101;93m COMBINATIONS [0m
echo ^<ESC^>[31m                     [31mred foreground color[0m
echo ^<ESC^>[7m                      [7minverse foreground ^<-^> background[0m
echo ^<ESC^>[7;31m                   [7;31minverse red foreground color[0m
echo ^<ESC^>[7m and nested ^<ESC^>[31m [7mbefore [31mnested[0m
echo ^<ESC^>[31m and nested ^<ESC^>[7m [31mbefore [7mnested[0m
exit /b


GOTO :EOF

:EOF