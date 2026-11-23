@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\wmk-compilar.ps1"
if errorlevel 1 (
 echo Compilacao falhou. Consulte o erro acima.
 pause
 exit /b 1
)
pause
