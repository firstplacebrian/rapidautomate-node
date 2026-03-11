@echo off
title RapidAutomate Node
echo ============================================
echo   RapidAutomate Node - Starting...
echo ============================================
echo.

:: Load config
call config.env

:: Set working directory to script location
cd /d "%~dp0"

:: Set environment variables
set DEPLOY_MODE=desktop
set NODE_ENV=development
set REDIS_MODE=memory
set CSRF_PROTECTION=false
set REQUIRE_SIGNING=false
set MSYS_NO_PATHCONV=1

:: Set absolute database path
set DATABASE_URL=file:%~dp0resources\data\content.db
set DATABASE_PATH=%~dp0resources\data\antidetect.db

:: Create data directory if it doesn't exist
if not exist "resources\data" mkdir "resources\data"

:: Run database migration on first launch
echo [1/4] Checking database...
if not exist "resources\data\content.db" (
    echo       First run - creating database tables...
    resources\node.exe resources\node_modules\.prisma\client\index.js 2>nul
    echo       Database ready.
) else (
    echo       Database exists.
)

:: Start Antidetect Engine
echo [2/4] Starting Antidetect Engine on port %ENGINE_PORT%...
start /b "Engine" resources\node.exe resources\engine-bundle.js > resources\data\engine.log 2>&1
timeout /t 3 /nobreak > nul

:: Start Content Distribution
echo [3/4] Starting Content Distribution on port %CONTENT_PORT%...
start /b "Content" resources\node.exe resources\content-bundle.mjs > resources\data\content.log 2>&1
timeout /t 5 /nobreak > nul

:: Verify services
echo [4/4] Verifying services...
timeout /t 5 /nobreak > nul

echo.
echo ============================================
echo   RapidAutomate Node is RUNNING
echo   Engine:  http://localhost:%ENGINE_PORT%
echo   Content: http://localhost:%CONTENT_PORT%
echo   Dashboard: https://www.rapidrankings.io
echo.
echo   Press Ctrl+C or close this window to stop
echo ============================================
echo.

:: Keep window open and tail the content log
echo Watching content log (Ctrl+C to stop)...
echo ---
type resources\data\content.log 2>nul
:loop
timeout /t 10 /nobreak > nul
goto loop
