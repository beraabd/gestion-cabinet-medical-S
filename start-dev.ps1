# MediCAB All-in-One Developer Startup Script (PowerShell)
# This script starts the backend and frontend for local development.

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Starting MediCAB Development Stack   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$BackendDir = Join-Path $ScriptDir "MediCAB\MediCaB-backend"
$FrontendDir = Join-Path $ScriptDir "MediCAB\MediCaB-frontend"

# Check Python
$PythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $PythonCmd) {
    $PythonCmd = Get-Command py -ErrorAction SilentlyContinue
}

if ($PythonCmd) {
    Write-Host "[1/3] Setting up Backend..." -ForegroundColor Green
    Push-Location $BackendDir
    if (-not (Test-Path ".venv")) {
        Write-Host "Creating virtual environment..."
        & $PythonCmd.Source -m venv .venv
    }
    
    $VenvPython = if (Test-Path ".venv\Scripts\python.exe") { ".venv\Scripts\python.exe" } else { "python" }
    & $VenvPython -m pip install --upgrade pip --quiet
    & $VenvPython -m pip install Django djangorestframework django-cors-headers --quiet
    
    Write-Host "Running database migrations (SQLite dev mode)..."
    & $VenvPython manage.py migrate --noinput
    
    Write-Host "Starting Django API on http://127.0.0.1:8000/api/..." -ForegroundColor Yellow
    $backendProcess = Start-Process -FilePath $VenvPython -ArgumentList "manage.py", "runserver", "127.0.0.1:8000" -PassThru
    Pop-Location
} else {
    Write-Host "[!] Python is not installed. Backend could not start." -ForegroundColor Red
}

# Frontend
Write-Host "[2/3] Starting Frontend..." -ForegroundColor Green
$FrontendDist = Join-Path $FrontendDir "dist\medicab\browser"
if (Test-Path $FrontendDist) {
    Write-Host "Serving pre-built Angular app on http://localhost:4200..." -ForegroundColor Yellow
    # Start web server
    $serveScript = Join-Path $env:TEMP "medicab-serve.ps1"
    @'
    param([string]$Root, [int]$Port = 4200)
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://localhost:$Port/")
    $listener.Start()
    Write-Host "Server listening at http://localhost:$Port/"
    while ($listener.IsListening) {
        $ctx = $listener.GetContext()
        $req = $ctx.Request
        $res = $ctx.Response
        $p = $req.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrEmpty($p)) { $p = "index.html" }
        $fp = Join-Path $Root $p
        if (-not (Test-Path $fp -PathType Leaf)) { $fp = Join-Path $Root "index.html" }
        $ext = [System.IO.Path]::GetExtension($fp).ToLower()
        $types = @{ ".html"="text/html; charset=utf-8"; ".js"="application/javascript"; ".css"="text/css"; ".png"="image/png" }
        $res.ContentType = if ($types.ContainsKey($ext)) { $types[$ext] } else { "application/octet-stream" }
        $bytes = [System.IO.File]::ReadAllBytes($fp)
        $res.ContentLength64 = $bytes.Length
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
        $res.Close()
    }
'@ | Out-File -FilePath $serveScript -Encoding utf8

    $frontendProcess = Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy", "Bypass", "-File", $serveScript, "-Root", "`"$FrontendDist`"", "-Port", "4200" -PassThru
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " MediCAB is running!" -ForegroundColor Cyan
Write-Host " Frontend: http://localhost:4200" -ForegroundColor Cyan
Write-Host " Backend:  http://127.0.0.1:8000/api/" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
