#!/bin/sh

SERVICE_TYPE=api

if [ -z "$AWS_BUCKET_NAME" ]; then
    echo "Bucket name is required to proceed. Add bucket name to environment variables"
    exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Secret key is required to proceed. Add secret key to environment variables"
    exit 1
fi

if [ -z "$AWS_REGION" ]; then
    echo "Region is required to proceed. Add region to environment variables"
    exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "Access key id is required to proceed. Add access key id to environment variables"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ $# -eq 0 ]; then
  echo "No arguments provided. Kindly provide an argument to proceed"
  exit 1
fi

APP_ENV=$1

if [ -z "$APP_ENV" ]; then
    echo "App env is required"
    exit 1
fi

if [ "$APP_ENV" != "staging" ] && [ "$APP_ENV" != "production" ]; then
    echo "Invalid app environment provided. Must be a 'staging' or 'production'"
    exit 1
fi

echo "Running script on $APP_ENV environment"

ENV_PASSPHRASE=$2

if [ -z "$ENV_PASSPHRASE" ]; then
    echo "Env passphrase is not provide. Kindly provide env passphrase to proceed"
    exit 1
fi

# Clean up generated files
source "$SCRIPT_DIR/clean-encrypted-env.sh" "$APP_ENV" "$SERVICE_TYPE"
cleanUp "$SCRIPT_DIR"

# Generate json from env
node "$SCRIPT_DIR/convert-env-to-json.js" "$APP_ENV" "$SERVICE_TYPE"
export ENV_ENCRYPTION_KEY="$ENV_PASSPHRASE"
node "$SCRIPT_DIR/encrypt-json.js" "$APP_ENV" "$SERVICE_TYPE"
# optional (decrypting immediately to make sure it works)
# node "$SCRIPT_DIR/decrypt-json.js" "$APP_ENV"

source "$SCRIPT_DIR/upload-encrypted-env.sh" "$APP_ENV"
upload "$SCRIPT_DIR" "$APP_ENV" "$SERVICE_TYPE"
