param(
  # Optional: path to your repo; defaults to current directory
  [string]$RepoPath = "."
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Ensure git is available
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not installed or not on PATH."
}

# Normalize and enter the repo
$repoFull = Resolve-Path $RepoPath
Push-Location $repoFull

try {
    # Try to locate readme.md (case-insensitive). Prefer root; fall back to first found anywhere.
    $readme = Get-ChildItem -Path . -Filter "readme.md" -File -ErrorAction SilentlyContinue
    if (-not $readme) {
        $readme = Get-ChildItem -Path . -Recurse -File -ErrorAction SilentlyContinue |
                  Where-Object { $_.Name -match '^readme\.md$' } |
                  Select-Object -First 1
    }

    # Get short SHA of the latest commit that touched readme.md; if not found, fallback to HEAD
    $shortSha = $null
    if ($readme) {
        $shortSha = (git log -n 1 --pretty=format:%h -- "$($readme.FullName)" 2>$null)
    }
    if ([string]::IsNullOrWhiteSpace($shortSha)) {
        # Fallback: just use current HEAD
        $shortSha = (git rev-parse --short HEAD).Trim()
    }

    if ([string]::IsNullOrWhiteSpace($shortSha)) {
        throw "Unable to determine a commit SHA."
    }

    $zipName = "codelantern-ai-$shortSha.zip"
    # Ensure output folder exists: _ai_packages
    $outDir = Join-Path -Path (Get-Location) -ChildPath "_ai_packages"
    if (-not (Test-Path $outDir)) {
        New-Item -Path $outDir -ItemType Directory | Out-Null
    }
    $zipPath = Join-Path -Path $outDir -ChildPath $zipName

    # Remove any existing zip with the same name
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }

    # Collect all files except those under .git, _ai_packages, and the zip file itself
    $filesToZip =
        Get-ChildItem -Path . -Recurse -File -Force |
        Where-Object {
            $_.FullName -notmatch '\\.git(\\|$)' -and
            $_.FullName -notmatch '\\_ai_packages(\\|$)' -and
            $_.FullName -ne $zipPath
        }

    if (-not $filesToZip) {
        throw "No files found to archive."
    }

    # Create the archive
    Compress-Archive -Path $filesToZip -DestinationPath $zipPath

    Write-Host "Created archive: $zipPath"
}
finally {
    Pop-Location
}

