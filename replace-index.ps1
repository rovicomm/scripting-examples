$sourceDir = "D:\databasePlayer\medias\medias"
$replacementFile = "c:\temp\index.html"
$logFile = "c:\logs\replace-index.log"

Start-Transcript -Path $logFile -Append

# Check if the replacement file exists
if (-not (Test-Path $replacementFile)) {
    Write-Error "Replacement file not found: $replacementFile"
    exit 1
}

# Get all index.html files in the source directory and its subdirectories
$emptyFiles = Get-ChildItem -Path $sourceDir -Recurse -Filter "index.html" | Where-Object { $_.Length -eq 0 }

foreach ($file in $emptyFiles) {
    try {
        Copy-Item -Path $replacementFile -Destination $file.FullName -Force
        Write-Host "Replaced empty file: $($file.FullName)"
    } catch {
        Write-Error "Failed to replace file: $($file.FullName). Error: $_"
    }
}

Write-Host "Script completed. Replaced $($emptyFiles.Count) empty index.html files."

Stop-Transcript