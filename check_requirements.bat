@echo off
echo ============================================================
echo  Patient Contact Tracing System - Requirements Check
echo ============================================================
echo.

echo [1/6] Checking Python installation...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Python is installed
    python --version
) else (
    echo [ERROR] Python is NOT installed
    echo Please install Python 3.10 or higher from https://www.python.org/
)
echo.

echo [2/6] Checking Node.js installation...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Node.js is installed
    node --version
) else (
    echo [ERROR] Node.js is NOT installed
    echo Please install Node.js 18+ from https://nodejs.org/
)
echo.

echo [3/6] Checking npm installation...
npm --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] npm is installed
    npm --version
) else (
    echo [ERROR] npm is NOT installed
    echo npm should come with Node.js
)
echo.

echo [4/6] Checking MongoDB installation...
mongod --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] MongoDB is installed
    mongod --version | findstr "db version"
) else (
    echo [WARNING] MongoDB command not found
    echo This is normal if MongoDB is installed but not in PATH
    echo Checking MongoDB service status...
)
echo.

echo [5/6] Checking MongoDB service status...
sc query MongoDB >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] MongoDB service exists
    sc query MongoDB | findstr "STATE"
) else (
    echo [WARNING] MongoDB service not found
    echo Please install MongoDB from https://www.mongodb.com/try/download/community
    echo Or use MongoDB Atlas (cloud version)
)
echo.

echo [6/6] Checking project files...
if exist ".env" (
    echo [OK] .env configuration file exists
) else (
    echo [WARNING] .env file not found
    echo It should have been created automatically
)

if exist "src\yolov8n.pt" (
    echo [OK] YOLO model file exists
) else (
    echo [WARNING] YOLO model file not found at src\yolov8n.pt
    echo It will be downloaded on first run
)

if exist "venv\" (
    echo [OK] Python virtual environment exists
) else (
    echo [INFO] No virtual environment found
    echo You can create one with: python -m venv venv
)

if exist "frontend\node_modules\" (
    echo [OK] Frontend dependencies installed
) else (
    echo [WARNING] Frontend dependencies not installed
    echo Run: cd frontend && npm install
)
echo.

echo ============================================================
echo  Summary
echo ============================================================
echo.
echo Next steps:
echo 1. If MongoDB is not running, start it: net start MongoDB
echo 2. If frontend dependencies not installed: cd frontend ^&^& npm install
echo 3. Start backend: python start_server.py
echo 4. Start frontend (in new terminal): cd frontend ^&^& npm run dev
echo 5. Open http://localhost:5173 in browser
echo 6. Login with admin / admin123
echo.
echo See SETUP_GUIDE.md for detailed instructions
echo ============================================================
pause
