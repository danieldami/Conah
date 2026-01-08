# Update HTML to use local image paths

$html = Get-Content -Path "index.html" -Raw -Encoding UTF8
$images = Get-Content "captured\images.txt" | Select-Object -Unique

foreach ($imgUrl in $images) {
    if ($imgUrl -and $imgUrl.Trim()) {
        $fileName = Split-Path $imgUrl -Leaf
        $fileName = $fileName.Split('?')[0]
        $localPath = "assets/$fileName"
        
        # Replace all occurrences of the full URL with local path
        $html = $html -replace [regex]::Escape($imgUrl), $localPath
        
        # Also handle URL-encoded versions
        $encodedUrl = $imgUrl -replace '%20', ' '
        if ($encodedUrl -ne $imgUrl) {
            $html = $html -replace [regex]::Escape($encodedUrl), $localPath
        }
    }
}

$html | Out-File -FilePath "index.html" -Encoding UTF8
Write-Host "Updated HTML with local image paths!" -ForegroundColor Green


