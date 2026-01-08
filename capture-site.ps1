# PowerShell script to capture Webflow site content
# Run this script in PowerShell: .\capture-site.ps1

$url = "https://intiri-template.webflow.io"
$outputDir = ".\captured"

Write-Host "Starting Webflow Site Capture..." -ForegroundColor Cyan
Write-Host "Target URL: $url" -ForegroundColor Yellow

# Create output directory
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
    Write-Host "Created output directory: $outputDir" -ForegroundColor Green
}

try {
    # Fetch the HTML
    Write-Host "Downloading HTML..." -ForegroundColor Cyan
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
    $html = $response.Content
    
    # Save HTML
    $htmlPath = Join-Path $outputDir "index.html"
    $html | Out-File -FilePath $htmlPath -Encoding UTF8
    Write-Host "Saved HTML to: $htmlPath" -ForegroundColor Green
    
    # Extract CSS links - using Select-String
    Write-Host "Extracting CSS links..." -ForegroundColor Cyan
    $cssLinks = $html | Select-String -Pattern 'href=["'']([^"'']*\.css[^"'']*)["'']' -AllMatches | 
        ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value }
    
    $cssContent = ""
    foreach ($cssLink in $cssLinks) {
        try {
            if ($cssLink -like "//*") {
                $cssLink = "https:" + $cssLink
            } elseif ($cssLink -like "/*") {
                $cssLink = "https://intiri-template.webflow.io" + $cssLink
            } elseif ($cssLink -notlike "http*") {
                $cssLink = "https://intiri-template.webflow.io/" + $cssLink
            }
            
            Write-Host "  Downloading CSS: $cssLink" -ForegroundColor Gray
            $cssResponse = Invoke-WebRequest -Uri $cssLink -UseBasicParsing -ErrorAction SilentlyContinue
            $cssContent += "`n`n/* === $cssLink === */`n`n" + $cssResponse.Content
        } catch {
            Write-Host "  Could not download: $cssLink" -ForegroundColor Yellow
        }
    }
    
    # Save CSS
    if ($cssContent) {
        $cssPath = Join-Path $outputDir "styles.css"
        $cssContent | Out-File -FilePath $cssPath -Encoding UTF8
        Write-Host "Saved CSS to: $cssPath" -ForegroundColor Green
    }
    
    # Extract JavaScript links
    Write-Host "Extracting JavaScript links..." -ForegroundColor Cyan
    $jsLinks = $html | Select-String -Pattern 'src=["'']([^"'']*\.js[^"'']*)["'']' -AllMatches | 
        ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value }
    
    $jsContent = ""
    foreach ($jsLink in $jsLinks) {
        try {
            if ($jsLink -like "//*") {
                $jsLink = "https:" + $jsLink
            } elseif ($jsLink -like "/*") {
                $jsLink = "https://intiri-template.webflow.io" + $jsLink
            } elseif ($jsLink -notlike "http*") {
                $jsLink = "https://intiri-template.webflow.io/" + $jsLink
            }
            
            Write-Host "  Downloading JS: $jsLink" -ForegroundColor Gray
            $jsResponse = Invoke-WebRequest -Uri $jsLink -UseBasicParsing -ErrorAction SilentlyContinue
            $jsContent += "`n`n/* === $jsLink === */`n`n" + $jsResponse.Content
        } catch {
            Write-Host "  Could not download: $jsLink" -ForegroundColor Yellow
        }
    }
    
    # Save JavaScript
    if ($jsContent) {
        $jsPath = Join-Path $outputDir "scripts.js"
        $jsContent | Out-File -FilePath $jsPath -Encoding UTF8
        Write-Host "Saved JavaScript to: $jsPath" -ForegroundColor Green
    }
    
    # Extract image sources
    Write-Host "Extracting image sources..." -ForegroundColor Cyan
    $imageLinks = $html | Select-String -Pattern 'src=["'']([^"'']*\.(jpg|jpeg|png|gif|svg|webp)[^"'']*)["'']' -AllMatches | 
        ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value }
    
    $imagesList = @()
    foreach ($imgLink in $imageLinks) {
        $imagesList += $imgLink
    }
    
    # Save image list
    $imagesPath = Join-Path $outputDir "images.txt"
    $imagesList | Out-File -FilePath $imagesPath -Encoding UTF8
    Write-Host "Found $($imagesList.Count) images. List saved to: $imagesPath" -ForegroundColor Green
    
    Write-Host "`nCapture complete!" -ForegroundColor Green
    Write-Host "Files saved in: $outputDir" -ForegroundColor Cyan
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "1. Review the captured files" -ForegroundColor White
    Write-Host "2. Use extract.html for more detailed extraction" -ForegroundColor White
    Write-Host "3. Organize assets and optimize the code" -ForegroundColor White
    
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "`nAlternative: Open extract.html in your browser and follow the instructions" -ForegroundColor Yellow
}
