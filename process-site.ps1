# Process captured site files and create final structure

$capturedDir = ".\captured"
$outputDir = "."

Write-Host "Processing captured site files..." -ForegroundColor Cyan

# Read the captured HTML
$html = Get-Content -Path "$capturedDir\index.html" -Raw -Encoding UTF8

# Update CSS link to local file
$html = $html -replace 'href="https://[^"]*\.css[^"]*"', 'href="styles.css"'

# Update JavaScript links to local file
$html = $html -replace 'src="https://[^"]*\.js[^"]*"', 'src="scripts.js"'

# Create assets directory
$assetsDir = "assets"
if (!(Test-Path $assetsDir)) {
    New-Item -ItemType Directory -Path $assetsDir | Out-Null
}

# Save processed HTML
$html | Out-File -FilePath "index.html" -Encoding UTF8
Write-Host "Created index.html" -ForegroundColor Green

# Copy CSS
Copy-Item "$capturedDir\styles.css" -Destination "styles.css" -Force
Write-Host "Copied styles.css" -ForegroundColor Green

# Copy JavaScript
Copy-Item "$capturedDir\scripts.js" -Destination "scripts.js" -Force
Write-Host "Copied scripts.js" -ForegroundColor Green

# Create image download script
$imageUrls = Get-Content "$capturedDir\images.txt"
$uniqueImages = $imageUrls | Select-Object -Unique

$downloadScript = @"
# Download images script
`$images = @(
"@

foreach ($img in $uniqueImages) {
    $downloadScript += "`"$img`",`n"
}

$downloadScript += @"
)

`$assetsDir = "assets"
if (!(Test-Path `$assetsDir)) {
    New-Item -ItemType Directory -Path `$assetsDir | Out-Null
}

foreach (`$imgUrl in `$images) {
    try {
        `$fileName = Split-Path `$imgUrl -Leaf
        `$filePath = Join-Path `$assetsDir `$fileName
        Write-Host "Downloading: `$fileName" -ForegroundColor Gray
        Invoke-WebRequest -Uri `$imgUrl -OutFile `$filePath -UseBasicParsing -ErrorAction SilentlyContinue
    } catch {
        Write-Host "Could not download: `$imgUrl" -ForegroundColor Yellow
    }
}

Write-Host "Image download complete!" -ForegroundColor Green
"@

$downloadScript | Out-File -FilePath "download-images.ps1" -Encoding UTF8
Write-Host "Created download-images.ps1" -ForegroundColor Green

Write-Host "`nProcessing complete!" -ForegroundColor Green
Write-Host "Next: Run .\download-images.ps1 to download all images" -ForegroundColor Yellow


