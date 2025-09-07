#!/bin/bash

BUCKET_NAME=$AWS_BUCKET_NAME

echo "$3"

upload() {
    local appEnv=$2
    local serviceType=$3
    local unencryptedFilePath="palanck-env-$appEnv-$serviceType.json"
    local encryptedFile="$unencryptedFilePath.enc"
    local endpointUrl="https://usc1.contabostorage.com"

    echo "$encryptedFile"

    local encryptedFilePath="$1/$encryptedFile"
    local s3Key="secrets/$encryptedFile"

    echo "$encryptedFilePath"

    if [ ! -f "$encryptedFilePath" ]; then
        echo "❌ Encrypted file $encryptedFilePath not found. Run encrypt-json.js first."
        exit 1
    fi

    echo "🚀 Uploading $encryptedFile to s3://$AWS_BUCKET_NAME/$s3Key..."
    aws --endpoint-url https://usc1.contabostorage.com s3 cp "$encryptedFilePath" "s3://$AWS_BUCKET_NAME/$s3Key" --only-show-errors

    if [ $? -eq 0 ]; then
        echo "✅ Upload successful."
        rm "$encryptedFilePath"
    else
        echo "❌ Upload failed."
    fi

    unset AWS_REGION AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_BUCKET_NAME ENV_ENCRYPTION_KEY
}
