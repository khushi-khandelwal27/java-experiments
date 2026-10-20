@echo off
setlocal
title ShopSphere Launcher

echo ========================================================
echo       Starting ShopSphere Web Application
echo ========================================================

set "TOMCAT_HOME=D:\CODE\apache-tomcat-11.0.26"
set "PROJECT_DIR=%~dp0"
set "WAR_FILE=%PROJECT_DIR%web\target\shopsphere.war"

:: 1. Ensure WAR file is built
if not exist "%WAR_FILE%" (
    echo [INFO] Building ShopSphere war package...
    cd /d "%PROJECT_DIR%"
    call mvn clean package -DskipTests
)

:: 2. Deploy to Tomcat webapps
echo [INFO] Deploying shopsphere.war to %TOMCAT_HOME%\webapps...
copy /Y "%WAR_FILE%" "%TOMCAT_HOME%\webapps\shopsphere.war" >nul

:: 3. Launch Tomcat in dedicated window
echo [INFO] Launching Tomcat in dedicated window...
start "Apache Tomcat 11 - ShopSphere" cmd /k "set JAVA_HOME=D:\Applications\JAVA\jdk-24.0.1&& cd /d %TOMCAT_HOME%\bin&& catalina.bat run"

:: 4. Wait for deployment & open browser
echo [INFO] Waiting 6 seconds for Tomcat to initialize...
timeout /t 6 >nul

echo [INFO] Opening ShopSphere in your browser...
start http://localhost:8080/shopsphere/

echo.
echo ========================================================
echo ShopSphere is running!
echo URL: http://localhost:8080/shopsphere/
echo (Keep the Tomcat window open while using the website)
echo ========================================================
