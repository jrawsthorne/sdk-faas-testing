#!/usr/bin/env bash
set -ex

language=$1
commit=$2

if [ "$language" == "" ]; then
    echo "must supply a language"
    exit 1
fi

if [ "$commit" == "" ]; then
    echo "must supply a commit hash"
    exit 1
fi

if [ "$commit" == "master" ] || [ "$commit" == "main" ]; then
    echo "must give a commit hash"
    exit 1
fi

image=sdk-faas-testing-$language
ecr=516524556673.dkr.ecr.us-east-2.amazonaws.com

docker build --build-arg COMMIT=$commit -t $image .
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $ecr
aws ecr create-repository --repository-name $image || true
docker tag $image:$commit $ecr/$image:$commit
docker push $ecr/$image:$commit
aws lambda delete-function --function-name $image || true
aws lambda create-function \
    --function-name $image \
    --environment 'Variables={CONNECTION_STRING=couchbase://node1-6a570bd3.cbqeoc.com}' \
    --code ImageUri=$ecr/$image:$commit \
    --role arn:aws:iam::516524556673:role/sdkqe_lambda \
    --package-type Image