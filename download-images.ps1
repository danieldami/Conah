# Download images script
$images = Get-Content "captured\images.txt" | Select-Object -Unique

$assetsDir = "assets"
if (!(Test-Path $assetsDir)) {
    New-Item -ItemType Directory -Path $assetsDir | Out-Null
}

$count = 0
foreach ($imgUrl in $images) {
    if ($imgUrl -and $imgUrl.Trim()) {
        try {
            $fileName = Split-Path $imgUrl -Leaf
            # Clean filename (remove query parameters)
            $fileName = $fileName.Split('?')[0]
            $filePath = Join-Path $assetsDir $fileName
            Write-Host "Downloading ($count/$($images.Count)): $fileName" -ForegroundColor Gray
            Invoke-WebRequest -Uri $imgUrl -OutFile $filePath -UseBasicParsing -ErrorAction SilentlyContinue
            $count++
        } catch {
            Write-Host "Could not download: $imgUrl" -ForegroundColor Yellow
        }
    }
}

Write-Host "`nImage download complete! Downloaded $count images." -ForegroundColor Green
