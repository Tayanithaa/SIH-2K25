@echo off
echo ============================================================
echo  MongoDB Status Check and Control
echo ============================================================
echo.

echo Checking MongoDB service status...
sc query MongoDB >nul 2>&1

if %errorlevel% equ 0 (
    echo MongoDB service found!
    echo.
    sc query MongoDB
    echo.
    echo ============================================================
    echo Options:
    echo 1. Start MongoDB    - net start MongoDB
    echo 2. Stop MongoDB     - net stop MongoDB
    echo 3. Restart MongoDB  - net stop MongoDB ^&^& net start MongoDB
    echo ============================================================
    echo.
    set /p choice="Enter your choice (1/2/3) or press Enter to skip: "
    
    if "%choice%"=="1" (
        echo Starting MongoDB...
        net start MongoDB
    )
    if "%choice%"=="2" (
        echo Stopping MongoDB...
        net stop MongoDB
    )
    if "%choice%"=="3" (
        echo Restarting MongoDB...
        net stop MongoDB
        timeout /t 2 /nobreak >nul
        net start MongoDB
    )
) else (
    echo.
    echo [ERROR] MongoDB service not found!
    echo.
    echo Please install MongoDB:
    echo 1. Download from: https://www.mongodb.com/try/download/community
    echo 2. Choose "Complete" installation
    echo 3. Check "Install MongoDB as a Service"
    echo 4. Complete the installation
    echo.
    echo Or use MongoDB Atlas (cloud):
    echo - Create free account at https://www.mongodb.com/cloud/atlas
    echo - Update MONGODB_URI in .env file with your connection string
)

echo.
echo ============================================================
pause
