#!/bin/bash



SRC_LAMBDA_FUNCTION_NAME="$1"
DST_LAMBDA_FUNCTION_NAME="$1"

SRC_PACKAGE_URL=$(aws lambda get-function --function-name "$SRC_LAMBDA_FUNCTION_NAME"  --region us-east-1 --query 'Code.Location' --output text)

if [ $? -ne 0 ]; then
    exit 1
fi

TMP_FILE_PATH=$(mktemp)

echo "Downloading source package of $SRC_LAMBDA_FUNCTION_NAME..."

curl --silent "$SRC_PACKAGE_URL" -o "$TMP_FILE_PATH"

if [ $? -ne 0 ]; then
    exit 1
fi

echo "Updating code of $DST_LAMBDA_FUNCTION_NAME..."

aws lambda update-function-code --function-name "$DST_LAMBDA_FUNCTION_NAME" --zip-file "fileb://$TMP_FILE_PATH" --publish >/dev/null

UPDATE_RESULT=$?

if [ -f "$TMP_FILE_PATH" ]; then
    rm -f "$TMP_FILE_PATH"
fi

if [ $UPDATE_RESULT -ne 0 ]; then
    exit 1
fi