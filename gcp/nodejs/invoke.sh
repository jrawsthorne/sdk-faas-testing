#!/usr/bin/env bash
set -e
url=$(gcloud functions describe sdk-faas-testing-gcp-nodejs --gen2 --region us-central1 --format="value(serviceConfig.uri)")
resp=$(curl -sq -X POST -H 'Content-Type: application/json' --data '{ "operation": "upsert", "key": "key", "value": { "name": "Jake Rawsthorne" } }' $url | jq .)
echo $resp
status=$(echo $resp | jq .statusCode)
if [ $status != 200 ]; then
    echo request failed
    exit 1
fi