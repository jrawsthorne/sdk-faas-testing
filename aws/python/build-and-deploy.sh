#!/usr/bin/env bash
set -e
docker build -t faas-python .
rm -rf function.zip || true
docker run -v $PWD:/out -it faas-python bash -c 'cd /app/package && zip -r /out/function.zip . && cd .. && zip -g /out/function.zip lib/* app.py'
aws lambda delete-function --function-name python || true
aws s3 cp function.zip s3://sdkqe-lambda-functions/python/function.zip
aws lambda create-function \
    --function-name python \
    --runtime python3.9 \
    --environment 'Variables={CONNECTION_STRING=couchbase://node1-4bf1f1ac.cbqeoc.com}' \
    --code S3Bucket=sdkqe-lambda-functions,S3Key=python/function.zip \
    --role arn:aws:iam::516524556673:role/sdkqe_lambda \
    --handler app.handler
