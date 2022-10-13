#!/usr/bin/env bash
set -e
docker build -t faas-python .
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 516524556673.dkr.ecr.us-east-2.amazonaws.com
aws ecr create-repository --repository-name faas-python || true
docker tag  faas-python:latest 516524556673.dkr.ecr.us-east-2.amazonaws.com/faas-python:latest
docker push 516524556673.dkr.ecr.us-east-2.amazonaws.com/faas-python:latest
aws lambda delete-function --function-name python || true
aws lambda create-function \
    --function-name python \
    --environment 'Variables={CONNECTION_STRING=couchbase://node1-6cf4e3ca.cbqeoc.com}' \
    --code ImageUri=516524556673.dkr.ecr.us-east-2.amazonaws.com/faas-python:latest \
    --role arn:aws:iam::516524556673:role/sdkqe_lambda \
    --package-type Image