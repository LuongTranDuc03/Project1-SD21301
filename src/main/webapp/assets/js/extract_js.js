const fs = require('fs');
const path = require('path');

const viewsDir = path.join(__dirname, 'src', 'main', 'webapp', 'WEB-INF', 'views');
const assetsJsDir = path.join(__dirname, 'src', 'main', 'webapp', 'assets', 'js');

// Regex to match <script> ... </script> excluding those with src attribute
const scriptRegex = /<script(?!\s+src)[^>]*>([\s\S]*?)<\/script>/gi;

function getTargetJsFolder(relPath) {
    const p = relPath.replace(/\\/g, '/');
    if (p.includes('admin/ha')) return 'customers';
    if (p.includes('admin/huy')) return 'employees';
    if (p.includes('admin/luong')) return 'products';
    if (p.includes('admin/phuc/invoice')) return 'invoices';
    if (p.includes('admin/phuc/coupon')) return 'coupons';
    if (p.includes('admin/phuc/attribute')) return 'attributes';
    if (p.includes('layout')) return 'layout';
    return 'admin';
}

function processDirectory(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
            processDirectory(fullPath);
        } else if (file.endsWith('.jsp')) {
            let content = fs.readFileSync(fullPath, 'utf8');
            let originalContent = content;
            let hasChanges = false;
            let match;
            
            let matches = [];
            while ((match = scriptRegex.exec(content)) !== null) {
                matches.push({
                    fullMatch: match[0],
                    innerJs: match[1]
                });
            }

            if (matches.length > 0) {
                let dynamicBlocks = 0;
                let staticBlocks = [];

                for (const m of matches) {
                    // Check for JSP tags
                    if (m.innerJs.includes('<%') || m.innerJs.includes('${')) {
                        dynamicBlocks++;
                    } else {
                        staticBlocks.push(m);
                    }
                }

                if (staticBlocks.length > 0) {
                    console.log(`Processing ${fullPath} - Found ${staticBlocks.length} static blocks`);
                    
                    const relPath = path.relative(viewsDir, fullPath);
                    const targetFolder = getTargetJsFolder(relPath);
                    
                    const jsDir = path.join(assetsJsDir, targetFolder);
                    if (!fs.existsSync(jsDir)) {
                        fs.mkdirSync(jsDir, { recursive: true });
                    }
                    
                    const baseName = path.basename(file, '.jsp');
                    const jsFileName = `${baseName}.js`;
                    const jsFilePath = path.join(jsDir, jsFileName);
                    
                    let combinedJs = '';
                    
                    for (const m of staticBlocks) {
                        // Skip empty blocks
                        if (m.innerJs.trim() === '') continue;
                        
                        combinedJs += m.innerJs.trim() + '\n\n';
                        
                        const scriptTag = `<script src="\${pageContext.request.contextPath}/assets/js/${targetFolder}/${jsFileName}"></script>`;
                        content = content.replace(m.fullMatch, scriptTag);
                        hasChanges = true;
                    }
                    
                    if (hasChanges && combinedJs.trim() !== '') {
                        if (fs.existsSync(jsFilePath)) {
                            fs.appendFileSync(jsFilePath, '\n/* Extracted from ' + file + ' */\n' + combinedJs, 'utf8');
                        } else {
                            fs.writeFileSync(jsFilePath, combinedJs, 'utf8');
                        }
                    }
                }

                // Remove consecutive duplicate script tags
                if (hasChanges) {
                    const relPath = path.relative(viewsDir, fullPath);
                    const targetFolder = getTargetJsFolder(relPath);
                    const baseName = path.basename(file, '.jsp');
                    const jsFileName = `${baseName}.js`;
                    
                    const scriptTagToRegex = new RegExp(`<script src="\\\$\\{pageContext\\.request\\.contextPath\\}/assets/js/${targetFolder}/${jsFileName}"></script>\\s*<script src="\\\$\\{pageContext\\.request\\.contextPath\\}/assets/js/${targetFolder}/${jsFileName}"></script>`, 'g');
                    while (scriptTagToRegex.test(content)) {
                        content = content.replace(scriptTagToRegex, `<script src="\${pageContext.request.contextPath}/assets/js/${targetFolder}/${jsFileName}"></script>`);
                    }
                    
                    fs.writeFileSync(fullPath, content, 'utf8');
                    console.log(`  -> Extracted static JS to assets/js/${targetFolder}/${jsFileName}`);
                }

                if (dynamicBlocks > 0) {
                    console.log(`  [WARNING] ${fullPath} has ${dynamicBlocks} dynamic script blocks containing JSP tags. Needs manual review.`);
                }
            }
        }
    }
}

processDirectory(viewsDir);
console.log('Done JS extraction script.');
