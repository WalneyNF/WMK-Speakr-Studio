param([switch]$NoSmokeTest)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
$python = '.\.venv\Scripts\python.exe'
if (-not (Test-Path $python)) { throw 'Instale primeiro com Instalar-WMK.cmd' }
if (-not (Test-Path 'static\css\tailwind.css')) { throw 'Recursos web ausentes. Reexecute Instalar-WMK.cmd.' }
& $python -m pip install 'pyinstaller>=6.11,<7'
if ($LASTEXITCODE -ne 0) { throw 'Falha ao instalar PyInstaller' }
& $python -m PyInstaller --noconfirm --clean --onedir --console --name WMK-Speakr-Studio --collect-submodules src --collect-submodules scripts --collect-all babel --collect-all flask --add-data 'templates;templates' --add-data 'static;static' --add-data 'VERSION;.' wmk_windows.py
if ($LASTEXITCODE -ne 0) { throw 'Falha ao compilar EXE' }
$folder='dist\WMK-Speakr-Studio'
Copy-Item LICENSE "$folder\LICENSE" -Force
Copy-Item docs\WMK-WINDOWS-ACTIONS.md "$folder\LEIA-ME-WINDOWS.md" -Force
$base='@echo off'+[Environment]::NewLine+'cd /d "%~dp0"'+[Environment]::NewLine
Set-Content -Encoding Ascii "$folder\Iniciar-WMK.cmd" ($base+'"WMK-Speakr-Studio.exe"'+[Environment]::NewLine+'if errorlevel 1 pause')
Set-Content -Encoding Ascii "$folder\Criar-Admin.cmd" ($base+'"WMK-Speakr-Studio.exe" --admin'+[Environment]::NewLine+'pause')
Set-Content -Encoding Ascii "$folder\Diagnostico.cmd" ($base+'"WMK-Speakr-Studio.exe" --check'+[Environment]::NewLine+'pause')
if (-not $NoSmokeTest) {
  & "$folder\WMK-Speakr-Studio.exe" --check
  if ($LASTEXITCODE -ne 0) { throw 'EXE compilado nao passou no diagnostico' }
}
Compress-Archive -Path $folder -DestinationPath 'dist\WMK-Speakr-Studio-Windows-x64.zip' -Force
Write-Host 'Pacote criado em dist\WMK-Speakr-Studio-Windows-x64.zip' -ForegroundColor Green
