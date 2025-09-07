# s3-secrets-sync

A Bash tool for securely syncing environment variables to and from S3.

## Features

- Encrypt `.env` files and upload them to S3
- Download and decrypt environment files from S3
- Simple command-line interface
- Works with AWS S3 or compatible storage services
- Pure Bash implementation with minimal dependencies

## Requirements

- Bash
- OpenSSL (for encryption/decryption)
- jq (for JSON processing)
- AWS CLI (for S3 operations)

## Installation

### Option 1: Using make

```bash
git clone https://github.com/yourusername/s3-secrets-sync.git
cd s3-secrets-sync
sudo make install
```

This will install `s3-secrets-sync` to `/usr/local/bin`. To install to a different location, use:

```bash
sudo make install PREFIX=/your/custom/path
```

### Option 2: Manual installation

```bash
git clone https://github.com/yourusername/s3-secrets-sync.git
cd s3-secrets-sync
chmod +x s3-secrets-sync
sudo cp s3-secrets-sync /usr/local/bin/
```

## Usage

```
s3-secrets-sync <command> [options]
```

### Commands

- `encrypt`: Convert .env file to JSON and encrypt it
- `decrypt`: Decrypt JSON file to .env format
- `upload`: Upload encrypted file to S3
- `download`: Download encrypted file from S3
- `sync`: Encrypt and upload in one step
- `pull`: Download and decrypt in one step

### Options

- `-e, --env ENV`: Environment (development, staging, production)
- `-s, --service TYPE`: Service type (default: api)
- `-f, --file PATH`: Path to .env file (default: .env)
- `-k, --key KEY`: Encryption key (can also use ENV_ENCRYPTION_KEY env var)
- `-b, --bucket NAME`: S3 bucket name (can also use AWS_BUCKET_NAME env var)
- `-r, --region REGION`: AWS region (can also use AWS_REGION env var)
- `--endpoint URL`: S3 endpoint URL (default: https://s3.amazonaws.com)
- `-h, --help`: Show help
- `-v, --version`: Show version information

### Environment Variables

- `ENV_ENCRYPTION_KEY`: Encryption key (alternative to -k flag)
- `AWS_ACCESS_KEY_ID`: AWS access key ID
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key
- `AWS_BUCKET_NAME`: S3 bucket name (alternative to -b flag)
- `AWS_REGION`: AWS region (alternative to -r flag)

## Examples

### Encrypt an .env file

```bash
s3-secrets-sync encrypt -e production -s api -f .env -k mypassword
```

### Sync (encrypt and upload) an .env file

```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_BUCKET_NAME=your-bucket
export AWS_REGION=us-west-2

s3-secrets-sync sync -e staging --service api --key mypassword
```

### Pull (download and decrypt) an .env file

```bash
s3-secrets-sync pull -e production -s api -k mypassword -b my-bucket
```

## File Naming

Files follow this naming pattern:
- JSON: `palanck-env-<env>-<service>.json`
- Encrypted: `palanck-env-<env>-<service>.json.enc`
- S3 key: `secrets/palanck-env-<env>-<service>.json.enc`

## Uninstallation

```bash
sudo make uninstall
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
