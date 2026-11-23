param(
  [switch]$SkipDependencies,
  [switch]$SkipAssets
)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
Write-Host 'WMK Speakr Studio - preparacao Windows' -ForegroundColor Cyan
if (-not (Test-Path '.venv\Scripts\python.exe')) {
    py -3.11 -m venv .venv
    if ($LASTEXITCODE -ne 0) { throw 'Python 3.11 x64 nao encontrado. Instale o Python 3.11.' }
}
$python = '.\.venv\Scripts\python.exe'
if (-not $SkipDependencies) {
    & $python -m pip install --upgrade pip
    if ($LASTEXITCODE -ne 0) { throw 'Falha na atualizacao do pip' }
    & $python scripts/windows_deps.py
    if ($LASTEXITCODE -ne 0) { throw 'Falha ao instalar dependencias Python' }
}
if (-not $SkipAssets) {
    & $python scripts/download_offline_deps.py
    if ($LASTEXITCODE -ne 0) { throw 'Falha nos arquivos vendor' }
    if (-not (Get-Command npx.cmd -ErrorAction SilentlyContinue)) { throw 'Node.js/npm nao encontrado. Instale Node.js LTS' }
    & npx.cmd --yes --package=tailwindcss@3.4.19 tailwindcss -c tailwind.config.js -i static/css/tailwind.input.css -o static/css/tailwind.css --minify
    if ($LASTEXITCODE -ne 0) { throw 'Falha ao compilar Tailwind' }
}
& $python wmk_windows.py --check
if ($LASTEXITCODE -ne 0) { throw 'Falha no diagnostico inicial' }
Write-Host 'Tudo pronto! Execute: .\Iniciar-WMK.cmd' -ForegroundColor Green
