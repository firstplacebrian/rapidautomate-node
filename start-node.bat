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
    resources\node.exe resources\node_modules\.prisma\client\index.js 2>/dev/null
    echo       Database ready.
) else (
    echo       Database exists.
)

:: Start Antidetect Engine
echo [2/4] Starting engine on port %ENGINE_PORT%...
start /b "Engine" resources\node.exe resources\engine-bundle.js > resources\data\engine.log 2>&1
timeout /t 3 /nobreak > /dev/null

:: Start Content Distribution
echo [3/4] Starting services on port %CONTENT_PORT%...
start /b "Content" resources\node.exe resources\content-bundle.mjs > resources\data\content.log 2>&1
timeout /t 5 /nobreak > /dev/null

:: Open dashboard in browser
echo [4/4] Opening dashboard...
timeout /t 3 /nobreak > /dev/null
start "" "http://localhost:%CONTENT_PORT%"

echo.
echo ============================================
echo   Node is RUNNING
echo   Dashboard: http://localhost:%CONTENT_PORT%
echo   Engine:    http://localhost:%ENGINE_PORT%
echo.
echo   Press Ctrl+C or close this window to stop
echo ============================================
echo.

:loop
timeout /t 10 /nobreak > /dev/null
goto loop
