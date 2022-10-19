from couchbase.cluster import Cluster
from couchbase.options import ClusterOptions
from couchbase.auth import PasswordAuthenticator
import os
import functions_framework

cluster = None

def get_cluster():
    global cluster
    if cluster is None:
        cluster = Cluster(os.environ["CONNECTION_STRING"], ClusterOptions(PasswordAuthenticator("Administrator", "password")))
    return cluster

@functions_framework.http
def handler(request):
    request_json = request.get_json()
    cluster = get_cluster()
    collection = cluster.bucket("default").default_collection()
    if request_json["operation"] == "upsert":
        return handle_upsert(collection, request_json)
    elif request_json["operation"] == "get":
        return handle_get(collection, request_json)
    else:
        return {
            "statusCode": 400,
            "body": "invalid operation",
        }

def handle_get(collection, event):
    try:
      resp = collection.get(event["key"])
      response = {
        "statusCode": 200,
        "body": resp.content_as[dict],
      }
      return response
    except Exception as e:
      response = {
        "statusCode": 400,
        "body": str(e),
      }
      return response

def handle_upsert(collection, event):
    try:
        resp = collection.upsert(event["key"], event["value"])
        response = {
            "statusCode": 200,
            "body": resp.cas,
        }
        return response
    except Exception as e:
        response = {
            "statusCode": 400,
            "body": e.message,
        }
        return response

