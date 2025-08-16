@echo off
REM Flutter Template Setup Script for Windows

echo 🚀 Flutter Template Setup
echo =========================
echo.

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python is required but not installed.
    echo Please install Python and try again.
    echo Visit: https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Check if Flutter is available
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is required but not installed.
    echo Please install Flutter and try again.
    echo Visit: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

REM Run the Python setup script
python setup_new_project.py

echo.
echo 🎯 Setup script completed!
echo Check PROJECT_SETUP.md for your project configuration.
pause
