# DEV Task Board Startup Script
Write-Host "Starting DEV Task Board..." -ForegroundColor Cyan

Set-Location $PSScriptRoot

# Check for dependencies
$missing = @()
foreach ($pkg in @('fastapi', 'uvicorn')) {
    $check = pip show $pkg 2>$null
    if (-not $check) { $missing += $pkg }
}

if ($missing.Count -gt 0) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    pip install -r requirements.txt -q
}

Write-Host ""
Write-Host "Task Board running at: http://localhost:3000" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop" -ForegroundColor Gray
Write-Host ""

python -m uvicorn app:app --host 0.0.0.0 --port 3000 --reload
