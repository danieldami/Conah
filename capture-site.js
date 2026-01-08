const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

async function captureWebflowSite() {
  console.log('Launching browser...');
  const browser = await puppeteer.launch({
    headless: false,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  try {
    const page = await browser.newPage();
    
    // Set viewport to capture desktop version
    await page.setViewport({ width: 1920, height: 1080 });
    
    console.log('Navigating to intiri-template.webflow.io...');
    await page.goto('https://intiri-template.webflow.io', {
      waitUntil: 'networkidle2',
      timeout: 60000
    });

    // Wait for page to fully load
    await page.waitForTimeout(3000);

    // Extract HTML
    console.log('Extracting HTML...');
    const html = await page.content();
    fs.writeFileSync('captured-html.html', html);

    // Extract computed styles for all elements
    console.log('Extracting styles...');
    const styles = await page.evaluate(() => {
      const allElements = document.querySelectorAll('*');
      const styleData = {};
      
      allElements.forEach((el, index) => {
        if (el.id || el.className) {
          const computedStyle = window.getComputedStyle(el);
          const selector = el.id ? `#${el.id}` : `.${el.className}`;
          
          styleData[selector] = {
            display: computedStyle.display,
            position: computedStyle.position,
            width: computedStyle.width,
            height: computedStyle.height,
            margin: computedStyle.margin,
            padding: computedStyle.padding,
            backgroundColor: computedStyle.backgroundColor,
            color: computedStyle.color,
            fontSize: computedStyle.fontSize,
            fontFamily: computedStyle.fontFamily,
            fontWeight: computedStyle.fontWeight,
            lineHeight: computedStyle.lineHeight,
            textAlign: computedStyle.textAlign,
            border: computedStyle.border,
            borderRadius: computedStyle.borderRadius,
            boxShadow: computedStyle.boxShadow,
            transform: computedStyle.transform,
            transition: computedStyle.transition,
            animation: computedStyle.animation,
            opacity: computedStyle.opacity,
            zIndex: computedStyle.zIndex,
            flexDirection: computedStyle.flexDirection,
            justifyContent: computedStyle.justifyContent,
            alignItems: computedStyle.alignItems,
            gap: computedStyle.gap,
            gridTemplateColumns: computedStyle.gridTemplateColumns,
            gridTemplateRows: computedStyle.gridTemplateRows,
          };
        }
      });
      
      return styleData;
    });
    fs.writeFileSync('captured-styles.json', JSON.stringify(styles, null, 2));

    // Extract all CSS rules
    console.log('Extracting CSS rules...');
    const cssRules = await page.evaluate(() => {
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
      
      return rules.join('\n\n');
    });
    fs.writeFileSync('captured-css.css', cssRules);

    // Extract fonts
    console.log('Extracting fonts...');
    const fonts = await page.evaluate(() => {
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
      
      // Also get all unique font families used
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
    });
    fs.writeFileSync('captured-fonts.json', JSON.stringify(fonts, null, 2));

    // Extract JavaScript
    console.log('Extracting JavaScript...');
    const scripts = await page.evaluate(() => {
      const scriptTags = Array.from(document.querySelectorAll('script'));
      return scriptTags.map(script => ({
        src: script.src,
        content: script.innerHTML,
        type: script.type
      }));
    });
    fs.writeFileSync('captured-scripts.json', JSON.stringify(scripts, null, 2));

    // Extract animations and keyframes
    console.log('Extracting animations...');
    const animations = await page.evaluate(() => {
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
    });
    fs.writeFileSync('captured-animations.json', JSON.stringify(animations, null, 2));

    // Take screenshots at different viewport sizes
    console.log('Taking screenshots...');
    const viewports = [
      { width: 1920, height: 1080, name: 'desktop' },
      { width: 768, height: 1024, name: 'tablet' },
      { width: 375, height: 667, name: 'mobile' }
    ];

    for (const viewport of viewports) {
      await page.setViewport({ width: viewport.width, height: viewport.height });
      await page.waitForTimeout(1000);
      await page.screenshot({
        path: `screenshot-${viewport.name}.png`,
        fullPage: true
      });
    }

    // Extract media queries
    console.log('Extracting media queries...');
    const mediaQueries = await page.evaluate(() => {
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
    });
    fs.writeFileSync('captured-media-queries.json', JSON.stringify(mediaQueries, null, 2));

    // Extract images and assets
    console.log('Extracting image sources...');
    const images = await page.evaluate(() => {
      const imgTags = Array.from(document.querySelectorAll('img'));
      const bgImages = [];
      
      // Get background images from all elements
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
    });
    fs.writeFileSync('captured-assets.json', JSON.stringify(images, null, 2));

    console.log('Capture complete! Check the generated files.');
    
  } catch (error) {
    console.error('Error capturing site:', error);
  } finally {
    await browser.close();
  }
}

captureWebflowSite();


