 
 

const fs = require("fs");
const path = require("path");

const APP_ENV = process.argv[2];

if (!APP_ENV) {
  console.error(
    "❌ Missing environment argument. Usage: node decrypt-env.js <env>",
  );
  process.exit(1);
}

const SERVICE_TYPE = process.argv[3];

if (!SERVICE_TYPE) {
  console.error("❌ Missing environment argument. Service type is necessary");
  process.exit(1);
}

const ENV_FILE = "../.env";
const OUTPUT_FILE = `palanck-env-${APP_ENV}-${SERVICE_TYPE}.json`;

const parseEnv = (content) => {
  const result = {};
  content.split("\n").forEach((line) => {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) return;
    const [key, ...valueParts] = trimmed.split("=");
    const value = valueParts.join("=").replace(/^['"]|['"]$/g, "");
    if (key) result[key.trim()] = value;
  });
  return result;
};

const envPath = path.resolve(__dirname, ENV_FILE);
if (!fs.existsSync(envPath)) {
  console.error(`❌ ${ENV_FILE} not found`);
  process.exit(1);
}

const envContent = fs.readFileSync(envPath, "utf8");
const json = parseEnv(envContent);

fs.writeFileSync(
  path.resolve(__dirname, OUTPUT_FILE),
  JSON.stringify(json, null, 2),
);
console.log(`✅ Converted .env to ${OUTPUT_FILE}`);
