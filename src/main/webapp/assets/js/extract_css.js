const fs = require("fs");
const path = require("path");

const viewsDir = path.join(
  __dirname,
  "src",
  "main",
  "webapp",
  "WEB-INF",
  "views",
);
const assetsCssDir = path.join(
  __dirname,
  "src",
  "main",
  "webapp",
  "assets",
  "css",
);

// Regex to match <style> ... </style> (non-greedy)
const styleRegex = /<style[^>]*>([\s\S]*?)<\/style>/gi;

function getTargetCssFolder(relPath) {
  const p = relPath.replace(/\\/g, "/");
  if (p.includes("admin/ha")) return "customers";
  if (p.includes("admin/huy")) return "employees";
  if (p.includes("admin/luong")) return "products";
  if (p.includes("admin/phuc/invoice")) return "invoices";
  if (p.includes("admin/phuc/coupon")) return "coupons";
  if (p.includes("admin/phuc/attribute")) return "attributes";
  if (p.includes("layout")) return "layout";
  return "admin";
}

function processDirectory(dir) {
  const files = fs.readdirSync(dir);
  for (const file of files) {
    const fullPath = path.join(dir, file);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      processDirectory(fullPath);
    } else if (file.endsWith(".jsp")) {
      let content = fs.readFileSync(fullPath, "utf8");
      let hasChanges = false;
      let match;

      // Array to store all matches to process them later
      let matches = [];
      while ((match = styleRegex.exec(content)) !== null) {
        matches.push({
          fullMatch: match[0],
          innerCss: match[1],
        });
      }

      if (matches.length > 0) {
        console.log(`Processing ${fullPath}`);

        const relPath = path.relative(viewsDir, fullPath);
        const targetFolder = getTargetCssFolder(relPath);

        const cssDir = path.join(assetsCssDir, targetFolder);
        if (!fs.existsSync(cssDir)) {
          fs.mkdirSync(cssDir, { recursive: true });
        }

        const baseName = path.basename(file, ".jsp");
        const cssFileName = `${baseName}.css`;
        const cssFilePath = path.join(cssDir, cssFileName);

        let combinedCss = "";

        for (const m of matches) {
          combinedCss += m.innerCss.trim() + "\n\n";

          // Replace <style> with <link>
          const linkTag = `<link rel="stylesheet" href="\${pageContext.request.contextPath}/assets/css/${targetFolder}/${cssFileName}">`;
          content = content.replace(m.fullMatch, linkTag);
          hasChanges = true;
        }

        // Write or append to CSS file
        if (fs.existsSync(cssFilePath)) {
          fs.appendFileSync(
            cssFilePath,
            "\n/* Extracted from " + file + " */\n" + combinedCss,
            "utf8",
          );
        } else {
          fs.writeFileSync(cssFilePath, combinedCss, "utf8");
        }

        // Remove consecutive duplicate link tags if there were multiple <style> blocks
        const linkTagToRegex = new RegExp(
          `<link rel="stylesheet" href="\\\$\\{pageContext\\.request\\.contextPath\\}/assets/css/${targetFolder}/${cssFileName}">\\s*<link rel="stylesheet" href="\\\$\\{pageContext\\.request\\.contextPath\\}/assets/css/${targetFolder}/${cssFileName}">`,
          "g",
        );
        while (linkTagToRegex.test(content)) {
          content = content.replace(
            linkTagToRegex,
            `<link rel="stylesheet" href="\${pageContext.request.contextPath}/assets/css/${targetFolder}/${cssFileName}">`,
          );
        }

        if (hasChanges) {
          fs.writeFileSync(fullPath, content, "utf8");
          console.log(
            `  -> Extracted CSS to assets/css/${targetFolder}/${cssFileName}`,
          );
        }
      }
    }
  }
}

processDirectory(viewsDir);
console.log("Done CSS extraction.");
