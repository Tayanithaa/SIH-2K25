@echo off
echo ============================================================
echo  Starting Frontend Development Server (React + Vite)
echo ============================================================
echo.
echo Frontend will be available at: http://localhost:5173
echo.
echo Press Ctrl+C to stop the server
echo ============================================================
echo.

cd /d "%~dp0\frontend"

echo Checking if node_modules exists...
if not exist "node_modules\" (
    echo node_modules not found. Installing dependencies...
    echo This may take a few minutes on first run...
    call npm install
    echo.
)

echo Starting development server...
call npm run dev

pause
