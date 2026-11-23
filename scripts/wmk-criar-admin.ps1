$ErrorActionPreference='Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path '.venv\Scripts\python.exe')) { throw 'Execute .\scripts\wmk-instalar.ps1 primeiro.' }
& .\.venv\Scripts\python.exe scripts/create_admin.py
if ($LASTEXITCODE -ne 0) { throw 'Falha ao criar administrador' }
