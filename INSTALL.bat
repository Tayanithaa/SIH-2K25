@echo off
setlocal enabledelayedexpansion

color 0A
echo.
echo  ====================================================================
echo   Patient Contact Tracing System - Complete Setup Script
echo   SIH 2025 Grand Finale Project
echo  ====================================================================
echo.

:: Change to script directory
cd /d "%~dp0"

echo [Step 1/5] Checking Prerequisites...
echo.

:: Check Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed!
    echo Please install Python 3.10+ from https://www.python.org/
    echo.
    pause
    exit /b 1
)
echo [OK] Python found: 
python --version
echo.

:: Check Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed!
    echo Please install Node.js 18+ from https://nodejs.org/
    echo.
    pause
    exit /b 1
)
echo [OK] Node.js found:
node --version
echo.

:: Check MongoDB
echo [INFO] Checking MongoDB...
sc query MongoDB >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] MongoDB service not found!
    echo.
    echo MongoDB is REQUIRED for this system to work.
    echo.
    echo Please choose an option:
    echo   1. Install MongoDB locally (Recommended)
    echo      Download: https://www.mongodb.com/try/download/community
    echo.
    echo   2. Use MongoDB Atlas (Cloud - Free tier available)
    echo      Sign up: https://www.mongodb.com/cloud/atlas
    echo      Then update MONGODB_URI in .env file
    echo.
    set /p continue="Would you like to continue without MongoDB? (y/n): "
    if /i not "!continue!"=="y" (
        echo.
        echo Setup cancelled. Please install MongoDB first.
        pause
        exit /b 1
    )
) else (
    echo [OK] MongoDB service found
    sc query MongoDB | findstr "STATE"
)
echo.

echo.
echo [Step 2/5] Checking Python Dependencies...
echo.

:: Check if pip is available
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] pip is not installed!
    echo pip should come with Python. Please reinstall Python.
    pause
    exit /b 1
)

:: Check if requirements are already installed
python -c "import fastapi" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Python dependencies appear to be installed
    echo     (FastAPI found - assuming others are present)
) else (
    echo [INFO] Installing Python dependencies...
    echo       This may take 5-10 minutes...
    pip install -r requirements.txt
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install Python dependencies
        pause
        exit /b 1
    )
)
echo.

echo.
echo [Step 3/5] Setting up Frontend...
echo.

cd frontend

if exist "node_modules\" (
    echo [OK] Frontend dependencies already installed
) else (
    echo [INFO] Installing frontend dependencies...
    echo       This may take 2-3 minutes...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install frontend dependencies
        cd ..
        pause
        exit /b 1
    )
    echo [OK] Frontend dependencies installed successfully
)

cd ..
echo.

echo.
echo [Step 4/5] Verifying Configuration Files...
echo.

if exist ".env" (
    echo [OK] .env configuration file exists
) else (
    echo [WARNING] .env file not found
    echo Please check if it was created properly
)

if exist "src\yolov8n.pt" (
    echo [OK] YOLO model file exists
) else (
    echo [INFO] YOLO model file not found
    echo      It will be downloaded automatically on first run
)

echo.
echo.
echo [Step 5/5] Final System Check...
echo.

:: Test MongoDB connection if service exists
sc query MongoDB >nul 2>&1
if %errorlevel% equ 0 (
    sc query MongoDB | findstr "RUNNING" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] MongoDB is running
    ) else (
        echo [WARNING] MongoDB is installed but not running
        echo.
        set /p start_mongo="Would you like to start MongoDB now? (y/n): "
        if /i "!start_mongo!"=="y" (
            net start MongoDB
            if %errorlevel% equ 0 (
                echo [OK] MongoDB started successfully
            ) else (
                echo [ERROR] Failed to start MongoDB
                echo You may need to run this script as Administrator
            )
        )
    )
)

echo.
echo  ====================================================================
echo   Setup Complete!
echo  ====================================================================
echo.
echo   Your system is ready to run. Follow these steps:
echo.
echo   1. Start Backend Server:
echo      - Double-click: start_backend.bat
echo      - Or run: python start_server.py
echo      - Wait for "Application startup complete" message
echo.
echo   2. Start Frontend Server (in a NEW terminal):
echo      - Double-click: start_frontend.bat
echo      - Or run: cd frontend ^&^& npm run dev
echo      - Wait for "Local: http://localhost:5173" message
echo.
echo   3. Open your browser:
echo      - Go to: http://localhost:5173
echo      - Login: admin / admin123
echo      - Change password after first login!
echo.
echo   Quick Access Files:
echo   - check_requirements.bat  - Verify system status
echo   - mongodb_control.bat     - Control MongoDB service
echo   - QUICKSTART.md           - Quick reference guide
echo   - SETUP_GUIDE.md          - Detailed documentation
echo.
echo   API Documentation:
echo   - http://localhost:8000/docs  (after backend starts)
echo.
echo  ====================================================================
echo.

:: Ask if user wants to start servers now
set /p start_now="Would you like to start the backend server now? (y/n): "
if /i "!start_now!"=="y" (
    echo.
    echo Starting backend server...
    echo Open a NEW terminal and run: start_frontend.bat
    echo.
    pause
    python start_server.py
) else (
    echo.
    echo You can start the servers manually using the batch files.
    echo See the instructions above.
    echo.
    pause
)

endlocal
