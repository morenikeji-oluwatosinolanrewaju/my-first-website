const fs = require("fs");
const path = require("path");
const files = [
  "index.html",
  "style.css",
  "script.js",
  "lessons.js",
  "curriculum.js",
  "manifest.json",
  "icon.svg"
];
const out = path.join(process.cwd(), "www");
fs.rmSync(out, { recursive: true, force: true });
fs.mkdirSync(out, { recursive: true });
for (const file of files) {
  if (!fs.existsSync(file)) throw new Error("Missing app file: " + file);
  fs.copyFileSync(file, path.join(out, file));
}
console.log("Prepared LEARNERS DIC. web assets in www/");
