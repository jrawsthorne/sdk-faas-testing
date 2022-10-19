#!/usr/bin/env bash
set -ex
url=$(gcloud run services list --format json --filter 'metadata.name=sdk-faas-testing-gcp-ruby' --format="value(status.url)")
resp=$(curl -sq -X POST -H 'Content-Type: application/json' --data '{ "operation": "upsert", "key": "key", "value": { "name": "Jake Rawsthorne" } }' $url | jq .)
echo $resp
status=$(echo $resp | jq .statusCode)
if [ $status != 200 ]; then
    echo request failed
    exit 1
fi