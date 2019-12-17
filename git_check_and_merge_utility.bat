@echo off
setlocal EnableDelayedExpansion
  cd  ..
  if not ""=="%1" (
    set branch_name=%1
  ) else (
    set branch_name=test
  )
  echo !branch_name!
  pause


  set current_path=!CD!
	ECHO %current_path%
  ECHO !current_path!
  
 


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

    cd %%a
    echo %%a
    git rev-parse --abbrev-ref HEAD>!current_path!\git_branch.txt
    REM pause
    set /p git_current_branch=<!current_path!\git_branch.txt
    echo !git_current_branch!
  

    REM pause
    if  !git_current_branch! == test (
      echo !git_current_branch! ">>>>>>>>>>>>>>>>>>>>>>"
      if %%a == qms (
        git pull origin test
        git checkout genericMRwip 
        git pull origin genericMRwip 
        git checkout test
        git merge genericMRwip
        git push origin test

      ) else (
        git pull origin !branch_name!
        git checkout master
        git pull  
        git checkout !branch_name!
        git merge master
        git push origin !branch_name!
      )

    ) else (
      echo !git_current_branch! ">>>>>>>>>>>>>>"
      REM If the specified branch is not there,List available branches,and ask user to verify,if required we can create it
      if %%a == qms (
        git checkout !branch_name!
        git pull origin !branch_name!
        git checkout genericMRwip 
        git pull origin genericMRwip 
        git checkout !branch_name!
        git merge genericMRwip
        git push origin !branch_name!
        
      ) else (
        git checkout !branch_name!
        git pull origin !branch_name!
        git checkout master
        git pull  
        git checkout !branch_name!
        git merge master
        git push origin !branch_name!
      )
    )
    echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>" 
    pause

    cd ..
  ))
  del "!current_path!\git_branch.txt"