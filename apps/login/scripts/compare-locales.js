
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const args = process.argv.slice(2);
if (args.length < 2) {
  console.error('Usage: node compare-locales.js <baseLang> <compareLang>');
  process.exit(1);
}

const baseLang = args[0];
const compareLang = args[1];

const basePath = path.join(__dirname, '../locales', `${baseLang}.json`);
const comparePath = path.join(__dirname, '../locales', `${compareLang}.json`);

console.log('Comparing en.json and fr.json for missing keys...');

function getMissingKeys(enObj, frObj, prefix = '') {
  let missing = [];
  for (const key in enObj) {
    const enVal = enObj[key];
    const frVal = frObj ? frObj[key] : undefined;
    const fullKey = prefix ? `${prefix}.${key}` : key;
    if (typeof enVal === 'object' && enVal !== null && !Array.isArray(enVal)) {
      missing = missing.concat(getMissingKeys(enVal, frVal, fullKey));
    } else {
      if (frVal === undefined) {
        missing.push(fullKey);
      }
    }
  }
  return missing;
}

let base, compare;
try {
  base = JSON.parse(fs.readFileSync(basePath, 'utf8'));
} catch (e) {
  console.error(`Could not read or parse ${baseLang}.json`);
  process.exit(1);
}
try {
  compare = JSON.parse(fs.readFileSync(comparePath, 'utf8'));
} catch (e) {
  console.error(`Could not read or parse ${compareLang}.json`);
  process.exit(1);
}

const missing = getMissingKeys(base, compare);

if (missing.length === 0) {
  console.log(`No missing translations in ${compareLang}.json`);
} else {
  console.log(`Missing translations in ${compareLang}.json compared to ${baseLang}.json:`);
  missing.forEach(key => console.log(key));
}