 
 

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

const ENCRYPTED_FILE = `palanck-env-${APP_ENV}-${SERVICE_TYPE}.json.enc`;
const OUTPUT_FILE = `palanck-env-${APP_ENV}-${SERVICE_TYPE}.json`;

const encPath = path.resolve(__dirname, ENCRYPTED_FILE);
if (!fs.existsSync(encPath)) {
  console.error(`❌ ${ENCRYPTED_FILE} not found`);
  process.exit(1);
}

const encryptedPayload = JSON.parse(fs.readFileSync(encPath, "utf8"));

const iv = Buffer.from(encryptedPayload.iv, "hex");
const encrypted = encryptedPayload.data;
const key = crypto.scryptSync(PASSPHRASE, "salt", 32);
const decipher = crypto.createDecipheriv("aes-256-cbc", key, iv);

let decrypted = decipher.update(encrypted, "hex", "utf8");
decrypted += decipher.final("utf8");

fs.writeFileSync(path.resolve(__dirname, OUTPUT_FILE), decrypted);
console.log(`✅ Decrypted ${ENCRYPTED_FILE} to ${OUTPUT_FILE}`);
