# s3-secrets-sync

A lightweight, Bash-based tool for securely syncing environment variables between local development environments and S3 storage.

## Overview

`s3-secrets-sync` makes it easy to:
- Encrypt `.env` files and upload them to S3
- Download encrypted environment files from S3 and decrypt them
- All with a simple command-line interface

## Repository Structure

```
Makefile            # Installation script
README.md           # Documentation
s3-secrets-sync     # Main executable script
test.sh             # Test script
VERSION             # Version information
```

## Requirements

- Bash
- OpenSSL (for encryption/decryption)
- jq (for JSON processing)
- AWS CLI (for S3 operations)

> **Note:** If OpenSSL, jq, or AWS CLI are missing, the tool will attempt to install them automatically on supported platforms (macOS and most Linux distributions).

## Installation

### Using make

```bash
# Clone the repository
git clone https://github.com/tylerdgenius/s3-secrets-sync.git
cd s3-secrets-sync

# Install globally
sudo make install

# Or to a custom location
sudo make install PREFIX=/custom/path
```

### Manual installation

```bash
# Clone the repository
git clone https://github.com/tylerdgenius/s3-secrets-sync.git
cd s3-secrets-sync

# Make executable and copy to a location in your PATH
chmod +x s3-secrets-sync
sudo cp s3-secrets-sync /usr/local/bin/
```

## Quick Start

### Encrypt and upload an .env file

```bash
# Set AWS credentials
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_BUCKET_NAME=your-bucket
export AWS_REGION=us-west-2

# Encrypt and upload in one step
s3-secrets-sync sync -e production -s api -f .env -k your_encryption_key
```

### Download and decrypt an .env file

```bash
# Set AWS credentials
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_BUCKET_NAME=your-bucket
export AWS_REGION=us-west-2

# Download and decrypt in one step
s3-secrets-sync pull -e production -s api -f .env -k your_encryption_key
```

## Commands

- `encrypt`: Convert .env file to JSON and encrypt it
- `decrypt`: Decrypt JSON file to .env format
- `upload`: Upload encrypted file to S3
- `download`: Download encrypted file from S3
- `sync`: Encrypt and upload in one step
- `pull`: Download and decrypt in one step

## Options

| Option | Description |
|--------|-------------|
| `-e, --env ENV` | Environment (development, staging, production) |
| `-s, --service TYPE` | Service type (default: api) |
| `-f, --file PATH` | Path to .env file (default: .env) |
| `-k, --key KEY` | Encryption key (can also use ENV_ENCRYPTION_KEY env var) |
| `-b, --bucket NAME` | S3 bucket name (can use BUCKET_NAME env var) |
| `-r, --region REGION` | S3 region (can use REGION env var) |
| `--access-key ID` | S3 access key ID (can use ACCESS_KEY_ID env var) |
| `--secret-key KEY` | S3 secret access key (can use SECRET_ACCESS_KEY env var) |
| `--endpoint URL` | S3 endpoint URL (default: https://s3.amazonaws.com) |
| `-h, --help` | Show help |
| `-v, --version` | Show version information |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `ENV_ENCRYPTION_KEY` | Encryption key (alternative to -k flag) |
| `ACCESS_KEY_ID` | S3 access key ID |
| `SECRET_ACCESS_KEY` | S3 secret access key |
| `BUCKET_NAME` | S3 bucket name (alternative to -b flag) |
| `REGION` | S3 region (alternative to -r flag) |

## Examples

### Using environment variables

```bash
# Set environment variables
export ENV_ENCRYPTION_KEY=mypassword
export ACCESS_KEY_ID=your_access_key
export SECRET_ACCESS_KEY=your_secret_key
export BUCKET_NAME=your-bucket
export REGION=us-west-2

# Sync (encrypt and upload)
s3-secrets-sync sync -e staging -s api

# Pull (download and decrypt)
s3-secrets-sync pull -e staging -s api
```

### Using command-line flags

```bash
# Encrypt
s3-secrets-sync encrypt -e development -s api -f .env -k mypassword

# Upload
s3-secrets-sync upload -e development -s api -b my-bucket -r us-west-2

# Download
s3-secrets-sync download -e production -s api -b my-bucket -r us-west-2

# Decrypt
s3-secrets-sync decrypt -e production -s api -f .env -k mypassword
```

## File Naming Convention

Files follow this naming pattern:
- JSON: `palanck-env-<env>-<service>.json`
- Encrypted: `palanck-env-<env>-<service>.json.enc`
- S3 key: `secrets/palanck-env-<env>-<service>.json.enc`

## Uninstallation

```bash
sudo make uninstall
```

## Testing

Run the test suite:

```bash
./test.sh
```

## License

This project is licensed under the ISC License.
