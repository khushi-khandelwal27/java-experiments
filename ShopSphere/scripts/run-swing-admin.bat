@echo off
echo ===================================================
echo   ShopSphere - Launch Java Swing Desktop Admin
echo ===================================================

set MYSQL_JAR=D:\CODE\mysql-connector-j-26.7.0\mysql-connector-j-26.7.0.jar
set SWING_JAR=%~dp0..\swing-admin\target\shopsphere-swing-admin-1.0.0.jar

if not exist "%SWING_JAR%" (
    echo [INFO] Building swing-admin jar...
    call mvn package -pl swing-admin -f "%~dp0..\pom.xml"
)

echo Starting Swing Desktop Admin Client...
java -cp "%SWING_JAR%;%MYSQL_JAR%" com.shopsphere.swing.Main
pause
