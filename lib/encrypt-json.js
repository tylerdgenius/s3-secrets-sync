 
 

const fs = require("fs");
const crypto = require("crypto");
const path = require("path");

const APP_ENV = process.argv[2];

if (!APP_ENV) {
  console.error(
    "❌ Missing environment argument. Usage: node decrypt-env.js <env>",
  );
  process.exit(1);
}

const PASSPHRASE = process.env.ENV_ENCRYPTION_KEY;

if (!PASSPHRASE) {
  console.error("❌ ENV_ENCRYPTION_KEY is not set");
  process.exit(1);
}

const SERVICE_TYPE = process.argv[3];

if (!SERVICE_TYPE) {
  console.error("❌ Missing environment argument. Service type is necessary");
  process.exit(1);
}

const INPUT_FILE = `palanck-env-${APP_ENV}-${SERVICE_TYPE}.json`;
const OUTPUT_FILE = `palanck-env-${APP_ENV}-${SERVICE_TYPE}.json.enc`;

const jsonPath = path.resolve(__dirname, INPUT_FILE);
if (!fs.existsSync(jsonPath)) {
  console.error(
    `❌ ${INPUT_FILE} not found. Run convert-env-to-json.js first.`,
  );
  process.exit(1);
}

const content = fs.readFileSync(jsonPath, "utf8");
const iv = crypto.randomBytes(16);
const key = crypto.scryptSync(PASSPHRASE, "salt", 32);
const cipher = crypto.createCipheriv("aes-256-cbc", key, iv);

let encrypted = cipher.update(content, "utf8", "hex");
encrypted += cipher.final("hex");

const result = {
  iv: iv.toString("hex"),
  data: encrypted,
};

fs.writeFileSync(
  path.resolve(__dirname, OUTPUT_FILE),
  JSON.stringify(result, null, 2),
);

fs.unlinkSync(path.resolve(__dirname, INPUT_FILE));
console.log(`✅ Encrypted ${INPUT_FILE} to ${OUTPUT_FILE}`);
