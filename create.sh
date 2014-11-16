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

upload_app_template() {
  local src="$1"
  local bucketName="$2"
  local keyName="$3"
  aws s3 cp $src s3://${bucketName}/${keyName}

  if [ $? -ne 0 ]; then
    echo "Failed to upload eb.json to S3" >&2
    exit 1
  fi
}

BUCKET_NAME=$(find_param S3Bucket)
KEY_NAME=$(find_param S3Key)

# upload eb.json to master
upload_app_template eb.json $BUCKET_NAME "$(find_param AppTemplateKey)"

upload_app_template resource.json $BUCKET_NAME "$(find_param ResourcesTemplateKey)"

# upload git archive to S3
git archive --format zip HEAD | aws s3 cp - s3://${BUCKET_NAME}/${KEY_NAME}

aws cloudformation create-stack \
   --stack-name my-nested-stack \
   --template-body file://master.json \
   --region ap-northeast-1 \
   --parameters file://param.json \
   --capabilities CAPABILITY_IAM
