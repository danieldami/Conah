from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import json
import time
import os

def capture_webflow_site():
    print("Setting up Chrome driver...")
    chrome_options = Options()
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    # chrome_options.add_argument('--headless')  # Uncomment for headless mode
    
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=chrome_options)
    
    try:
        print("Navigating to intiri-template.webflow.io...")
        driver.get("https://intiri-template.webflow.io")
        
        # Wait for page to load
        time.sleep(5)
        
        # Wait for page to be fully loaded
        WebDriverWait(driver, 30).until(
            EC.presence_of_element_located((By.TAG_NAME, "body"))
        )
        
        # Extract HTML
        print("Extracting HTML...")
        html = driver.page_source
        with open("captured-html.html", "w", encoding="utf-8") as f:
            f.write(html)
        
        # Extract CSS
        print("Extracting CSS...")
        css_rules = driver.execute_script("""
            const stylesheets = Array.from(document.styleSheets);
            const rules = [];
            
            stylesheets.forEach(sheet => {
                try {
                    const cssRules = Array.from(sheet.cssRules || []);
                    cssRules.forEach(rule => {
                        if (rule.cssText) {
                            rules.push(rule.cssText);
                        }
                    });
                } catch (e) {
                    // Cross-origin stylesheets may throw errors
                }
            });
            
            return rules.join('\\n\\n');
        """)
        with open("captured-css.css", "w", encoding="utf-8") as f:
            f.write(css_rules)
        
        # Extract fonts
        print("Extracting fonts...")
        fonts = driver.execute_script("""
            const fontFaces = [];
            const stylesheets = Array.from(document.styleSheets);
            
            stylesheets.forEach(sheet => {
                try {
                    const cssRules = Array.from(sheet.cssRules || []);
                    cssRules.forEach(rule => {
                        if (rule instanceof CSSFontFaceRule) {
                            fontFaces.push(rule.cssText);
                        }
                    });
                } catch (e) {
                    // Cross-origin stylesheets may throw errors
                }
            });
            
            const allElements = document.querySelectorAll('*');
            const fontFamilies = new Set();
            allElements.forEach(el => {
                const computedStyle = window.getComputedStyle(el);
                fontFamilies.add(computedStyle.fontFamily);
            });
            
            return {
                fontFaces: fontFaces,
                fontFamilies: Array.from(fontFamilies)
            };
        """)
        with open("captured-fonts.json", "w", encoding="utf-8") as f:
            json.dump(fonts, f, indent=2)
        
        # Extract animations
        print("Extracting animations...")
        animations = driver.execute_script("""
            const stylesheets = Array.from(document.styleSheets);
            const keyframes = [];
            const animations = [];
            
            stylesheets.forEach(sheet => {
                try {
                    const cssRules = Array.from(sheet.cssRules || []);
                    cssRules.forEach(rule => {
                        if (rule instanceof CSSKeyframesRule) {
                            keyframes.push(rule.cssText);
                        }
                        if (rule.style && rule.style.animation) {
                            animations.push({
                                selector: rule.selectorText,
                                animation: rule.style.animation
                            });
                        }
                    });
                } catch (e) {
                    // Cross-origin stylesheets may throw errors
                }
            });
            
            return { keyframes, animations };
        """)
        with open("captured-animations.json", "w", encoding="utf-8") as f:
            json.dump(animations, f, indent=2)
        
        # Extract media queries
        print("Extracting media queries...")
        media_queries = driver.execute_script("""
            const stylesheets = Array.from(document.styleSheets);
            const mediaQueries = [];
            
            stylesheets.forEach(sheet => {
                try {
                    const cssRules = Array.from(sheet.cssRules || []);
                    cssRules.forEach(rule => {
                        if (rule instanceof CSSMediaRule) {
                            mediaQueries.push({
                                media: rule.media.mediaText,
                                cssText: rule.cssText
                            });
                        }
                    });
                } catch (e) {
                    // Cross-origin stylesheets may throw errors
                }
            });
            
            return mediaQueries;
        """)
        with open("captured-media-queries.json", "w", encoding="utf-8") as f:
            json.dump(media_queries, f, indent=2)
        
        # Extract images
        print("Extracting images...")
        images = driver.execute_script("""
            const imgTags = Array.from(document.querySelectorAll('img'));
            const bgImages = [];
            
            const allElements = document.querySelectorAll('*');
            allElements.forEach(el => {
                const bgImage = window.getComputedStyle(el).backgroundImage;
                if (bgImage && bgImage !== 'none') {
                    bgImages.push({
                        element: el.tagName + (el.className ? '.' + el.className : '') + (el.id ? '#' + el.id : ''),
                        backgroundImage: bgImage
                    });
                }
            });
            
            return {
                images: imgTags.map(img => ({
                    src: img.src,
                    alt: img.alt,
                    className: img.className,
                    id: img.id
                })),
                backgroundImages: bgImages
            };
        """)
        with open("captured-assets.json", "w", encoding="utf-8") as f:
            json.dump(images, f, indent=2)
        
        # Take screenshots
        print("Taking screenshots...")
        viewports = [
            {"width": 1920, "height": 1080, "name": "desktop"},
            {"width": 768, "height": 1024, "name": "tablet"},
            {"width": 375, "height": 667, "name": "mobile"}
        ]
        
        for viewport in viewports:
            driver.set_window_size(viewport["width"], viewport["height"])
            time.sleep(1)
            driver.save_screenshot(f"screenshot-{viewport['name']}.png")
        
        print("Capture complete! Check the generated files.")
        
    except Exception as e:
        print(f"Error capturing site: {e}")
    finally:
        driver.quit()

if __name__ == "__main__":
    capture_webflow_site()


