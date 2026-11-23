@echo off
setlocal
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
 echo Ambiente nao preparado. Execute Instalar-WMK.cmd primeiro.
 pause
 exit /b 1
)
".venv\Scripts\python.exe" wmk_windows.py
if errorlevel 1 (
 echo Falha ao iniciar. Veja a mensagem acima.
 pause
 exit /b 1
)
