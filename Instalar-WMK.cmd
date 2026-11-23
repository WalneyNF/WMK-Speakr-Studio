@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\wmk-instalar.ps1"
if errorlevel 1 (
 echo Erro na instalacao. Copie a ultima mensagem para diagnostico.
 pause
 exit /b 1
)
echo Instalacao finalizada.
pause
