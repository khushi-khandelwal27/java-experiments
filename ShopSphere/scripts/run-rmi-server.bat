@echo off
echo ===================================================
echo   ShopSphere - Launch Java RMI Registry Server
echo ===================================================

set MYSQL_JAR=D:\CODE\mysql-connector-j-26.7.0\mysql-connector-j-26.7.0.jar
set RMI_JAR=%~dp0..\rmi\target\shopsphere-rmi-1.0.0.jar

if not exist "%RMI_JAR%" (
    echo [INFO] Building rmi jar...
    call mvn package -pl rmi -f "%~dp0..\pom.xml"
)

echo Starting RMI Registry and Publishing Service on port 1099...
java -cp "%RMI_JAR%;%MYSQL_JAR%" com.shopsphere.rmi.server.InventoryRmiServer
pause
