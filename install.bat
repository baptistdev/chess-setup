@echo off 
setlocal EnableDelayedExpansion

color 0B 
REM color 0B & Mode 80,40

echo -----------------------------------
call :TITLE "     BBH Elixir Installer "
echo -----------------------------------

set isGitBash=false
call :checkIsGitBash
echo Gitbash=%isGitBash%

set fastinstall=false
set mypath=%cd%
set root=%mypath%
if ""=="%1" ( set instancename=elixir_01
  ) else ( set instancename=%1
  )
set instanceRoot=%root%\instances\%instancename%
mkdir %instanceRoot%
mkdir %instanceRoot%\tmp
echo instanceRoot = %instanceRoot%
echo root = %root%

if exist %instanceRoot%\config.bat (
  echo Loading configuration
  CALL %instanceRoot%\config.bat
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

  @echo set localREPO=%localREPO%>%instanceRoot%\config.bat
  @echo     set localREPOUNCUser=%localREPOUNCUser%>>%instanceRoot%\config.bat
  echo localREPOUNCUser = %instanceRoot%
  @echo     set localREPOUNCPwd=%localREPOUNCPwd%>>%instanceRoot%\config.bat
  @echo     set gitUser=%gitUser%>>%instanceRoot%\config.bat
  @echo     set gitEmail=%gitEmail%>>%instanceRoot%\config.bat

  @echo set remoteREPO=%remoteREPO%>>%instanceRoot%\config.bat
  @echo     set remoteREPOHTTPSUser=%remoteREPOHTTPSUser%>>%instanceRoot%\config.bat
  @echo     set remoteREPOHTTPSPwd=%remoteREPOHTTPSPwd%>>%instanceRoot%\config.bat

  @echo set instancename=%instancename%>>%instanceRoot%\config.bat

)

set runfile=%instanceRoot%\tmp\run.log.bat
echo %runfile%
REM xampp folder
set xamppinstllpath=c:\xampp

set javaversion=jdk-13.0.1
set javainstaller=openjdk-13.0.1_windows-x64_bin
set javainstllpath=%root%\runtime\%javainstaller%
set javapath=%javainstllpath%\%javaversion%\bin


set step[INSTALLWINBUILDTOOLS]=false
set step[RELAUNCHWITHENV]=false
set step[PREREQS]=false
set step[REPOSCLONED]=false
set step[PROJECTNPMINSTALL]=false

REM Load previosly completed steps as skip config
if exist %runfile% (
  echo Loading Runtime State
  CALL %runfile%
) else (
  echo No Previous Run detected.
)
:: END CONFIG ---------------------------------------------------------

::Shortcut call a subroutine
if NOT "%2"=="" (
  echo calling :%2 %3
  call :%2 %3*
  GOTO :EOF
)

CALL :INITFORRUNASADMINISTRATOR

set existcheck=false

if "%step[PREREQS]%"=="true" (
  echo Prerequistes install already completed.
  pause
  REM PB :TODO -- We still need to check if we are in bash before running the BASHSTEPS.
  call :BASHSTEPS 

) else ( 
  echo set step[STARTED]=true>%instanceRoot%\tmp\run.log.bat

  REM set xamppinstllpath=%root%\runtime\xampp
  if exist "%xamppinstllpath%" (
      echo   %xamppinstllpath%
      echo     Already exists
  ) else ( MKDIR %xamppinstllpath%
      echo     Folder Created
  )
  echo xamppinstllpath=%xamppinstllpath%

  echo Using Downloads Folder : 
  if exist %mypath%\Downloads (
      echo   %mypath%\Downloads
      echo     Already exists
  ) else ( MKDIR %mypath%\Downloads
    echo     Folder Created
  )

  REM echo Checking prerequisites and dependencies. 
  REM set list=git node code python .net 
  REM (for %%a in (%list%) do ( 
  REM    call :CHECKANDINSTALL  %%a 
  REM ))

  call :CHECKANDINSTALL git https://github.com/git-for-windows/git/releases/download/v2.23.0.windows.1/Git-2.23.0-64-bit.exe %mypath%\Downloads\Git-2.23.0-64-bit.exe
  REM exit(1)
  call git config --global user.name --replace-all "%gitUser%"
  call git config --global user.email --replace-all "%gitUser%"

  call :CHECKANDINSTALL node https://nodejs.org/dist/v10.16.0/node-v10.16.0-x64.msi %mypath%\Downloads\node-v10.16.0-x64.msi RUNMSIINSTALLER  
  REM PB : TODO -- Once we have git and node in place relaunch batch file to clone the setup from repo and
  REM  -- hand over he installation there... and skip the rest here...


  call :CHECKANDINSTALL code https://vscode-update.azurewebsites.net/latest/win32-x64/stable %mypath%\Downloads\vscode-win32-x64-latest-stable.exe
  REM call :CHECKANDINSTALL .net https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe %mypath%\Downloads\NDP461-KB3102436-x86-x64-AllOS-ENU.exe
  REM call :CHECKANDINSTALL python https://www.python.org/ftp/python/3.6.5/python-3.6.5-amd64.exe %mypath%\Downloads\python-3.6.5-amd64.exe
  echo step[PREREQS] = %step[PREREQS]%
  pause
  if "%step[RELAUNCHWITHENV]%"=="true" (
    echo path=%path%
    pause
    call :CHECKANDINSTALL python https://www.python.org/ftp/python/2.7.16/python-2.7.16.amd64.msi %mypath%\Downloads\python-2.7.16.amd64.msi RUNMSIINSTALLER
  
    REM PB : TODO -- Esure npm is available with path already set.
    call :RUNSTEP INSTALLWINBUILDTOOLS
    
    echo xamppinstllpath %xamppinstllpath%
    call :CHECKANDINSTALLXAMPP %xamppinstllpath%\xampp-control.exe xampp https://www.apachefriends.org/xampp-files/7.3.5/xampp-windows-x64-7.3.5-1-VC15-installer.exe %mypath%\Downloads\xampp-windows-x64-7.3.5-1-VC15-installer.exe XAMPPINSTALLER
    
    call :CHECKANDINSTALLJAVA openjdk-13.0.1_windows-x64_bin java https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_windows-x64_bin.zip  %mypath%\Downloads\openjdk-13.0.1_windows-x64_bin.zip JAVAINSTALLER
    
    call :EXECQUEUEDFORRUNASADMINISTRATOR
    REM PB : TODO SHELLEXECUTE DOESNT WAIT...
    pause

    echo PREREQS Install completed

    set step[PREREQS]=true
    echo set step[PREREQS]=true>%instanceRoot%\tmp\run.log.bat
    
    echo checking gitbashrun
    if exist "%instanceRoot%\tmp\gitbashrun.log.bat" (
      echo git-bash process already launched
    ) else (
      pause
      if "true"=="%isGitBash%" (
        call :BASHSTEPS
      ) else ( REM Switch to a git bash shell to continue
        cd %root%
        echo started>%instanceRoot%\tmp\gitbashrun.log.bat
        echo "C:\Program Files\Git\git-bash" -c "/c/elixir/instances/elixir_01/setup/install.bat"
        call "C:\Program Files\Git\git-bash" -c "/c/elixir/instances/elixir_01/setup/install.bat"
        del %instanceRoot%\tmp\gitbashrun.log.bat
      )
    )
  ) else ( 

    REM if "%step[RELAUNCHWITHENV]%"=="true" (
    REM   echo Already relaunched.
    REM ) else (
      :: Preset paths that dont get set automatically. And are not available until relaunch.
      echo setx path "%%path%%;C:\python27;%javapath%">%instanceroot%/tmp/setenv.bat
      echo pause>>%instanceroot%/tmp/setenv.bat
      start /w cmd /c %instanceroot%/tmp/setenv.bat
      set step[RELAUNCHWITHENV]=true
      echo set step[RELAUNCHWITHENV]=true>>%runfile%

      echo %setupFolder%\install.bat
      pause
      REM call "C:\Program Files\Git\git-bash" -c "/c/elixir/instances/elixir_01/setup/install.bat"

      start /i "%windir%\explorer.exe" "%windir%\system32\cmd.exe"
      REM start /w "%windir%\explorer.exe" "%setupFolder%\install.bat"
      REM start /i /wait cmd /k %setupFolder%\install.bat
    REM )
  )

  
)

GOTO :EOF


:BASHSTEPS
    echo -----------------------------------------------------  
    call :TITLE " Installing BBH Elixir Instance %instancename%"
    echo -----------------------------------------------------
    echo   %instancename%
    echo     to location %instanceRoot%
    cd %root%


    REM Add nodejs to System Path.
    REM set PATH=%PATH%;C:\Program Files\nodejs

    REM call git config http.sslVerify false


    if "true"=="%fastinstall%" (
      echo fastinstall : %fastinstall%
    ) else (
      REM Net Use \\%localREPO% /user:%localREPOUser% %localREPOPwd%

      if "step[REPOSCLONED]"=="false" (
        (for %%a in (
          ember-masonry-grid
          bbhverse
          loopback
          qms
          ember-searchable-select
          loopback-component-jsonapi
          config
          loopback-connector-ds
        ) do ( 
          CALL :GITCLONE %localREPO%/repos %instanceRoot% %%a
        ))
        echo set step[REPOSCLONED]=true>>%runfile%
      ) else (

        echo Repositories Already CLoned.

        REM PB : TODO - pull repositories.
      )
      

      REM echo Upgrading NPM
      REM call npm i npm@latest -g
      
      echo Installing Ember cli
      set existcheck=false
      echo existcheck=%existcheck%
      call :CHECKRUNNABLE ember
      echo existcheck=%existcheck%
      pause
      if "%existcheck%"=="true" (
          echo   Already Installed %2
        ) else (
          echo Installing ember
          start /w cmd /c npm install -g ember-cli
        ) 

      cd %instanceRoot%\qms
      git checkout genericMRWip --force
      REM npm rebuild node-sass
      
      if "step[PROJECTNPMINSTALL]"=="false" (
        :: NPM INSTALL
        for %%a in (
          loopback
          qms
          qms/server
        ) do ( 
          del %instanceRoot%\%%a\package-lock.json
          echo npm install FOR %%a
          cd %instanceRoot%\%%a
          echo %pwd%
          call npm install   
        )
        echo set step[PROJECTNPMINSTALL]=true>>%runfile%
      ) else (
        echo npm install already completed.
      )

      REM BOWER INSTALL
      (for %%a in (
        qms
      ) do ( 
        cd %instanceRoot%\%%a
        echo Calling Bower install FOR %%a
        call "./node_modules/.bin/bower" install
      ))

      echo " copying roboto"
      mkdir %instanceRoot%\qms\bower_components\materialize\dist\fonts\roboto
      xcopy %localREPO%\repos\roboto %instanceRoot%\qms\bower_components\materialize\dist\fonts\roboto
    )

    

    call :INITDBANDSCHEMA

    REM cd ..
    REM ember s

    REM call :COLORIZEHELP

    echo Review post install steps in readme.
    REM Install chrome ember inspector..
    REM https://stackoverflow.com/questions/24612297/why-is-my-ember-cli-build-time-so-slow-on-windows

    
  

exit /b

:INITDBANDSCHEMA
    MKDIR %instanceRoot%\qms\data\filestore
    echo Initializing DB and schema
    MKDIR %instanceRoot%\loopback\common\schemaBuilderSource
    REM start /WAIT  cmd /k 
    echo call %xamppinstllpath%\mysql\bin\mysql -uroot -p -e "CREATE DATABASE elixir;">%instanceRoot%\tmp\mysql.bat
    
    REM echo mkdir
    REM start /WAIT cmd /k 
    echo robocopy /E %instanceRoot%\loopback\common\models %instanceRoot%\loopback\common\schemaBuilderSource>>%instanceRoot%\tmp\mysql.bat

    echo cd %instanceRoot%\loopback>>%instanceRoot%\tmp\mysql.bat
    REM set NODE_ENV=devmysql
    REM start /wait cmd /k 

    REM PB : TODO -- loopback filestore connector doesn't honor relative path !? always looks for loopback root project folder !?
    REM TEMP HACK to get the schema created.
    echo mkdir %instanceRoot%\loopback\qms\data\filestore>>%instanceRoot%\tmp\mysql.bat
    echo cmd /V /C "SET NODE_ENV=devmysql&& node sage-rw\bin\schemabuilder.js">>%instanceRoot%\tmp\mysql.bat

    start /wait cmd /k %instanceRoot%\tmp\mysql.bat
    REM PB : TODO -- Remove TEMP HACK to get the schema created.
    echo del %instanceRoot%\loopback\qms\data\filestore>>%instanceRoot%\tmp\mysql.bat

exit /b


:RUNASADMINISTRATOR ...

  CALL :INITFORRUNASADMINISTRATOR
  CALL :QUEUEFORRUNASADMINISTRATOR %*
  CALL :EXECQUEUEDFORRUNASADMINISTRATOR

exit /b

:INITFORRUNASADMINISTRATOR
  @echo off

  echo @echo off>%instanceRoot%\tmp\runasadmin.bat
  echo :: BatchGotAdmin>>%instanceRoot%\tmp\runasadmin.bat
  echo :------------------------------------->>%instanceRoot%\tmp\runasadmin.bat
  echo REM  --^> Check for permissions>>%instanceRoot%\tmp\runasadmin.bat
  echo ^>nul 2^>^&1 "%%SYSTEMROOT%%\system32\cacls.exe" "%%SYSTEMROOT%%\system32\config\system">>%instanceRoot%\tmp\runasadmin.bat
  echo REM -- If error flag set, we do not have admin.>>%instanceRoot%\tmp\runasadmin.bat
  echo if '%%errorlevel%%' NEQ '0' (>>%instanceRoot%\tmp\runasadmin.bat
  echo     echo Requesting administrative privileges...>>%instanceRoot%\tmp\runasadmin.bat
  echo     goto UACPrompt>>%instanceRoot%\tmp\runasadmin.bat
  echo ) else ( goto gotAdmin )>>%instanceRoot%\tmp\runasadmin.bat

  echo :UACPrompt>>%instanceRoot%\tmp\runasadmin.bat
  echo     echo Set UAC = CreateObject^^("Shell.Application"^^) ^> "%%temp%%\getadmin.vbs">>%instanceRoot%\tmp\runasadmin.bat
  echo     set params ^= %%^*^:^"^=^"^">>%instanceRoot%\tmp\runasadmin.bat
  echo     echo UAC.ShellExecute "cmd.exe", "/c %%~s0 %%params%%", "", "runas", 1 ^>^> "%%temp%%\getadmin.vbs">>%instanceRoot%\tmp\runasadmin.bat
  echo     "%%temp%%\getadmin.vbs">>%instanceRoot%\tmp\runasadmin.bat
  echo     del "%%temp%%\getadmin.vbs">>%instanceRoot%\tmp\runasadmin.bat
  echo     exit /B>>%instanceRoot%\tmp\runasadmin.bat
  echo :gotAdmin>>%instanceRoot%\tmp\runasadmin.bat
  echo     pushd "%%CD%%">>%instanceRoot%\tmp\runasadmin.bat
  echo     CD /D "%%~dp0">>%instanceRoot%\tmp\runasadmin.bat
  echo :-------------------------------------->>%instanceRoot%\tmp\runasadmin.bat

exit /b

:QUEUEFORRUNASADMINISTRATOR ...
  echo %*>>%instanceRoot%\tmp\runasadmin.bat
exit /b

:EXECQUEUEDFORRUNASADMINISTRATOR
  START /W cmd.exe /c %instanceRoot%\tmp\runasadmin.bat
exit /b

REM Check if app is installed
:CHECKRUNNABLE <app>
  set existcheck=false
  for /f "delims=" %%i in ('where %1') do set existcheck=%%i
  echo Is Runnable for %1 : %existcheck%
  pause
  if exist "%existcheck%" (
    echo %1 [exists] %existcheck%
    echo %1=%existcheck%
    REM set existcheck=true
    REM node %~dp0app.js
  ) else (
    set existcheck=false
    echo %1=%existcheck%
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

:: Run step if not already run.
:RUNSTEP <STEP>
  if "!step[%1]!"=="true" (
    echo Skipping %1 already run. Use force to rerun all again.
  ) else (
    CALL :%1
  )
exit /b

:INSTALLWINBUILDTOOLS
    CALL :QUEUEFORRUNASADMINISTRATOR Powershell.exe npm install -g windows-build-tools
    set step[INSTALLWINBUILDTOOLS]=true
    echo set step[INSTALLWINBUILDTOOLS]=true>>%runfile%
  
exit /b

:CHECKANDINSTALLXAMPP <runnablename> <name> <url> <DownloadedFile> <installer>
  echo Detecting %1
  if exist %1 (
    echo %1 already installed
    call :XAMPPSERVICESSTART
  ) else ( echo   Installing %1
    if "%4" == "" (

      CALL :GETINSTALLER %3 %4 %2 false
      CALL :RUNINSTALLER %4 %2 false
    ) else (

      CALL :GETINSTALLER %3 %4 %2 false
      CALL :%5 %4 %2 false
    ) 
  )
exit /b

:CHECKANDINSTALLJAVA <version> <name> <url> <DownloadedFile> <installer>
  echo Detecting %2
  call :CHECKRUNNABLE %2
  if "%existcheck%"=="true" (
    echo %2 already installed
  ) else ( echo   Installing %2
    if exist "%4" (

      CALL :%5 %4 %2 %1 false
    ) else (

      CALL :GETINSTALLER %3 %4 %2 false
      CALL :%5 %4 %2 %1 false
    ) 
  )
exit /b

:JAVAINSTALLER <File> <name> <path> <notinstalled>
    echo  javainstllpath=%javainstllpath%
    mkdir  %root%\runtime\openjdk-13.0.1_windows-x64_bin
    echo unzip %1 -d %javainstllpath%
    unzip %1 -d %javainstllpath%
    echo %path%
    call :CHECKRUNNABLE %2
    if "%existcheck%"=="true" (
      echo java path Successfuly set
    ) else (
      echo FAILED : java path not set
    )  

exit /b

:checkIsGitBash 
  call :CHECKRUNNABLE ls
  if "%existcheck%"=="true" (

    set isGitBash=true
    echo Running in Git Bash
  ) else (
    echo Not Git Bash assume Windows CMD
    set isGitBash=false
  )
exit /b

:CHECKANDINSTALL <name> <url> <DownloadedFile> <installer>
REM echo Detecting %1
  call :CHECKRUNNABLE %1 
  if "%existcheck%"=="true" (
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
  if "%existcheck%"=="true" (
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
    if "%existcheck%"=="true" (
      echo   Installed %2
    ) else (
      CALL :ERROR "  INSTALL FAILED %1"
    )
exit /b

:XAMPPINSTALLER <File> <name> <notinstalled>
  echo(  echo     xamppinstllpath=%xamppinstllpath%
    echo START %1 --unattendedmodeui minimal --disable-components xampp_mercury,xampp_tomcat,xampp_webalizer --mode unattended --launchapps 0 --prefix "%xamppinstllpath%"
    START /WAIT %1 --unattendedmodeui minimal --disable-components xampp_mercury,xampp_tomcat,xampp_webalizer --mode unattended --prefix "%xamppinstllpath%"
    REM START /WAIT %1 
    REM PB :TOD -- prefix doesnt work - Always installs to c:\xampp
    call :XAMPPSERVICESSTART
  
exit /b

:XAMPPSERVICESSTART
  call :QUEUESTARTAPACHE
  call :QUEUESTARTMYSQL

    REM PB : TODO -- These service start verification should happen after the are actually started.
    REM Need to move these to start services and check .... or into the queue...
    REM start /WAIT  %xamppinstllpath%\mysql\bin\mysql -uroot -p mysql -e "select * from user;"
    REM if %ERRORLEVEL%==0 (
    REM   echo mysql Start Successful 
    REM ) else (
    REM   CALL : MYSQL Service Start ERROR "  INSTALL FAILED %1"
    REM )
exit /b

:QUEUESTARTAPACHE
    CALL :QUEUEFORRUNASADMINISTRATOR echo Starting Apache Service
    CALL :QUEUEFORRUNASADMINISTRATOR cd %xamppinstllpath%\apache    
    CALL :QUEUEFORRUNASADMINISTRATOR CALL %xamppinstllpath%\apache\apache_installservice.bat
exit /b

:QUEUESTARTMYSQL
    CALL :QUEUEFORRUNASADMINISTRATOR echo Starting Mysql Service
    CALL :QUEUEFORRUNASADMINISTRATOR cd %xamppinstllpath%\mysql
    CALL :QUEUEFORRUNASADMINISTRATOR CALL %xamppinstllpath%\mysql\mysql_installservice.bat
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

:: Lookup an array of values.
REM set step[AAA]=true
REM set step[BBB]=false
REM set step[CCC]=true

REM for %%a in (AAA BBB CCC) do (
REM   echo Looking up step[%%a]
REM   CALL :LOOKUP %%a
REM )

REM GOTO :EOF

REM :LOOKUP <name>
REM   for /F %%a in ('echo step[%1]') do echo !%%a!
REM exit /b

:EOF



