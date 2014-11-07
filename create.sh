#!/bin/bash
set -e

# ensure param.json exists
if [ ! -f param.json ]; then
    cat <<EOUSAGE
param.json file should exist.
You can copy param.example.json
EOUSAGE
    exit 1
fi

find_param() {
  local keyName="$1"
  cat param.json | jq -r --arg keyName $keyName \
    '.[] | select(.ParameterKey == $keyName) | .ParameterValue'
}

BUCKET_NAME=$(find_param S3Bucket)
KEY_NAME=$(find_param S3Key)

# upload git archive to S3
git archive --format zip HEAD | aws s3 cp - s3://${BUCKET_NAME}/${KEY_NAME}

aws cloudformation create-stack \
   --stack-name my-test-stack \
   --template-body file://eb.json \
   --region ap-northeast-1 \
   --parameters file://param.json
