from couchbase.cluster import Cluster
from couchbase.options import ClusterOptions
from couchbase.auth import PasswordAuthenticator
import os

cluster = None

def get_cluster():
    global cluster
    if cluster is None:
        cluster = Cluster(os.environ["CONNECTION_STRING"], ClusterOptions(PasswordAuthenticator("Administrator", "password")))
    return cluster

def handler(event, context):
    cluster = get_cluster()
    collection = cluster.bucket("default").default_collection()
    if event["operation"] == "upsert":
        return handle_upsert(collection, event)
    elif event["operations"] == "get":
        return handle_get(collection, event)
    else:
        response = {
            "statusCode": 400,
            "body": "invalid operation",
        }
        return response

def handle_get(collection, event):
  try:
    resp = collection.get(event["key"])
    response = {
      "statusCode": 200,
      "body": resp.content,
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