@echo off
echo ===================================================
echo   ShopSphere - Launch java.net TCP Inventory Server
echo ===================================================

set MYSQL_JAR=D:\CODE\mysql-connector-j-26.7.0\mysql-connector-j-26.7.0.jar
set NET_JAR=%~dp0..\network\target\shopsphere-network-1.0.0.jar

if not exist "%NET_JAR%" (
    echo [INFO] Building network jar...
    call mvn package -pl network -f "%~dp0..\pom.xml"
)

echo Starting TCP Inventory Server on port 5050...
java -cp "%NET_JAR%;%MYSQL_JAR%" com.shopsphere.network.server.InventoryServer
pause
