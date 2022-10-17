const couchbase = require("couchbase");
const functions = require('@google-cloud/functions-framework');

let clusterCache = null;

async function getCluster() {
  if (!clusterCache) {
    clusterCache = await couchbase.connect(process.env.CONNECTION_STRING, {
      username: "Administrator",
      password: "password",
    });
  }
  return clusterCache;
}

async function handleGet(collection, event) {
  try {
    const resp = await collection.get(event.key);
    const response = {
      statusCode: 200,
      body: resp,
    };
    return response;
  } catch (e) {
    const response = {
      statusCode: 400,
      body: e.message,
    };
    return response;
  }
}

async function handleUpsert(collection, event) {
  try {
    const resp = await collection.upsert(event.key, event.value);
    const response = {
      statusCode: 200,
      body: resp,
    };
    return response;
  } catch (e) {
    const response = {
      statusCode: 400,
      body: e.message,
    };
    return response;
  }
}

functions.http('handler', async (req, res) => {
  const cluster = await getCluster();
  const collection = cluster.bucket("default").defaultCollection();
  let response;
  switch (req.body.operation) {
    case "upsert":
      response = await handleUpsert(collection, req.body);
      break
    case "get":
      response = await handleGet(collection, req.body);
      break
    default:
      response = {
        statusCode: 400,
        body: "invalid operation",
      };
  }
  res.json(response);
});