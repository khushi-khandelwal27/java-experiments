@echo off
echo ===================================================
echo   ShopSphere - Database Setup Script
echo ===================================================

set MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe
if not exist "%MYSQL_BIN%" (
    set MYSQL_BIN=mysql
)

echo Executing shopsphere.sql on MySQL Server...
if "%DB_PASSWORD%"=="" set /p DB_PASSWORD="Enter MySQL root password: "
"%MYSQL_BIN%" -u root -p%DB_PASSWORD% < "%~dp0..\database\shopsphere.sql"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [SUCCESS] Database 'shopsphere' created and populated with seed data!
) else (
    echo.
    echo [ERROR] Failed to execute SQL script. Please check your MySQL service and credentials.
)
pause
