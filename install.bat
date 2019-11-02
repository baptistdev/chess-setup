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

  @echo set localREPO=%localREPO%> %instanceRoot%\config.bat
  @echo     set localREPOUNCUser=%localREPOUNCUser%>> %instanceRoot%\config.bat
  @echo     set localREPOUNCPwd=%localREPOUNCPwd%>> %instanceRoot%\config.bat
  @echo     set gitUser=%gitUser%>> %instanceRoot%\config.bat
  @echo     set gitEmail=%gitEmail%>> %instanceRoot%\config.bat

  @echo set remoteREPO=%remoteREPO%>> %instanceRoot%\config.bat
  @echo     set remoteREPOHTTPSUser=%remoteREPOHTTPSUser%>> %instanceRoot%\config.bat
  @echo     set remoteREPOHTTPSPwd=%remoteREPOHTTPSPwd%>> %instanceRoot%\config.bat

  @echo set instancename=%instancename%>> %instanceRoot%\config.bat

)

echo Using Instance Setup Folder : 
if exist %instanceRoot%\setup (
    echo   %instanceRoot%\setup
    echo     Already exists
) else (  MKDIR %instanceRoot%\setup
    echo     Folder Created
)

set runfile=%instanceRoot%\tmp\run.txt
echo %runfile%
REM xampp folder
set xamppinstllpath=c:\xampp

set javaversion=jdk-13.0.1
set javainstaller=openjdk-13.0.1_windows-x64_bin
set javainstllpath=%root%\runtime\%javainstaller%
set javapath=%javainstllpath%\%javaversion%\bin

if exist %runfile% (
  REM Already running so lets not get into a loop...
  pause
  call :BASHSTEPS 

) else ( mkdir %instanceRoot%\tmp
  echo started>%instanceRoot%\tmp\run.txt

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
  call :CHECKANDINSTALL python https://www.python.org/ftp/python/2.7.16/python-2.7.16.amd64.msi %mypath%\Downloads\python-2.7.16.amd64.msi RUNMSIINSTALLER
  
  echo xamppinstllpath %xamppinstllpath%
  call :CHECKANDINSTALLXAMPP %xamppinstllpath%\xampp-control.exe xampp https://www.apachefriends.org/xampp-files/7.3.5/xampp-windows-x64-7.3.5-1-VC15-installer.exe %mypath%\Downloads\xampp-windows-x64-7.3.5-1-VC15-installer.exe XAMPPINSTALLER
  
  call :CHECKANDINSTALLJAVA openjdk-13.0.1_windows-x64_bin java https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_windows-x64_bin.zip  %mypath%\Downloads\openjdk-13.0.1_windows-x64_bin.zip JAVAINSTALLER
  

  echo checking gitbashrun
  if exist "%instanceRoot%\tmp\gitbashrun.txt" (
    echo git-bash process already launched
  ) else (
    if "true"=="%isGitBash%" (
      call :BASHSTEPS
    ) else ( REM Switch to a git bash shell to continue
      cd %root%
      echo started>%instanceRoot%\tmp\gitbashrun.txt
      echo "C:\Program Files\Git\git-bash" -c "/c/elixir-tt/setup/install.bat"
      call "C:\Program Files\Git\git-bash" -c "/c/elixir-tt/setup/install.bat"
      del %instanceRoot%\tmp\gitbashrun.txt
    )
  )
)

del %instanceRoot%\tmp\run.txt
GOTO :EOF


:BASHSTEPS
    call :INSTALLWINBUILDTOOLS
    pause
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
      
      Clone repo list.
      (for %%a in (
        ember-masonry-grid
        bbhverse
        loopback
        qms
        ember-searchable-select
        loopback-component-jsonapi
        config
        loopback-connector-ds
        setup
      ) do ( 
        CALL :GITCLONE %localREPO%/repos %instanceRoot% %%a
      ))

      REM echo Upgrading NPM
      REM call npm i npm@latest -g
      
      echo Installing Ember cli
      call :CHECKRUNNABLE ember
      if "%output%"=="true" (
          echo   Already Installed %2
        ) else (
          call npm install -g ember-cli
        ) 

      cd %instanceRoot%\qms
      git checkout genericMRWip
      REM npm rebuild node-sass
      
      REM NPM INSTALL
      (for %%a in (
        loopback
        qms
        qms/server
      ) do ( 
        del %instanceRoot%\%%a\package-lock.json
        echo npm install FOR %%a
        cd %instanceRoot%\%%a
        echo %pwd%
        call npm install   
      ))

      REM BOWER INSTALL
      (for %%a in (
        qms
      ) do ( 
        cd %instanceRoot%\%%a
        echo %pwd%
        echo Calling Bower install FOR %%a
        call "./node_modules/.bin/bower" install
      ))

      echo " copying roboto"
      mkdir %instanceRoot%\qms\bower_components\materialize\dist\fonts\roboto
      xcopy %localREPO%\repos\roboto %instanceRoot%\qms\bower_components\materialize\dist\fonts\roboto

    )

    MKDIR %instanceRoot%\qms\data\filestore

    REM load schema.
    %xamppinstllpath%\mysql\bin\mysql -uroot -p mysql -e "CREATE DATABASE elixir;" 
    REM MKDIR %instanceRoot%\loopback\common\schemaBuilderSource
    REM echo mkdir
    start /WAIT robocopy %instanceRoot%\loopback\common\models %instanceRoot%\loopback\common\schemaBuilderSource  /COPYALL /E

    cd %instanceRoot%\loopback
    cd
    set NODE_ENV=devmysql
    REM start /wait node sage-rw\bin\schemabuilder.js

    REM cd ..
    REM ember s

    REM call :COLORIZEHELP

    echo Review post install steps in readme.
    REM Install chrome ember inspector..
    REM https://stackoverflow.com/questions/24612297/why-is-my-ember-cli-build-time-so-slow-on-windows

    
  

exit /b


:RUNASADMINISTRATOR ...


  @echo off

  echo @echo off>runasadmin.bat
  echo :: BatchGotAdmin>>runasadmin.bat
  echo :------------------------------------->>runasadmin.bat
  echo REM  --^> Check for permissions>>runasadmin.bat
  echo ^>nul 2^>^&1 "%%SYSTEMROOT%%\system32\cacls.exe" "%%SYSTEMROOT%%\system32\config\system">>runasadmin.bat
  echo REM -- If error flag set, we do not have admin.>>runasadmin.bat
  echo if '%%errorlevel%%' NEQ '0' (>>runasadmin.bat
  echo     echo Requesting administrative privileges...>>runasadmin.bat
  echo     goto UACPrompt>>runasadmin.bat
  echo ) else ( goto gotAdmin )>>runasadmin.bat

  echo :UACPrompt>>runasadmin.bat
  echo     echo Set UAC = CreateObject^^("Shell.Application"^^) ^> "%%temp%%\getadmin.vbs">>runasadmin.bat
  echo     set params ^= %%^*^:^"^=^"^">>runasadmin.bat
  echo     echo UAC.ShellExecute "cmd.exe", "/c %%~s0 %%params%%", "", "runas", 1 ^>^> "%%temp%%\getadmin.vbs">>runasadmin.bat
  echo     "%%temp%%\getadmin.vbs">>runasadmin.bat
  echo     del "%%temp%%\getadmin.vbs">>runasadmin.bat
  echo     exit /B>>runasadmin.bat
  echo :gotAdmin>>runasadmin.bat
  echo     pushd "%%CD%%">>runasadmin.bat
  echo     CD /D "%%~dp0">>runasadmin.bat
  echo :-------------------------------------->>runasadmin.bat

  echo %*>>runasadmin.bat

  call c:\elixir\runasadmin.bat 

exit /b



REM Check if app is installed
:CHECKRUNNABLE <app>
  set output=false
  for /f "delims=" %%i in ('where %1') do set output=%%i
  echo Is Runnable for %1 : %output%
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

:INSTALLWINBUILDTOOLS

  CALL :RUNASADMINISTRATOR Powershell.exe npm install -g windows-build-tools

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
  if "%output%"=="true" (
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
    unzip %1 -d %javainstllpath%
    setx path "%path%;%javapath%" 
    echo %path%
    call :CHECKRUNNABLE %2
    if "%output%"=="true" (
      echo java path Successfuly set
    ) else (
      echo FAILED : java path not set
    )  

exit /b

:checkIsGitBash 
  call :CHECKRUNNABLE ls
  if "%output%"=="true" (

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
  echo(  echo     xamppinstllpath=%xamppinstllpath%
    echo START %1 --unattendedmodeui minimal --disable-components xampp_mercury,xampp_tomcat,xampp_webalizer --mode unattended --launchapps 0 --prefix "%xamppinstllpath%"
    START /WAIT %1 --unattendedmodeui minimal --disable-components xampp_mercury,xampp_tomcat,xampp_webalizer --mode unattended --prefix "%xamppinstllpath%"
    REM START /WAIT %1 
    REM PB :TOD -- prefix doesnt work - Always installs to c:\xampp
    call :XAMPPSERVICESSTART
  
exit /b

:XAMPPSERVICESSTART
    echo %xamppinstllpath%\apache
    cd %xamppinstllpath%\apache    
    REM echo start /WAIT runas /savecred /user:baptistmis "cmd /c %xamppinstllpath%\apache\apache_installservice.bat"
    
    @echo pause> %instanceRoot%\tmp\startapache.bat
    @echo     cd %xamppinstllpath%\apache>> %instanceRoot%\tmp\startapache.bat
    @echo     echo starting...>> %instanceRoot%\tmp\startapache.bat
    @echo     pause>> %instanceRoot%\tmp\startapache.bat
    @echo     CALL %xamppinstllpath%\apache\apache_installservice.bat>> %instanceRoot%\tmp\startapache.bat
  
    echo start /WAIT runas /savecred /user:admin "cmd /c C:\elixir\instances\elixir_01\tmp\startapache.bat"
    REM start /WAIT runas /savecred /user:admin "cmd /c C:\elixir\instances\elixir_01\tmp\startapache.bat"
    
    cd %xamppinstllpath%\mysql
    REM echo start /WAIT runas /savecred /user:admin "cmd /c %xamppinstllpath%\mysql\mysql_installservice.bat"
    @echo pause> %instanceRoot%\tmp\startmysql.bat
    @echo     cd %xamppinstllpath%\mysql>> %instanceRoot%\tmp\startmysql.bat
    @echo     echo starting...>> %instanceRoot%\tmp\startmysql.bat
    @echo     pause>> %instanceRoot%\tmp\startmysql.bat
    @echo     CALL %xamppinstllpath%\mysql\mysql_installservice.bat>> %instanceRoot%\tmp\startmysql.bat

    REM start /WAIT runas /savecred /user:admin "cmd /c C:\elixir\instances\elixir_01\tmp\startmysql.bat"

    REM call :CHECKRUNNABLE %2
    REM start /WAIT runas.exe /savecred /user:baptistmis %xamppinstllpath%\mysql\bin\mysql -uroot -p mysql -e "select * from user;"
    if %ERRORLEVEL%==0 (
      echo mysql Start Successful 
    ) else (
      CALL : MYSQL Service Start ERROR "  INSTALL FAILED %1"
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