#!/usr/bin/env bash
set -e
docker build -t sdk-faas-testing-azure-nodejs .
rm -rf node_modules || true
docker run -v $PWD:/out -it sdk-faas-testing-azure-nodejs bash -c 'cp -R /app/node_modules /out'
az functionapp config appsettings set --name sdk-faas-testing-azure-nodejs --resource-group sdk-faas-testing --settings "CONNECTION_STRING=couchbase://node1-cebadc33.cbqeoc.com"
func azure functionapp publish sdk-faas-testing-azure-nodejs