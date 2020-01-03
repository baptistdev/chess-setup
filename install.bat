@echo off 
setlocal EnableDelayedExpansion

color 0B 
REM chcp 65001
REM color 0B & Mode 80,40

echo -----------------------------------
call :TITLE "     BBH Elixir Installer "
echo -----------------------------------

set isGitBash=false
REM call :checkIsGitBash
REM echo Gitbash=%isGitBash%


set root=
set relaunchPath=%PATH%
if "!step[RELAUNCHWITHENV]!"=="true" (
  cd ..\..\ 

)
set mypath=!cd!
set root=!mypath!
set thisBatchLaunchPath=%~dp0

rem ----------------------------------
!instanceRoot: =!
echo %root%\instanceroot.txt

set get_cd=!CD!
echo get_cd !get_cd! ">>>>>>>>>>>>>>"

echo instance root: !instanceRoot!

if "!step[RELAUNCHWITHENV]!"=="true" (
  CALL !instanceRoot: =!\config.bat

)
else (
  if exist !get_cd!\instanceroot.txt (
    echo ifblock -----------------
    echo !get_cd!\instanceroot.txt
    set /p instanceRoot=<!get_cd!\instanceroot.txt
    REM set instanceRoot=!instanceRoot: =! 
    
    echo ">>>>>>>>>>" !instanceRoot: =!\config.bat

    CALL !instanceRoot: =!\config.bat
    REM del "!get_cd!\instanceroot.txt"
  ) else (

    echo Select a instance name:
    echo =============
      
    set /p instancename="Type instancename Ex: elixir: "
    REM if "%op%"=="4" goto op4
    echo instancename : !instancename!

    rem default instance name:chess/instances
    if "!instancename!" == "" (
      set instancename=elixir
    )
    echo instancename : !instancename! ">>>>>>>>>>>>"
    
    echo ---------------------------------------------------------
    echo Select a instance type:
    echo =============
    echo -
    echo 1. development-default  1
    echo 2. test 2
    echo 3. stage 3

    echo -
    CHOICE /C 123 /M "Enter your choice:"

    IF ERRORLEVEL 3 GOTO option3
    IF ERRORLEVEL 2 GOTO option2
    IF ERRORLEVEL 1 GOTO option1 

    :option1
    set instancetype=dev
    GOTO End
    :option2
    set instancetype=test
    GOTO End
    :option3
    set instancetype=stage
    GOTO End

    :End
    set instanceRoot=%root%\!instancename!\!instancetype! 
    if not exist %root%\instanceroot.txt (
    echo !instanceRoot!>%root%\instanceroot.txt
  
   )
  )
)
  echo  instancetype : !instancetype! 

  echo instancetype : !instancetype!  ">>>>>>>>>>>>"

REM )
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

echo thisBatchLaunchPath = !thisBatchLaunchPath!  
if "%PWD%"=="" (
  :: Windows doesnt have the PWD env variable.
  echo Detected Running in windows cmd shell.  
) else (
  set isGitBash=true  
  echo Detected Running in bash shell.  
  echo bash shell env should already be preset...
  REM pause
)
  
set fastinstall=false
  

echo instanceRoot=!instanceRoot!

mkdir !instanceRoot!


mkdir !instanceRoot: =!\tmp

echo 
echo instanceRoot=!instanceRoot!
echo root=%root%
pause


set instanceRoot=!instanceRoot: =!

REM echo %relaunchPath%
echo -------------- existing ----------------------
REM type !instanceRoot!\tmp\collectpath.bat
call !instanceRoot!\tmp\collectpath.bat
REM echo !relaunchPath!
echo -------------- altered ----------------------
set PATH=!PATH!;!relaunchPath!
REM path

echo !instanceRoot!\config.bat
pause

if exist !instanceRoot!\config.bat (
  echo Loading configuration
  CALL !instanceRoot!\config.bat
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
    REM echo !localREPO!
    REM pause
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

REM   echo. --------------------please select instance type-----------------

REM   echo 1.test
REM   echo 2.master
REM   REM echo 3.production

REM  if ""=="%instancetype%" (
REM     set /p instancetype="Type option: "
REM   )
REM   echo %instancetype%

REM   REM set /p a="Enter your choice: "
REM   REM if %a%==1 (
REM   REM    set instancetype=test
REM   REM )
REM   REM if %a%==2 ( 
REM   REM   set instancetype=development
REM   REM )
REM   REM if %a%==3 (
REM   REM    set instancetype=production 
REM   REM )


  echo Using Repositories : 
  echo     Local  : !localREPO!
  echo     User : !localREPOUNCUser! 
  echo     Pwd  : !localREPOUNCPwd!
  echo     Gituser: !gitUser! 
  echo     Gitemail: !gitEmail! 
  echo     Remote : !remoteREPO!
  echo     User : !remoteREPOHTTPSUser! 
  echo     Pwd  : !remoteREPOHTTPSPwd! 
  echo     Instancetype  : !instancetype! 

  REM echo -----------------------------
  REM pause

  @echo set localREPO=!localREPO!>!instanceRoot!\config.bat
  @echo     set localREPOUNCUser=!localREPOUNCUser!>>!instanceRoot!\config.bat
  echo localREPOUNCUser = !instanceRoot!
  @echo     set localREPOUNCPwd=!localREPOUNCPwd!>>!instanceRoot!\config.bat
  @echo     set gitUser=!gitUser!>>!instanceRoot!\config.bat
  @echo     set gitEmail=!gitEmail!>>!instanceRoot!\config.bat

  @echo set remoteREPO=!remoteREPO!>>!instanceRoot!\config.bat
  @echo     set remoteREPOHTTPSUser=!remoteREPOHTTPSUser!>>!instanceRoot!\config.bat
  @echo     set remoteREPOHTTPSPwd=!remoteREPOHTTPSPwd!>>!instanceRoot!\config.bat

  @echo set instancename=!instancename!>>!instanceRoot!\config.bat
  @echo set instancetype=!instancetype!>>!instanceRoot!\config.bat

)

echo Net Use \\!localREPO!\repos /user:!localREPOUNCUser! !localREPOUNCPwd!
Net Use \\!localREPO!\repos /user:!localREPOUNCUser! !localREPOUNCPwd!
pause
  
REM REM copy softwares from local repo only if local repo exist
REM call :CHECKLOCALGITREPO
REM :CHECKLOCALGITREPO
REM echo gitcheck for %localREPO% .....
REM if exist \\%localREPO%\repos\downloads (
REM     REM echo  XCOPY \\%localREPO%\repos\downloads !instanceRoot!\Downloads /I /E /Y
REM     echo %localREPO%\repos\downloads found
REM     pause
REM     XCOPY \\%localREPO%\repos\downloads !instanceRoot!\Downloads /I /E /Y
REM     REM call :GITCLONE %localREPO%\repos\downloads !instanceRoot!\Downloads test
REM ) else (
REM   echo localrepo : %localREPO%\repos\downloads not found )
REM exit /b

set runfile=!instanceRoot!\tmp\run.log.bat
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
set step[UACSTEPS]=false
set step[NPMUPGRADE]=false
set step[DBSCHEMA]=false

REM call :INITDBANDSCHEMA

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

set existcheck=false

if "%step[PREREQS]%"=="true" (
  echo Prerequistes install already completed.

  REM PB :TODO -- We still need to check if we are in bash before running the BASHSTEPS.

  REM echo Net Use \\%localREPO%\repos /user:%localREPOUNCUser% %localREPOUNCPwd%
  echo ------------before bashsteps-------------
  pause
  
  call :BASHSTEPS 

) else ( 
  echo set step[STARTED]=true>>!instanceRoot!\tmp\run.log.bat

  REM set xamppinstllpath=%root%\runtime\xampp
  if exist "%xamppinstllpath%" (
    echo   %xamppinstllpath%
    echo    %xamppinstllpath% Already exists
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

if "!step[UACSTEPS]!"=="false" (
    CALL :INITFORRUNASADMINISTRATOR
    CALL :QUEUEFORRUNASADMINISTRATOR cd %root%
    set step[UACSTEPS]=start
    echo set step[UACSTEPS]=start>>!instanceRoot!\tmp\run.log.bat
    CALL :QUEUEFORRUNASADMINISTRATOR cmd /b /c %thisBatchLaunchPath%install.bat
    call :EXECQUEUEDFORRUNASADMINISTRATOR

    pause
    echo UAC Steps completed.

    CALL :INITFORRUNASADMINISTRATOR
    echo echo set relaunchPath=%%path%%^>!instanceRoot!\tmp\collectpath.bat>>!instanceRoot!\tmp\runasadmin.bat
    echo echo pause>!instanceRoot!\tmp\collectpath.bat>>!instanceRoot!\tmp\runasadmin.bat
    REM CALL :QUEUEFORRUNASADMINISTRATOR set path=%%path%%^>%!instanceRoot!%\tmp\collectpath.bat
    CALL :QUEUEFORRUNASADMINISTRATOR path
    CALL :QUEUEFORRUNASADMINISTRATOR pause
    call :EXECQUEUEDFORRUNASADMINISTRATOR

    echo Post UAC PATH collected.
   
    

  )

  echo UAC STATUS !step[UACSTEPS]!
  pause
  if exist %runfile% (
    echo Loading Runtime State
    CALL %runfile%
  ) else (
    echo No Previous Run detected.
  )
  echo UAC STATUS !step[UACSTEPS]!
  pause
  if "!step[UACSTEPS]!"=="start" (
    :: We r now in a new UAC SHELL where we can do UAC steps.
    REM  <name> <intsallerfile> <installerpath> <url> <installer>
    
    call :CHECKANDINSTALL git  Git-2.23.0-64-bit.exe %mypath%\Downloads\ https://github.com/git-for-windows/git/releases/download/v2.23.0.windows.1/Git-2.23.0-64-bit.exe
    
    call :CHECKANDINSTALL node node-v10.16.0-x64.msi %mypath%\Downloads\ https://nodejs.org/dist/v10.16.0/node-v10.16.0-x64.msi  RUNMSIINSTALLER  
    REM PB : TODO -- Once we have git and node in place relaunch batch file to clone the setup from repo and
    REM  -- hand over he installation there... and skip the rest here...

    call :CHECKANDINSTALL code vscode-win32-x64-latest-stable.exe %mypath%\Downloads\ https://vscode-update.azurewebsites.net/latest/win32-x64/stable 
    REM call :CHECKANDINSTALL .net https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe %mypath%\Downloads\NDP461-KB3102436-x86-x64-AllOS-ENU.exe
    REM call :CHECKANDINSTALL python https://www.python.org/ftp/python/3.6.5/python-3.6.5-amd64.exe %mypath%\Downloads\python-3.6.5-amd64.exe
    call :CHECKANDINSTALL python python-2.7.16.amd64.msi %mypath%\Downloads\ https://www.python.org/ftp/python/2.7.16/python-2.7.16.amd64.msi RUNMSIINSTALLER
    REM :SETUACSTEPS true
    REM call :CHECKANDINSTALL python python-2.7.16.amd64.msi %mypath%\Downloads\ https://www.python.org/ftp/python/2.7.16/python-2.7.16.amd64.msi RUNMSIINSTALLER
       
    set step[UACSTEPS]=true
    echo set step[UACSTEPS]=true>>!instanceRoot!\tmp\run.log.bat

    
    echo step[UACSTEPS] : !step[UACSTEPS]!
    echo step[RELAUNCHWITHENV] : %step[RELAUNCHWITHENV]%
    pause

    :: Shell will exit and resume in original shell from where it was called.
    exit /b
  )

  :: Need to reread on return
  CALL %runfile%
  call !instanceRoot!\tmp\collectpath.bat
  echo !relaunchPath!
  echo -------------- altered ----------------------
  set PATH=!PATH!;!relaunchPath!


  echo step[UACSTEPS] : !step[UACSTEPS]!
  echo step[RELAUNCHWITHENV] : !step[RELAUNCHWITHENV]!
  echo -----------------------------
  pause
  
  if "!step[UACSTEPS]!"=="true" (

    pause
    call git config --global --add user.name "%gitUser%"
    call git config --global --add user.email "%gitUser%"

    echo !localREPO!\
    REM echo Net Use \\%localREPO%\repos /user:%localREPOUNCUser% %localREPOUNCPwd%
    REM Net Use \\%localREPO%\repos /user:%localREPOUNCUser% %localREPOUNCPwd% 
    REM net use \\172.16.0.27\repos /user:bbh\baptist 2018Bbh
   
    REM pause
    CALL :GITCLONE %localREPO%/repos !instanceRoot! setup

    echo step[PREREQS]=%step[PREREQS]%
    if "!step[RELAUNCHWITHENV]!"=="true" (
      path
   
      
      REM PB : TODO -- Esure npm is available with path already set.

      CALL :INITFORRUNASADMINISTRATOR
      call :CHECKBUILDTOOLS
      if "!existbuildtools!" == "false" (
          call :RUNSTEP INSTALLWINBUILDTOOLS
      )
      echo xamppinstllpath %xamppinstllpath%
      REM   <runnablename> <name> <url> <DownloadedFile> <installer>
      REM  <name> <intsallerfile> <installerpath> <url> <installer> <runnablename>
      pause
      call :CHECKANDINSTALLXAMPP xampp xampp-windows-x64-7.3.5-1-VC15-installer.exe %mypath%\Downloads\ https://www.apachefriends.org/xampp-files/7.3.5/xampp-windows-x64-7.3.5-1-VC15-installer.exe XAMPPINSTALLER !xamppinstllpath!\xampp-control.exe
      call :EXECQUEUEDFORRUNASADMINISTRATOR
      REM   <name> <url> <DownloadedFile> <installer>   
      REM  <name> <intsallerfile> <installerpath> <url> <installer> <version>

      call :CHECKANDINSTALLJAVA java openjdk-13.0.1_windows-x64_bin.zip %mypath%\Downloads\ https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_windows-x64_bin.zip JAVAINSTALLER openjdk-13.0.1_windows-x64_bin  
      
      REM PB : TODO SHELLEXECUTE DOESNT WAIT...
      REM pause

      echo PREREQS Install completed

      set step[PREREQS]=true
      echo set step[PREREQS]=true>>!instanceRoot!\tmp\run.log.bat
      
      echo checking gitbashrun
      echo !instanceRoot!\tmp\gitbashrun.log.bat
      REM echo %CD%
      echo ----------------------before gitbashrun check ------------
      echo !instanceRoot! 

      echo !instanceRoot!\tmp\gitbashrun.log.bat
      pause

      if exist "!instanceRoot!\tmp\gitbashrun.log.bat" (
        echo git-bash process already launched
      ) else (
        echo ">>>>>>>>>>>>>>>>>>>>>>" else block
      
        if "true"=="%isGitBash%" (
          echo ">>>>>>>>>>>>>>>>>>>>>>>" iSGITBASH TRUE
     
          call :BASHSTEPS
        ) else ( REM Switch to a git bash shell to continue
          echo ">>>>>>>>>>>>>>>>>>>>>>>" iSGITBASH FALSE
  
          cd !instanceRoot!
          echo started>>!instanceRoot!\tmp\gitbashrun.log.bat
          
        

          REM set /p str=<%root%\gitst.txt
          REM set str=!str:~0,-11!
          
          REM echo !str!

      
          REM REM cmd "!instanceRoot!/setup/install.bat !instancename!"
          REM REM  ./setup/install.bat !instancename!
          REM echo "!str!git-bash" -c "./setup/install.bat !instancename!"
      
          REM call "C:\Program Files\Git\git-bash" -c "./setup/install.bat !instancename!"
          echo "!gitbashpath!" -c "./setup/install.bat"
          pause
          call "!gitbashpath!" -c "./setup/install.bat"

          del !instanceRoot!\tmp\gitbashrun.log.bat
   
        )
      )
    ) else ( 
      set check=false
      set cachedpath=
      call :CHECKRUNNABLE python 
      if "!existcheck!"=="false" (
            set cachedpath=C:\python27;
            set check=true
            echo =========inside python
      )

      call :CHECKRUNNABLE java
      if "!existcheck!"=="false" (
            set cachedpath=!javapath!;!cachedpath!
            set check=true
            echo =========inside java
      )

      echo ---------------------------currentpath-------------
      REM echo !path!
      set path=!cachedpath!;!path!
      echo -----------------with cachedpath-----------------------
      REM echo !path!
      REM set /a i=-1
      For %%M in ("!path:;=";"!") do (
        REM   set /a i=!i!+1
        set arr[%%~M]=%%~M
        echo arr[%%~M] 
      )

      REM For /L %%x in (0 1 !i!) do ( 
      REM   echo !arr[%%x]!
      REM )
      Set filteredpath=
      For /f "tokens=2 delims==" %%M in ('Set arr[') do (
          REM echo --%%~M--
          Set "filteredpath=!filteredpath!;%%~M"
          REM echo FFFFFFFF!filteredpath!
      )
      echo -----------------filtered-----------------------
      echo !filteredpath!
      set path=!filteredpath!;
      REM set addxtrachar=!filteredpath!\
      REM set finalpath=!addxtrachar:~1,-1!

      REM if "!check!"=="true" (      
      
      REM set path=!finalpath!;
      setx path "!path!"
      
      REM )
      where git
      pause

      
      echo ---------------------     filtered      ------------------------------
      echo !path!
     
      echo =============after python java chk
       :: Preset paths that dont get set automatically. And are not available until relaunch.
        set step[RELAUNCHWITHENV]=true
        echo set step[RELAUNCHWITHENV]=true>>%runfile%
        cd !instanceRoot!


        where git > !instanceRoot!\setup\gitbashpath.txt
        set /p gitpath=<!instanceRoot!\setup\gitbashpath.txt
        set gitbashpath=!gitpath:~0,-12!\git-bash

        echo "!gitbashpath!" -c "./setup/install.bat !instancename!"
        pause
        call "!gitbashpath!" -c "./setup/install.bat !instancename!"
        pause
        REM call "C:\Program Files\Git\git-bash" -c "./setup/install.bat"

        REM start /i "%windir%\explorer.exe" "%windir%\system32\cmd.exe"
        REM start /w "%windir%\explorer.exe" "%setupFolder%\install.bat"
        REM start /i /wait cmd /k %setupFolder%\install.bat
      
    )
  )
)





GOTO :EOF


:UACSTEPS

exit /b

:BASHSTEPS
    echo -----------------------------------------------------  
    call :TITLE " Installing BBH Elixir Instance %instancename%"
    echo -----------------------------------------------------
    echo   %instancename%
    echo    to location !instanceRoot!
    cd %root%
    REM cd!instanceRoot!\tmp


    REM Add nodejs to System Path.
    REM set PATH=%PATH%;C:\Program Files\nodejs

    REM call git config http.sslVerify false

    REM echo Net Use \\!localREPO!\repos /user:!localREPOUNCUser! !localREPOUNCPwd!
    echo fastinstall = !fastinstall!
    pause
    if "true"=="!fastinstall!" (
      echo if block---------------- ------
      REM echo fastinstall : !fastinstall!
      echo ------------------fAST INSTALL----------------
      pause
    ) else (

      REM echo else block---------------- -----------
      REM echo Net Use \\!localREPO!\repos /user:!localREPOUNCUser! !localREPOUNCPwd!
      REM Net Use \\!localREPO!\repos /user:!localREPOUNCUser! !localREPOUNCPwd!
      

     

      if "!step[REPOSCLONED]!"=="false" (
        (for %%a in (

          ember-masonry-grid
          bbhverse
          server
          client
          ember-searchable-select
          loopback-component-jsonapi
          config
          loopback-connector-ds
        ) do ( 
         CALL :GITCLONE %localREPO%/repos %instanceRoot% %%a
          echo  cd  !instanceRoot!/%%a
          cd  !instanceRoot!/%%a

         if !instancetype! == "dev" (

           git checkout master --f
         ) else (
          
           git checkout !instancetype! --f
         )
  
        ))
        echo set step[REPOSCLONED]=true>>%runfile%
       
      ) else (

        echo Repositories Already CLoned.
       

        REM PB : TODO - pull repositories.
      )

      if "!step[NPMUPGRADE]!"=="false" (
        echo Upgrading NPM
        call npm i npm@latest -g
        set step[NPMUPGRADE]=true
        echo set step[NPMUPGRADE]=true>>%runfile%
      ) else (
        echo NPM Already Upgraded
      )
      
      echo Installing Ember cli
      set existcheck=false
      echo existcheck=!existcheck!
      call :CHECKRUNNABLE ember
      echo existcheck=!existcheck!
      REM pause
      if "!existcheck!"=="true" (
          echo   Already Installed %2
        ) else (
          echo Installing ember
          start /w cmd /b /c npm install -g ember-cli
        ) 



    
      pause
      REM echo  !instanceRoot!\qms
      REM cd !instanceRoot!\qms
      REM pwd
      REM git status -s>>!instanceRoot!\tmp\git_status.txt
      REM set "git_status_check=!instanceRoot!\tmp\git_status.txt"
      REM pause
      REM for %%A in (!git_status_check!) do if %%~zA==0 (
      REM   echo."%%A" is empty
      REM   git checkout genericMRwip --force
      REM ) else (
      REM   echo "git checkout genericMRwip --force not possible because some changes found >>>>>>>>>>>"       
      REM )

      REM cd !instanceRoot!\qms
      REM git checkout genericMRwip --force
      REM npm rebuild node-sass
      
      if "!step[PROJECTNPMINSTALL]!"=="false" (
        :: NPM INSTALL
        for %%a in (
          server
          client
          client/server
 
        ) do ( 
          del !instanceRoot!\%%a\package-lock.json
          echo npm install FOR %%a
          cd !instanceRoot!\%%a
          echo %pwd%
          call npm install   
        )
        echo set step[PROJECTNPMINSTALL]=true>>%runfile%
      ) else (
        echo npm install already completed.
      )

      REM BOWER INSTALL
      for %%a in (
        client
      ) do ( 
        cd !instanceRoot!\%%a
        echo %pwd%
        echo Calling Bower install FOR %%a
        call "./node_modules/.bin/bower" install
        
      )

      del "!root!\instanceroot.txt"
      echo " copying roboto"
      REM pause
      mkdir !instanceRoot!\client\bower_components\materialize\dist\fonts\roboto
      xcopy \\%localREPO%\repos\roboto !instanceRoot!\client\bower_components\materialize\dist\fonts\roboto
    )


    REM pause
   
    call :INITDBANDSCHEMA
    REM pause
    REM cd ..
    REM ember s

    REM call :COLORIZEHELP

    echo Review post install steps in readme.
    REM Install chrome ember inspector..
    REM https://stackoverflow.com/questions/24612297/why-is-my-ember-cli-build-time-so-slow-on-windows

    REM pause
  

exit /b

:INITDBANDSCHEMA
  if "!step[DBSCHEMA]!"=="false" (
   MKDIR !instanceRoot!\client\data\filestore
    echo Initializing DB and schema
    MKDIR !instanceRoot!\server\common\schemaBuilderSource
    REM start /WAIT  cmd /k 
    echo !instanceRoot!
  

    echo call %xamppinstllpath%\mysql\bin\mysql -uroot -p -e "CREATE DATABASE elixir;">>!instanceRoot!\tmp\mysql.bat
    echo pause

    REM echo mkdir
    REM start /WAIT cmd /k 
    echo robocopy /E !instanceRoot!\server\common\models !instanceRoot!\server\common\schemaBuilderSource>>!instanceRoot!\tmp\mysql.bat

  
    echo cd !instanceRoot!\server>>!instanceRoot!\tmp\mysql.bat
    REM set NODE_ENV=devmysql
    REM start /wait cmd /k 

  
    REM PB : TODO -- server filestore connector doesn't honor relative path !? always looks for loopback root project folder !?
    REM TEMP HACK to get the schema created.
    echo mkdir !instanceRoot!\server\client\data\filestore>>!instanceRoot!\tmp\mysql.bat
    echo cmd /V /C "SET NODE_ENV=devmysql&& node elixir\bin\schemabuilder.js">>!instanceRoot!\tmp\mysql.bat

    echo del /s /q  !instanceRoot!\server\client\data\filestore>>!instanceRoot!\tmp\mysql.bat
  
    echo del /s /q !instanceRoot!\server\common\schemaBuilderSource\*.*>>!instanceRoot!\tmp\mysql.bat
    echo exit>>!instanceRoot!\tmp\mysql.bat
    REM del /s /q "!instanceRoot!\server\common\schemaBuilderSource\*.*"
    REM start /wait cmd /b /c !instanceRoot!\tmp\mysql.bat
    cmd /C start /wait  !instanceRoot!\tmp\mysql.bat
 
    REM PB : TODO -- Remove TEMP HACK to get the schema created.
    REM echo del !instanceRoot!\server\qms\data\filestore>>!instanceRoot!\tmp\mysql.bat
    REM echo rm  !instanceRoot!\server\common\schemaBuilderSource\*>>!instanceRoot!\tmp\mysql.bat

  
    set step[DBSCHEMA]=true
    echo set step[DBSCHEMA]=%1>>!instanceRoot!\tmp\run.log.bat

  
  ) else (
    echo INITDBANDSCHEMA already completed
  )

exit /b


:RUNASADMINISTRATOR

  CALL :INITFORRUNASADMINISTRATOR
  CALL :QUEUEFORRUNASADMINISTRATOR %*
  CALL :EXECQUEUEDFORRUNASADMINISTRATOR

exit /b

:INITFORRUNASADMINISTRATOR
  @echo off

  echo @echo off>!instanceRoot!\tmp\runasadmin.bat
  echo :: BatchGotAdmin>>!instanceRoot!\tmp\runasadmin.bat
  echo :------------------------------------->>!instanceRoot!\tmp\runasadmin.bat
  echo REM  --^> Check for permissions>>!instanceRoot!\tmp\runasadmin.bat
  echo ^>nul 2^>^&1 "%%SYSTEMROOT%%\system32\cacls.exe" "%%SYSTEMROOT%%\system32\config\system">>!instanceRoot!\tmp\runasadmin.bat
  echo REM -- If error flag set, we do not have admin.>>!instanceRoot!\tmp\runasadmin.bat
  echo if '%%errorlevel%%' NEQ '0' (>>!instanceRoot!\tmp\runasadmin.bat
  echo     echo Requesting administrative privileges...>>!instanceRoot!\tmp\runasadmin.bat
  echo     goto UACPrompt>>!instanceRoot!\tmp\runasadmin.bat
  echo ) else ( goto gotAdmin )>>!instanceRoot!\tmp\runasadmin.bat

  echo :UACPrompt>>!instanceRoot!\tmp\runasadmin.bat
  echo     echo Set UAC = CreateObject^^("Shell.Application"^^) ^> "%%temp%%\getadmin.vbs">>!instanceRoot!\tmp\runasadmin.bat
  echo     set params ^= %%^*^:^"^=^"^">>!instanceRoot!\tmp\runasadmin.bat
  echo     echo UAC.ShellExecute "cmd.exe", "/b /c %%~s0 %%params%%", "%root%", "runas", 1 ^>^> "%%temp%%\getadmin.vbs">>!instanceRoot!\tmp\runasadmin.bat
  echo     "%%temp%%\getadmin.vbs">>!instanceRoot!\tmp\runasadmin.bat
  echo     del "%%temp%%\getadmin.vbs">>!instanceRoot!\tmp\runasadmin.bat
  echo     exit /B>>!instanceRoot!\tmp\runasadmin.bat
  echo :gotAdmin>>!instanceRoot!\tmp\runasadmin.bat
  echo     pushd "%%CD%%">>!instanceRoot!\tmp\runasadmin.bat
  echo     CD /D "%%~dp0">>!instanceRoot!\tmp\runasadmin.bat
  echo :-------------------------------------->>!instanceRoot!\tmp\runasadmin.bat

exit /b

:QUEUEFORRUNASADMINISTRATOR ...
echo %*
REM pause
 echo %*>>!instanceRoot!\tmp\runasadmin.bat
exit /b

:EXECQUEUEDFORRUNASADMINISTRATOR
  START /W cmd.exe /b /c !instanceRoot!\tmp\runasadmin.bat
exit /b

REM Check if app is installed
:CHECKBUILDTOOLS
  set existbuildtools=false
  set mywhere="C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
  if exist %mywhere% (
    set existbuildtools=true
  )

:CHECKRUNNABLE <name>
  set existcheck=false
  echo Checkrunnable for %1
  for /f "delims=" %%i in ('where %1') do (
  set existcheck=%%i
  )
  echo Is Runnable for %1 : !existcheck!
  
  if exist "!existcheck!" (
    CALL :GREEN √ %1 [exists] !existcheck!
    echo %1 : !existcheck!
    set existcheck=true
    REM node %~dp0app.js
  ) else (
    set existcheck=false
    echo %1=!existcheck!
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

:SETUACSTEPS <val>
  set step[UACSTEPS]=%1
  echo set step[UACSTEPS]=%1>>!instanceRoot!\tmp\run.log.bat
exit /b

:SETSTEPVAR <VAR>
  set step[%1]=true
  echo set step[%1]=true>>!instanceRoot!\tmp\run.log.bat
exit /b

:INSTALLWINBUILDTOOLS
    CALL :QUEUEFORRUNASADMINISTRATOR Powershell.exe npm install -g windows-build-tools
    set step[INSTALLWINBUILDTOOLS]=true
    echo set step[INSTALLWINBUILDTOOLS]=true>>%runfile%
  
exit /b
REM <url> <File> <name> <notinstalled>
     
:CHECKANDINSTALLXAMPP <name> <intsallerfile> <installerpath> <url> <installer> <runnablename> 
pause
echo Detecting %6
  if exist %6 (
    echo %6 already installed
    call :XAMPPSERVICESSTART
  ) else ( echo   Installing %6
    if exist "%3%2" (

      echo using peviously downloaded installer
    ) else (

      CALL :GETINSTALLER %1 %2 %3 %4 false
    
    ) 
     CALL :%5 %3%2 %1 false
  )
exit /b

REM :CHECKANDINSTALLJAVA <version> <name> <url> <DownloadedFile> <installer>
:CHECKANDINSTALLJAVA  <name> <intsallerfile> <installerpath> <url> <installer> <version>
  echo Detecting %1
  call :CHECKRUNNABLE %1
  if "!existcheck!"=="true" (
    echo %1 already installed
  ) else ( echo   Installing %1
    if exist "%3%2" (

      CALL :%5 %3%2 %1 %6 false
    ) else (

      CALL :GETINSTALLER %1 %2 %3 %4 false
      CALL :%5 %3%2 %1 %6 false
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
    if "!existcheck!"=="true" (
      echo java path Successfuly set
    ) else (
      echo FAILED : java path not set
    )  

exit /b

:checkIsGitBash 
  call :CHECKRUNNABLE ls
  if "!existcheck!"=="true" (

    set isGitBash=true
    echo Running in Git Bash
  ) else (
    echo Not Git Bash assume Windows CMD
    set isGitBash=false
  )
exit /b

REM :CHECKANDINSTALL <name> <url> <DownloadedFile> <installer>
:CHECKANDINSTALL <name> <intsallerfile> <installerpath> <url> <installer>
REM echo Detecting %1


  call :CHECKRUNNABLE %1 
  if "!existcheck!"=="true" (
    echo     %1 already installed
  ) else (
    echo   Installing %1
    if "%5" == "" (
      CALL :GETINSTALLER  %1 %2 %3 %4 false
	  REM pause
      CALL :RUNINSTALLER  %1 %2 %3 false
    ) else (
      CALL :GETINSTALLER  %1 %2 %3 %4 false
      CALL :%5 %3%2 %1 false
    )
   
  )
exit /b

REM REM :GETINSTALLER <url> <File> <name> <notinstalled>
REM :GETINSTALLER  <name> <intsallerfile> <installerpath> <url> <notinstalled>
REM   if exist %3%2 (
REM      echo   using previously downloaded installer %3%2
REM   ) else (
REM      echo   downloading %1 installer
REM      CALL :DOWNLOAD %4 %3%2
REM   )
REM exit /b

REM :GETINSTALLER <url> <File> <name> <notinstalled>
:GETINSTALLER <name> <intsallerfile> <installerpath> <url> <notinstalled>
echo -------------------------path 
REM pause
  if exist %3%2 (
   
     echo   using previously downloaded installer %2
   
  ) else (
    echo %3%2% not exist 
   
    if exist \\%localREPO%\repos\downloads\%2 (
     
      echo %localREPO%\repos\downloads\%2 found
      COPY \\%localREPO%\repos\downloads\%2 %3 
     
    ) else (
      
      echo   downloading %1 installer
      CALL :DOWNLOAD %4 %3%2
     
    )
       
  )
exit /b

REM :RUNINSTALLER <File> <name> <notinstalled>
:RUNINSTALLER <name> <intsallerfile> <installerpath> <notinstalled>
  echo   Installing %1
  START /WAIT %3%2 /VERYSILENT /MERGETASKS=!runcode
  call :CHECKRUNNABLE %1
  if "!existcheck!"=="true" (
    echo   Installed %1
  ) else (
    CALL :FATAL "  INSTALL FAILED %3%2"
  )  
exit /b

:RUNMSIINSTALLER <File> <name> <notinstalled>
  echo( 
    echo   Installing %2
    MSIEXEC.exe /i %1 ACCEPT=YES /passive
    call :CHECKRUNNABLE %2
    if "!existcheck!"=="true" (
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
    CALL :QUEUEFORRUNASADMINISTRATOR c: 
    CALL :QUEUEFORRUNASADMINISTRATOR cd /D %xamppinstllpath%\apache 
    CALL :QUEUEFORRUNASADMINISTRATOR CALL %xamppinstllpath%\apache\apache_installservice.bat
    CALL :QUEUEFORRUNASADMINISTRATOR cd /D !root!
 
exit /b

:QUEUESTARTMYSQL
    CALL :QUEUEFORRUNASADMINISTRATOR echo Starting Mysql Service
    CALL :QUEUEFORRUNASADMINISTRATOR c: 
    CALL :QUEUEFORRUNASADMINISTRATOR cd /D %xamppinstllpath%\mysql
    CALL :QUEUEFORRUNASADMINISTRATOR CALL %xamppinstllpath%\mysql\mysql_installservice.bat
    CALL :QUEUEFORRUNASADMINISTRATOR cd /D !root!
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

:GREEN <msg>
  echo [92m %* [0m
exit /b

:FATAL <msg>
  echo [101;93m %~1 [0m  
exit /b

:ERROR <msg>
  echo [107;91m %~1 [0m  
exit /bz

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



