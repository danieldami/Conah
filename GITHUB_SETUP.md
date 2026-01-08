# Setting Up GitHub Repository

Follow these steps to add your Conah website to GitHub:

## Prerequisites
1. Install Git from https://git-scm.com/download/win
2. Create a GitHub account at https://github.com (if you don't have one)

## Steps to Push to GitHub

### 1. Initialize Git Repository
Open PowerShell or Command Prompt in this folder and run:
```bash
git init
```

### 2. Add All Files
```bash
git add .
```

### 3. Create Initial Commit
```bash
git commit -m "Initial commit: Conah interior design website"
```

### 4. Create Repository on GitHub
1. Go to https://github.com/new
2. Name your repository (e.g., "conah-website" or "conah-interior-design")
3. **Don't** initialize with README, .gitignore, or license (we already have these)
4. Click "Create repository"

### 5. Connect Local Repository to GitHub
After creating the repository, GitHub will show you commands. Use these (replace YOUR_USERNAME and REPO_NAME):
```bash
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
git branch -M main
git push -u origin main
```

### 6. If You Need to Authenticate
- GitHub no longer accepts passwords for HTTPS
- You'll need to use a Personal Access Token or SSH key
- For Personal Access Token: Go to GitHub Settings > Developer settings > Personal access tokens > Generate new token
- Use the token as your password when prompted

## Alternative: Using GitHub Desktop
If you prefer a GUI:
1. Download GitHub Desktop from https://desktop.github.com
2. Sign in with your GitHub account
3. Click "File" > "Add Local Repository"
4. Select this folder
5. Click "Publish repository" to push to GitHub

## Files Included
- `index.html` - Main website file
- `styles.css` - All styling
- `scripts.js` - JavaScript functionality
- `assets/` - All images and icons
- All other necessary files

## Notes
- The `.gitignore` file will exclude unnecessary files like `node_modules` and temporary files
- Make sure all your changes are committed before pushing
- You can update the site by making changes, then running:
  ```bash
  git add .
  git commit -m "Description of changes"
  git push
  ```



