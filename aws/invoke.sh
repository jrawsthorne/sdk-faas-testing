#!/usr/bin/env bash
set -e

language=$1

if [ "$language" == "" ]; then
    echo "must supply a language"
    exit 1
fi

aws lambda invoke \
    --cli-binary-format raw-in-base64-out \
    --function-name sdk-faas-testing-$language \
    --payload '{ "operation": "upsert", "key": "key", "value": { "name": "Jake Rawsthorne" } }' \
    response.json > /dev/null
cat response.json | jq .
status=$(cat response.json | jq .statusCode)
if [ $status != 200 ]; then
    echo request failed
    rm response.json
    exit 1
fi
rm response.json