@echo off
echo Stopping RapidAutomate Node...
taskkill /F /IM node.exe 2>nul
echo.
echo All node processes stopped.
echo Log: %~dp0resources\data\content.log
pause
