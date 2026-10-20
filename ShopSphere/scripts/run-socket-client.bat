@echo off
echo ===================================================
echo   ShopSphere - Launch java.net TCP Inventory Client
echo ===================================================

set NET_JAR=%~dp0..\network\target\shopsphere-network-1.0.0.jar

if not exist "%NET_JAR%" (
    echo [INFO] Building network jar...
    call mvn package -pl network -f "%~dp0..\pom.xml"
)

echo Connecting to TCP Inventory Server (localhost:5050)...
java -cp "%NET_JAR%" com.shopsphere.network.client.InventoryClient
pause
