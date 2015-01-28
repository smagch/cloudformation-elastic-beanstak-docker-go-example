#!/bin/bash
set -e

# ensure param.json exists
if [ ! -f param.vpc.json ]; then
    cat <<EOUSAGE
param.json file should exist.
You can copy param.example.json
EOUSAGE
    exit 1
fi

BUCKET_NAME=smagch-docker
KEY_NAME=docker-vpc-test.zip

# upload git archive to S3
git archive --format zip HEAD | aws s3 cp - s3://${BUCKET_NAME}/${KEY_NAME}

aws cloudformation create-stack \
   --stack-name my-vpc-stack-4 \
   --template-body file://vpc.json \
   --region ap-northeast-1 \
   --parameters file://param.vpc.json \
   --capabilities CAPABILITY_IAM
