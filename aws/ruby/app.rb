require 'json'
require 'couchbase'
include Couchbase

$cluster = Cluster.connect(ENV["CONNECTION_STRING"], "Administrator", "password")

def handler(event:, context:)
    bucket = $cluster.bucket("default")
    collection = bucket.default_collection
    case event["operation"]
    when "get"
        handle_get(collection, event)
    when "upsert"
        handle_upsert(collection, event)
    else
        { statusCode: 400, body: "invalid operation" }
    end
end

def handle_get(collection, event)
    res = collection.get(event["key"])
    { statusCode: 200, body: res.content }
end

def handle_upsert(collection, event)
    res = collection.upsert(event["key"], event["value"])
    { statusCode: 200, body: { cas: res.cas } }
end