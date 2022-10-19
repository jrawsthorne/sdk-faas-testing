#!/usr/bin/env bash
set -e
gcloud config set project couchbase-qe
gcloud functions deploy sdk-faas-testing-gcp-nodejs \
--gen2 \
--runtime=nodejs16 \
--region=us-central1 \
--source=. \
--entry-point=handler \
--trigger-http \
--allow-unauthenticated \
--set-env-vars=CONNECTION_STRING=couchbase://node1-f33e1da5.cbqeoc.com