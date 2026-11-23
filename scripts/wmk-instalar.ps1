# WMK Speakr Studio — preparar Windows sem Docker
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
Write-Host 'WMK Speakr Studio | Instalacao nativa Windows' -ForegroundColor Cyan
py -3.11 --version
if ($LASTEXITCODE -ne 0) { throw 'Instale Python 3.11 (64-bit) e habilite py launcher.' }
if (-not (Test-Path '.venv\Scripts\python.exe')) { py -3.11 -m venv .venv; if ($LASTEXITCODE -ne 0) { throw 'Falha ao criar venv' } }
$python = Join-Path (Get-Location) '.venv\Scripts\python.exe'
& $python -m pip install --upgrade pip
if ($LASTEXITCODE -ne 0) { throw 'Falha no pip upgrade' }
& $python -m pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) { throw 'Falha nas dependencias' }
& $python scripts/download_offline_deps.py
if ($LASTEXITCODE -ne 0) { throw 'Falha em assets offline' }
if (-not (Get-Command npx.cmd -ErrorAction SilentlyContinue)) { throw 'Node.js/npm necessarios para compilar Tailwind CSS. Instale Node.js LTS.' }
npx.cmd --yes --package=tailwindcss@3.4.19 tailwindcss -c tailwind.config.js -i static/css/tailwind.input.css -o static/css/tailwind.css --minify
if ($LASTEXITCODE -ne 0) { throw 'Falha no Tailwind CSS' }
New-Item -ItemType Directory -Force -Path instance,uploads | Out-Null
if (-not (Test-Path '.env')) {
  $instance = (Join-Path (Get-Location) 'instance').Replace('\','/')
  $uploads = (Join-Path (Get-Location) 'uploads').Replace('\','/')
  $db = 'sqlite:///' + $instance + '/transcriptions.db'
  $data = @(
    'SQLALCHEMY_DATABASE_URI=' + $db
    'UPLOAD_FOLDER=' + $uploads
    'ALLOW_REGISTRATION=false'
    'DEFAULT_UI_LANGUAGE=pt-BR'
    'DEFAULT_OUTPUT_LANGUAGE=pt-BR'
    'ENABLE_INQUIRE_MODE=false'
    'LOG_LEVEL=INFO'
    '# Configure depois TEXT_MODEL_BASE_URL, TEXT_MODEL_NAME e ASR.'
  )
  [System.IO.File]::WriteAllLines((Join-Path (Get-Location) '.env'),[string[]]$data,(New-Object System.Text.UTF8Encoding($false)))
}
& $python -c "from src.app import app, db; app.app_context().push(); db.create_all(); print('Banco SQLite pronto')"
if ($LASTEXITCODE -ne 0) { throw 'Falha na inicializacao do banco. Verifique o .env.' }
Write-Host 'Ambiente preparado. Execute .\scripts\wmk-criar-admin.ps1 e depois .\scripts\wmk-iniciar.ps1' -ForegroundColor Green
