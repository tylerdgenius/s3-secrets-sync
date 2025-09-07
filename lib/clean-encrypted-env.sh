#!/bin/bash

APP_ENV=$1
SERVICE_TYPE=$2

if [ -z $APP_ENV ]; then
    echo "App env is required to proceed"
    exit 1
fi

if [ -z $SERVICE_TYPE ]; then
    echo "Service type is required to proceed"
    exit 1
fi

ENCRYPTED_FILE="palanck-env-$APP_ENV-$SERVICE_TYPE.json.enc"
UNENCRYPTED_FILE="palanck-env-$APP_ENV-$SERVICE_TYPE.json"

cleanUp() {
    local encryptedFilePath="$1/$ENCRYPTED_FILE"
    local unecryptedFilePath="$1/$UNENCRYPTED_FILE"
    if [ -f "$encryptedFilePath" ]; then
        echo "🧹 Cleaning up $ENCRYPTED_FILE..."
        rm "$encryptedFilePath"
        echo "✅ Cleaned up."
    else
        echo "ℹ️ Nothing to delete — $ENCRYPTED_FILE not found."
    fi

    if [ -f "$unecryptedFilePath" ]; then
        echo "🧹 Cleaning up $UNENCRYPTED_FILE..."
        rm "$unecryptedFilePath"
        echo "✅ Cleaned up."
    else
        echo "ℹ️ Nothing to delete — $UNENCRYPTED_FILE not found."
    fi
}
