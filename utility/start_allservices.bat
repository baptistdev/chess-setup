@echo off
setlocal EnableDelayedExpansion
 CALL config.bat
  echo "Instance type detected : " !instancetype!
  set NODE_ENV=!instancetype!
  echo "Environment set : " %NODE_ENV%
  echo "Press enter to continue >>>>>>>"
  pause 
  cd  server
  start /w cmd /b /c node start-server  