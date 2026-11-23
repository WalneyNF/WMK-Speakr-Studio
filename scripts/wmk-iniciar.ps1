$ErrorActionPreference='Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path '.venv\Scripts\python.exe')) { throw 'Execute .\scripts\wmk-instalar.ps1 primeiro.' }
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) { Write-Warning 'FFmpeg nao encontrado no PATH. Transcricao/conversao de audio pode falhar.' }
Write-Host 'WMK Speakr Studio: http://localhost:8899' -ForegroundColor Cyan
& .\.venv\Scripts\python.exe -m flask --app src.app run --host 127.0.0.1 --port 8899
