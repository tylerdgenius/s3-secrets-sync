# S3 Secrets Sync GitHub Action

This action uses [s3-secrets-sync](https://github.com/tylerdgenius/s3-secrets-sync) to download and decrypt environment variables from S3-compatible storage.

## Usage

Add this action to your GitHub workflow to pull environment variables from S3:

```yaml
steps:
  - name: Checkout code
    uses: actions/checkout@v3

  - name: Pull environment variables
    uses: tylerdgenius/s3-secrets-sync/.github/actions/s3-secrets-sync@master
    with:
      environment: 'production'
      service_name: 'my-app'
      service_type: 'api'
      encryption_key: ${{ secrets.ENV_ENCRYPTION_KEY }}
      access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
      secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      bucket_name: ${{ secrets.S3_BUCKET_NAME }}
      region: 'us-east-1'
```

## Inputs

| Parameter | Description | Required | Default |
|-----------|-------------|----------|---------|
| `environment` | Environment name (e.g., development, staging, production) | Yes | - |
| `service_name` | Service name | Yes | - |
| `service_type` | Service type | No | `api` |
| `file_path` | Path where original env file is located (input only) | No | `.env` |
| `encryption_key` | Encryption key | Yes | - |
| `bucket_name` | S3 bucket name | Yes | - |
| `region` | S3 region | No | `us-east-1` |
| `access_key_id` | S3 access key ID | Yes | - |
| `secret_access_key` | S3 secret access key | Yes | - |
| `endpoint_url` | Custom S3 endpoint URL | No | `https://s3.amazonaws.com` |

## Outputs

| Output | Description |
|--------|-------------|
| `env_file_path` | Absolute path to the .env file (always `{working_directory}/.env`) |

## Example: Complete workflow

Here's a complete example showing how to use this action in a workflow:

```yaml
name: Deploy with Environment Variables

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Pull environment variables
        uses: tylerdgenius/s3-secrets-sync/.github/actions/s3-secrets-sync@master
        with:
          environment: 'production'
          service_name: 'backend'
          encryption_key: ${{ secrets.ENV_ENCRYPTION_KEY }}
          access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          bucket_name: ${{ secrets.S3_BUCKET_NAME }}

      - name: Run application with env variables
        run: |
          # Now you can use the variables from .env
          echo "Environment variables loaded from S3"
          node app.js
```

## Notes

- The secrets will always be downloaded and stored in `.env` in the working directory
- Any existing `.env` file in the working directory will be overwritten
- The environment variables will also be available in all subsequent steps of your workflow
- Store sensitive information like encryption keys and AWS credentials as GitHub Secrets
