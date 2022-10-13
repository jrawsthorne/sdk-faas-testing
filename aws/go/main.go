package main

import (
	"context"
	"encoding/json"
	"errors"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/couchbase/gocb/v2"
)

var cluster *gocb.Cluster

func init() {
	var err error
	connectionString := os.Getenv("CONNECTION_STRING")
	cluster, err = gocb.Connect(connectionString, gocb.ClusterOptions{Username: "Administrator", Password: "password"})
	if err != nil {
		panic(err)
	}
}

type Operation string

const (
	OperationGet    Operation = "get"
	OperationUpsert Operation = "upsert"
)

type Event struct {
	Operation Operation        `json:"operation"`
	Key       string           `json:"key,omitempty"`
	Value     *json.RawMessage `json:"value,omitempty"`
}

type Response struct {
	StatusCode int              `json:"statusCode"`
	Body       *json.RawMessage `json:"body"`
}

func handleGet(ctx context.Context, event Event) (Response, error) {
	collection := cluster.Bucket("default").DefaultCollection()

	resp, err := collection.Get(event.Key, &gocb.GetOptions{Context: ctx})
	if err != nil {
		return Response{}, err
	}

	var content *json.RawMessage

	err = resp.Content(&content)
	if err != nil {
		return Response{}, err
	}

	return Response{StatusCode: 200}, nil
}

func handleUpsert(ctx context.Context, event Event) (Response, error) {
	collection := cluster.Bucket("default").DefaultCollection()

	_, err := collection.Upsert(event.Key, event.Value, &gocb.UpsertOptions{Context: ctx})
	if err != nil {
		return Response{}, err
	}

	return Response{StatusCode: 200}, nil
}

func HandleRequest(ctx context.Context, event Event) (Response, error) {
	switch event.Operation {
	case OperationGet:
		return handleGet(ctx, event)
	case OperationUpsert:
		return handleUpsert(ctx, event)
	default:
		return Response{}, errors.New("invalid operation")
	}
}

func main() {
	lambda.Start(HandleRequest)
}
