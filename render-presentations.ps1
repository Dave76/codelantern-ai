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
    Generated presentations will be in: bin/presentations/

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

# Get current working directory (where script was invoked)
$currentDir = Get-Location

# Determine repo root (handle being called from repo root or subdirectory)
if (Test-Path "src\presentations") {
    $repoRoot = Get-Location
} elseif (Test-Path "..\src\presentations") {
    $repoRoot = Resolve-Path ".."
} else {
    Write-Host "❌ Error: Could not find src\presentations directory" -ForegroundColor Red
    Write-Host "Please run this script from the repository root" -ForegroundColor Yellow
    exit 1
}

Set-Location $repoRoot

# Ensure output directory exists
$outputDir = Join-Path $repoRoot "bin\presentations"
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
    Write-Host "✅ Created output directory: $outputDir" -ForegroundColor Green
}

# Normalize the presentation file path if provided
if ($PresentationFile) {
    # If path starts with .\src\presentations\ or src\presentations\, extract just the filename
    if ($PresentationFile -match '^\.?\\?src\\presentations\\(.+)$') {
        $PresentationFile = $matches[1]
    }
    # Also handle legacy presentations\ path
    if ($PresentationFile -match '^\.?\\?presentations\\(.+)$') {
        $PresentationFile = $matches[1]
    }
    # If it's an absolute path, convert to relative from presentations dir
    if ([System.IO.Path]::IsPathRooted($PresentationFile)) {
        $presentationsDir = Join-Path $repoRoot "src\presentations"
        if ($PresentationFile.StartsWith($presentationsDir)) {
            $PresentationFile = $PresentationFile.Substring($presentationsDir.Length).TrimStart('\', '/')
        }
    }
}

# Change to presentations directory
$presentationsDir = Join-Path $repoRoot "src\presentations"
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
