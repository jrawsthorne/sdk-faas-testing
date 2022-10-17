const couchbase = require("couchbase");

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

exports.handler = async function (event) {
  const cluster = await getCluster();
  const collection = cluster.bucket("default").defaultCollection();
  switch (event.operation) {
    case "upsert":
      return await handleUpsert(collection, event);
    case "get":
      return await handleGet(collection, event);
    default:
      const response = {
        statusCode: 400,
        body: "invalid operation",
      };
      return response;
  }
};

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
