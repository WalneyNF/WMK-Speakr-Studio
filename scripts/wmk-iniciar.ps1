$ErrorActionPreference='Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path '.venv\Scripts\python.exe')) { throw 'Execute Instalar-WMK.cmd primeiro.' }
& .\.venv\Scripts\python.exe wmk_windows.py
if ($LASTEXITCODE -ne 0) { throw 'Falha ao iniciar WMK Speakr Studio' }
