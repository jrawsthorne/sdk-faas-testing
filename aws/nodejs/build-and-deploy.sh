#!/usr/bin/env bash
set -e
docker build -t faas-nodejs .
rm -rf function.zip || true
docker run -v $PWD:/out -it faas-nodejs bash -c 'cd /app && zip -r /out/function.zip .'
aws lambda delete-function --function-name nodejs || true
aws s3 cp function.zip s3://sdkqe-lambda-functions/nodejs/function.zip
aws lambda create-function \
    --function-name nodejs \
    --runtime nodejs16.x \
    --environment 'Variables={CONNECTION_STRING=couchbase://node1-4bf1f1ac.cbqeoc.com,CBPPLOGLEVEL=trace}' \
    --code S3Bucket=sdkqe-lambda-functions,S3Key=nodejs/function.zip \
    --role arn:aws:iam::516524556673:role/sdkqe_lambda \
    --handler index.handler
