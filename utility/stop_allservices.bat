@echo off
setlocal EnableDelayedExpansion
set current_path=!CD!
echo !current_path!
for %%N in (8080 3001 3000) do  (
     echo %%N
     for /f "tokens=5" %%a in ('netstat -aon ^| findstr %%N') do (
      echo %%~nxa
     taskkill /pid %%~nxa /f
     ) 


)


