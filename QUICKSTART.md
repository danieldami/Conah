# 🚀 Quick Start Guide

## Method 1: PowerShell Script (Easiest for Windows)

1. **Open PowerShell** in this folder
2. **Run the script**:
   ```powershell
   .\capture-site.ps1
   ```
3. This will download the HTML, CSS, and JavaScript files to a `captured` folder

## Method 2: Browser Console Script (Most Complete)

1. **Open** `extract.html` in your browser
2. **Copy** the console script shown in the page
3. **Visit** `https://intiri-template.webflow.io` in a new tab
4. **Open Developer Tools** (F12)
5. **Go to Console** tab
6. **Paste** the script and press Enter
7. **Files will automatically download** to your Downloads folder

## Method 3: Manual Extraction

1. **Visit** `https://intiri-template.webflow.io`
2. **Right-click** → **Save Page As** → Save as `index.html`
3. **Open Developer Tools** (F12)
4. **Sources tab** → Find all CSS files → Copy and save as `styles.css`
5. **Network tab** → Filter by "Font" → Download all fonts
6. **Network tab** → Filter by "Img" → Download all images
7. **Styles panel** → Search for `@keyframes` → Copy animations

## After Extraction

1. **Organize files**:
   - `index.html` - Main HTML file
   - `styles.css` - All CSS styles
   - `scripts.js` - JavaScript (if any)
   - `assets/` - Create this folder for images and fonts

2. **Fix paths** in HTML:
   - Update image paths to point to `assets/` folder
   - Update font paths if needed
   - Ensure CSS and JS links are correct

3. **Test locally**:
   - Open `index.html` in a browser
   - Or use a local server (see below)

## Running a Local Server

### Option A: Python (if installed)
```bash
python -m http.server 8000
```
Then visit: `http://localhost:8000`

### Option B: Node.js (if installed)
```bash
npm start
```
Then visit: `http://localhost:3000`

### Option C: VS Code Live Server
- Install "Live Server" extension
- Right-click `index.html` → "Open with Live Server"

## Troubleshooting

- **CORS errors**: Use the browser console script method (Method 2)
- **Missing assets**: Check Network tab in DevTools and download manually
- **Broken links**: Update relative paths in HTML
- **Fonts not loading**: Download font files and update `@font-face` paths

## Next Steps

After capturing the site:
1. ✅ Clean up HTML structure
2. ✅ Organize CSS into sections
3. ✅ Optimize images
4. ✅ Test responsiveness
5. ✅ Verify animations work
6. ✅ Test in different browsers


