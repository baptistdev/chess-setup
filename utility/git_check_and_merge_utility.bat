@echo off
setlocal EnableDelayedExpansion
  REM cd  ..
  CALL config.bat
  REM if not ""=="%1" (
  REM   set branch_name=%1
  REM ) else (
  REM   set branch_name=test
  REM )
  REM echo !branch_name!
  echo !instancetype!
  pause


  set current_path=!CD!
	ECHO %current_path%
  ECHO !current_path!
  
 


  (for %%a in (
    ember-masonry-grid
    bbhverse
    server
    qms
    ember-searchable-select
    loopback-component-jsonapi
    config
    loopback-connector-ds
  ) do (

    cd %%a
    echo %%a
    git rev-parse --abbrev-ref HEAD>!current_path!\git_branch.txt
    REM pause
    set /p git_current_branch=<!current_path!\git_branch.txt
    echo !git_current_branch!

    if not %%a == qms (
      if  !git_current_branch! == test (
        echo !git_current_branch! ">>>>>>>>>>>>>>>>>>>>>>"

        git checkout master
        git fetch 
        git pull
        git checkout !instancetype! --f
        git merge master

      ) else (
        git fetch 
        git pull
        git checkout !instancetype! --f
        git merge master
      )

    ) else (
      if  !git_current_branch! == test (
        echo !git_current_branch! ">>>>>>>>>>>>>>>>>>>>>>"

        git checkout genericMRwip
        git fetch 
        git pull
        git checkout !instancetype! --f
        git merge genericMRwip

      ) else (
        git fetch 
        git pull
        git checkout !instancetype! --f
        git merge genericMRwip
      )  
    ) 
    echo current_branch
    git rev-parse --abbrev-ref HEAD
    pause


    start /w cmd /b /c npm install
    echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>" 
    pause

    cd ..
  ))
  del "!current_path!\git_branch.txt"    

    REM pause
    REM if  !git_current_branch! == test (
    REM   echo !git_current_branch! ">>>>>>>>>>>>>>>>>>>>>>"
    REM   if %%a == qms (
    REM     git checkout genericMRwip
    REM     git fetch 
    REM     git checkout !instancetype! --f
    REM     git merge master

    REM   ) else (
    REM     git fetch 
    REM     git checkout !instancetype! --f
    REM     git merge master
    REM   )

    REM ) 
    REM else (
    REM   echo !git_current_branch! ">>>>>>>>>>>>>>"
    REM   REM If the specified branch is not there,List available branches,and ask user to verify,if required we can create it
    REM   if %%a == qms (
    REM     git checkout !instancetype!
    REM     git checkout genericMRwip --force
    REM     git pull  
    REM     git checkout !instancetype!
    REM     git merge genericMRwip
        
    REM   ) else (
    REM     git checkout !instancetype!
    REM     git checkout master --force
    REM     git pull  
    REM     git checkout !instancetype!
    REM     git merge master
    REM   )
    REM )
