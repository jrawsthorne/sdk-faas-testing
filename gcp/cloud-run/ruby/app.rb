require "sinatra"
require 'json'
require "couchbase"
include Couchbase

set :bind, "0.0.0.0"
port = ENV["PORT"] || "8080"
set :port, port


$cluster = nil

def get_cluster()
  if $cluster
    return $cluster
  end
  $cluster = Cluster.connect(ENV["CONNECTION_STRING"], "Administrator", "password")
  return $cluster
end

post "/" do
  content_type :json
  data = JSON.parse request.body.read
  cluster = get_cluster()
  bucket = cluster.bucket("default")
  collection = bucket.default_collection
  case data["operation"]
  when "get"
      resp = handle_get(collection, data)
  when "upsert"
      resp = handle_upsert(collection, data)
  else
      resp = { statusCode: 400, body: "invalid operation" }
  end
  resp.to_json
end

def handle_get(collection, data)
  begin
    res = collection.get(data["key"])
    { statusCode: 200, body: res.content }
  rescue => error
    { statusCode: 400, body: error.message }
  end
end

def handle_upsert(collection, data)
  begin
    res = collection.upsert(data["key"], data["value"])
    { statusCode: 200, body: { cas: res.cas } }
  rescue => error
    { statusCode: 400, body: error.message }
  end
end