#!/usr/bin/env bash
set -e
aws lambda invoke \
    --cli-binary-format raw-in-base64-out \
    --function-name go \
    --payload '{ "operation": "upsert", "key": "key", "value": { "name": "Jake Rawsthorne" } }' \
    response.json > /dev/null
cat response.json | jq .
status=$(cat response.json | jq .statusCode)
if [ $status != 200 ]; then
    echo request failed
    exit 1
fi