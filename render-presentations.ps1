# render-presentations.ps1
# Renders all Quarto presentations to HTML using Reveal.js

param(
    [string]$PresentationFile = "",
    [switch]$Preview,
    [switch]$Help
)

function Show-Help {
    Write-Host @"
Render Presentations Script
============================

Usage:
    .\render-presentations.ps1                    # Render all presentations
    .\render-presentations.ps1 -PresentationFile example-presentation.qmd   # Render specific file
    .\render-presentations.ps1 -Preview           # Open preview server
    .\render-presentations.ps1 -Help              # Show this help

Prerequisites:
    - Quarto must be installed (https://quarto.org/docs/get-started/)
    - Run from repository root: d:\Code\CodeLantern\CodeLantern.AI

Output:
    Generated presentations will be in: artifacts/presentations/

Examples:
    # Render all presentations
    .\render-presentations.ps1

    # Render specific presentation
    .\render-presentations.ps1 -PresentationFile presentations\example-presentation.qmd

    # Live preview with hot reload
    .\render-presentations.ps1 -Preview

"@
}

if ($Help) {
    Show-Help
    exit 0
}

# Check if Quarto is installed
$quartoVersion = quarto --version 2>$null
if (-not $quartoVersion) {
    Write-Host "❌ Error: Quarto is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Quarto from: https://quarto.org/docs/get-started/" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Quarto version: $quartoVersion" -ForegroundColor Green

# Ensure we're in the right directory
$repoRoot = "d:\Code\CodeLantern\CodeLantern.AI"
if (-not (Test-Path $repoRoot)) {
    Write-Host "❌ Error: Repository root not found at $repoRoot" -ForegroundColor Red
    exit 1
}

Set-Location $repoRoot

# Ensure output directory exists
$outputDir = Join-Path $repoRoot "artifacts\presentations"
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
    Write-Host "✅ Created output directory: $outputDir" -ForegroundColor Green
}

# Change to presentations directory
$presentationsDir = Join-Path $repoRoot "presentations"
if (-not (Test-Path $presentationsDir)) {
    Write-Host "❌ Error: Presentations directory not found" -ForegroundColor Red
    exit 1
}

Set-Location $presentationsDir

if ($Preview) {
    # Open preview server
    Write-Host "🚀 Starting Quarto preview server..." -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
    
    if ($PresentationFile) {
        quarto preview $PresentationFile
    } else {
        quarto preview
    }
} else {
    # Render presentations
    if ($PresentationFile) {
        Write-Host "🔨 Rendering: $PresentationFile" -ForegroundColor Cyan
        quarto render $PresentationFile
        
        if ($LASTEXITCODE -eq 0) {
            $fileName = [System.IO.Path]::GetFileNameWithoutExtension($PresentationFile)
            $outputPath = Join-Path $outputDir "$fileName.html"
            Write-Host "✅ Successfully rendered: $outputPath" -ForegroundColor Green
        } else {
            Write-Host "❌ Error rendering presentation" -ForegroundColor Red
            exit $LASTEXITCODE
        }
    } else {
        Write-Host "🔨 Rendering all presentations..." -ForegroundColor Cyan
        quarto render
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Successfully rendered all presentations to: $outputDir" -ForegroundColor Green
            
            # List generated files
            $generatedFiles = Get-ChildItem -Path $outputDir -Filter "*.html"
            if ($generatedFiles.Count -gt 0) {
                Write-Host "`nGenerated presentations:" -ForegroundColor Cyan
                foreach ($file in $generatedFiles) {
                    Write-Host "  - $($file.Name)" -ForegroundColor White
                }
            }
        } else {
            Write-Host "❌ Error rendering presentations" -ForegroundColor Red
            exit $LASTEXITCODE
        }
    }
}

# Return to repo root
Set-Location $repoRoot

Write-Host "`n✨ Done!" -ForegroundColor Green
