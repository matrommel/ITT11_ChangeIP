@echo off
:: Überprüfen, ob das Skript mit Administratorrechten ausgeführt wird.
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Starte das Skript mit administrativen Rechten...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Führe das PowerShell-Skript mit umgangener Ausführungsrichtlinie aus.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0configure_ip_for_ITT11.ps1"

pause