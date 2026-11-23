# MediCAB All-in-One Developer Startup Script (PowerShell)
# This script starts the backend and frontend for local development.

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Starting MediCAB Development Stack   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$BackendDir = Join-Path $ScriptDir "MediCAB\MediCaB-backend"
$FrontendDir = Join-Path $ScriptDir "MediCAB\MediCaB-frontend"

# Check Python & Venv
$VenvPython = Join-Path $BackendDir ".venv\Scripts\python.exe"
$HasVenv = Test-Path $VenvPython

if (-not $HasVenv) {
    $PythonCmd = Get-Command python -ErrorAction SilentlyContinue
    if (-not $PythonCmd) {
        $candidate = "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe"
        if (Test-Path $candidate) {
            $PythonCmd = [PSCustomObject]@{ Source = $candidate }
        } else {
            $PythonCmd = Get-Command py -ErrorAction SilentlyContinue
        }
    }
}

if ($HasVenv -or $PythonCmd) {
    Write-Host "[1/3] Setting up Backend..." -ForegroundColor Green
    Push-Location $BackendDir
    if (-not (Test-Path ".venv")) {
        Write-Host "Creating virtual environment..."
        & $PythonCmd.Source -m venv .venv
    }
    
    $VenvPython = if (Test-Path ".venv\Scripts\python.exe") { ".venv\Scripts\python.exe" } else { "python" }
    Write-Host "Running database migrations (SQLite dev mode)..."
    & $VenvPython manage.py migrate --noinput
    
    Write-Host "Starting Django API on http://127.0.0.1:8000/api/..." -ForegroundColor Yellow
    $backendProcess = Start-Process -FilePath $VenvPython -ArgumentList "manage.py", "runserver", "127.0.0.1:8000" -WindowStyle "Hidden" -PassThru
    Pop-Location
} else {
    Write-Host "[!] Python is not installed. Backend could not start." -ForegroundColor Red
}

# Frontend
Write-Host "[2/3] Starting Frontend..." -ForegroundColor Green
$FrontendDist = Join-Path $FrontendDir "dist\medicab\browser"
if (Test-Path $FrontendDist) {
    Write-Host "Serving pre-built Angular app on http://localhost:4200..." -ForegroundColor Yellow
    $serveScript = Join-Path $ScriptDir "scripts\serve-frontend.ps1"
    $frontendProcess = Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy", "Bypass", "-WindowStyle", "Hidden", "-File", "`"$serveScript`"", "-Root", "`"$FrontendDist`"", "-Port", "4200" -PassThru
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " MediCAB is running!" -ForegroundColor Cyan
Write-Host " Frontend: http://localhost:4200" -ForegroundColor Cyan
Write-Host " Backend:  http://127.0.0.1:8000/api/" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
