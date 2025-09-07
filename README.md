# s3-secrets-sync

One-command DevOps solution for secure environment variable management with S3-compatible storage.

## What it does

`s3-secrets-sync` offers a seamless approach to securely share environment variables across:
- CI/CD pipelines
- Server environments
- Development teams
- Kubernetes clusters

## Features

- ✅ **Security First**: AES-256 encryption with your encryption key
- 🔄 **Seamless Workflow**: Single commands for encrypt+upload and download+decrypt
- 🔌 **Storage Flexibility**: Works with any S3-compatible service (AWS, MinIO, DigitalOcean, etc.)
- 🧰 **Zero Dependencies**: Pure Bash with auto-installing requirements
- 💻 **Cross-platform**: macOS, Linux, and CI environments

## Requirements

All dependencies auto-install if missing:
- Bash shell (pre-installed on macOS/Linux)
- OpenSSL, jq, S3-compatible CLI

## Installation

**Option 1: Direct install script** (recommended)
```bash
# Install globally (requires sudo)
curl -fsSL https://raw.githubusercontent.com/tylerdgenius/s3-secrets-sync/main/install.sh | sudo bash

# Install to custom location
curl -fsSL https://raw.githubusercontent.com/tylerdgenius/s3-secrets-sync/main/install.sh | bash -s -- --prefix ~/local
```

**Option 2: From repository**
```bash
git clone https://github.com/tylerdgenius/s3-secrets-sync.git
cd s3-secrets-sync
sudo make install

# Or to a custom location
sudo make install PREFIX=/custom/path
```

After installation, the `s3-secrets-sync` command will be available system-wide. You can run it from any directory on your system:

```bash
# Verify installation
s3-secrets-sync --version

# Run commands from any location
s3-secrets-sync [command] [options]
```

## Quick Start

```bash
# Set credentials once (supports both AWS_ prefixed and non-prefixed variables)
export ACCESS_KEY_ID=your_access_key
export SECRET_ACCESS_KEY=your_secret_key
export BUCKET_NAME=your-bucket
export REGION=us-west-2
export ENV_ENCRYPTION_KEY=your_secure_key

# Encrypt and upload .env in one command
s3-secrets-sync sync -e production -s api

# Later, download and decrypt to .env
s3-secrets-sync pull -e production -s api
```

## Command Reference

### Core Commands

| Command    | Description                           | Example                                      |
|------------|---------------------------------------|----------------------------------------------|
| `sync`     | Encrypt .env + upload to S3           | `s3-secrets-sync sync -e dev -s api`         |
| `pull`     | Download from S3 + decrypt to .env    | `s3-secrets-sync pull -e dev -s api`         |
| `encrypt`  | Just encrypt .env to .enc file        | `s3-secrets-sync encrypt -e dev -s api`      |
| `decrypt`  | Just decrypt .enc file to .env        | `s3-secrets-sync decrypt -e dev -s api`      |
| `upload`   | Just upload encrypted file to S3      | `s3-secrets-sync upload -e dev -s api`       |
| `download` | Just download encrypted file from S3  | `s3-secrets-sync download -e dev -s api`     |

### Options

| Option                 | Description                                | Default               |
|------------------------|--------------------------------------------|-------------------------|
| `-e, --env ENV`        | Environment name                           | (required)              |
| `-s, --service NAME`   | Service name                               | (required)              |
| `-t, --type TYPE`      | Service type                               | `api`                   |
| `-f, --file PATH`      | Path to .env file                          | `.env`                  |
| `-k, --key KEY`        | Encryption key                             | `ENV_ENCRYPTION_KEY`    |
| `-b, --bucket NAME`    | S3 bucket name                             | `BUCKET_NAME`           |
| `-r, --region REGION`  | S3 region                                  | `REGION`                |
| `--access-key ID`      | S3 access key ID                           | `ACCESS_KEY_ID`         |
| `--secret-key KEY`     | S3 secret access key                       | `SECRET_ACCESS_KEY`     |
| `--endpoint URL`       | Custom S3 endpoint                         | `https://s3.amazonaws.com` |
| `-h, --help`           | Show help                                  |                         |
| `-v, --version`        | Show version                               |                         |

### Environment Variables

Supports both prefixed and non-prefixed variables:

| Purpose              | Standard Variable     | AWS-prefixed Alternative    |
|----------------------|-----------------------|----------------------------|
| Encryption key       | `ENV_ENCRYPTION_KEY`  | -                          |
| Access key ID        | `ACCESS_KEY_ID`       | `AWS_ACCESS_KEY_ID`        |
| Secret access key    | `SECRET_ACCESS_KEY`   | `AWS_SECRET_ACCESS_KEY`    |
| S3 bucket name       | `BUCKET_NAME`         | `AWS_BUCKET_NAME`          |
| Region name          | `REGION`              | `AWS_REGION`               |

## Example Workflows

### DevOps: Setup Once, Use Everywhere

```bash
# DevOps: Set up once in CI/CD
export ENV_ENCRYPTION_KEY="team-secret-key"
export ACCESS_KEY_ID="ci-access-key"
export SECRET_ACCESS_KEY="ci-secret-key"
export BUCKET_NAME="company-secrets"

# Production deployment
s3-secrets-sync pull -e production -s backend
s3-secrets-sync pull -e production -s frontend
```

### Local Development

```bash
# Direct command use - great for development
s3-secrets-sync encrypt -e dev -s myservice -f .env.local -k mykey
s3-secrets-sync upload -e dev -s myservice -b dev-bucket

# Or use flags instead of environment variables
s3-secrets-sync sync -e staging -f .env \
  --key "secret-key" \
  --access-key "my-key" \
  --secret-key "my-secret" \
  --bucket "my-bucket" \
  --region "us-west-2"
```

## File Details

Stored with this naming pattern:
- JSON: `<service_name>-env-<env>-<service_type>.json`
- Encrypted: `<service_name>-env-<env>-<service_type>.json.enc`
- S3 path: `s3://<bucket>/secrets/<service_name>-env-<env>-<service_type>.json.enc`

## Administration

```bash
# Run tests
./test.sh

# Uninstall
sudo make uninstall
```

## License

ISC License
