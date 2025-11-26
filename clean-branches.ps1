git checkout main
git fetch --prune
git pull
git branch --merged | ForEach-Object {
    if ($_ -notmatch "^\*") {
        git branch -d ($_ -replace "^\s+", "")
    }
}