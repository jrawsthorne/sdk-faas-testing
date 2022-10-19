#!/usr/bin/env bash
set -e
gcloud config set project couchbase-qe
gcloud run deploy sdk-faas-testing-gcp-ruby \
--region=us-central1 \
--source=. \
--allow-unauthenticated \
--set-env-vars=CONNECTION_STRING=couchbase://node1-9040f17b.cbqeoc.com \