#!/usr/bin/env bash
set -ex
url=https://sdk-faas-testing-azure-nodejs.azurewebsites.net/api/sdk-faas-testing-azure-nodejs
resp=$(curl -sq -X POST -H 'Content-Type: application/json' --data '{ "operation": "upsert", "key": "key", "value": { "name": "Jake Rawsthorne" } }' $url | jq .)
echo $resp
status=$(echo $resp | jq .statusCode)
if [ $status != 200 ]; then
    echo request failed
    exit 1
fi