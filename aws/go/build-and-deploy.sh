#!/usr/bin/env bash
set -e
docker build -t faas-go .
rm -rf function.zip || true
docker run -v $PWD:/out -it faas-go bash -c 'cd /app && zip -r /out/function.zip main'
aws lambda delete-function --function-name go || true
aws s3 cp function.zip s3://sdkqe-lambda-functions/go/function.zip
aws lambda create-function \
    --function-name go \
    --runtime go1.x \
    --environment 'Variables={CONNECTION_STRING=couchbase://node1-6cf4e3ca.cbqeoc.com}' \
    --code S3Bucket=sdkqe-lambda-functions,S3Key=go/function.zip \
    --role arn:aws:iam::516524556673:role/sdkqe_lambda \
    --handler main
