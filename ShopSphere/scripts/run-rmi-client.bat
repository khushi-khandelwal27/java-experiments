@echo off
echo ===================================================
echo   ShopSphere - Launch Java RMI Client
echo ===================================================

set RMI_JAR=%~dp0..\rmi\target\shopsphere-rmi-1.0.0.jar

if not exist "%RMI_JAR%" (
    echo [INFO] Building rmi jar...
    call mvn package -pl rmi -f "%~dp0..\pom.xml"
)

echo Connecting to RMI Registry and Invoking Remote Service...
java -cp "%RMI_JAR%" com.shopsphere.rmi.client.InventoryRmiClient
pause
