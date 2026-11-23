@echo off
setlocal
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
 echo Execute Instalar-WMK.cmd primeiro.
 pause
 exit /b 1
)
".venv\Scripts\python.exe" wmk_windows.py --admin
pause
