'use strict'
const AWS = require('aws-sdk');
const dynamoDb = new AWS.DynamoDB.DocumentClient();

// generate the returned policy statement for allow/deny
function generatePolicy(principalId, effect, resource, cUuid) {
  return {
    'principalId': principalId,
    'policyDocument': {
      'Version': '2012-10-17',
      'Statement': [{
        'Action': 'execute-api:Invoke',
        'Effect': effect,
        'Resource': resource
      }]
    },
    "context": {
      "uuid": cUuid // append extra data to pass into lambdas
    }
  };
}

module.exports.handler = async function(event, _context, cb) {
  // new date for logging
  let d = new Date();
  
  // read in auth token
  let authToken = event.authorizationToken;
  
  // get dynamo record 
  const dynamoObject = await dynamoDb.get({
    TableName: process.env.DYNAMODB_TABLE,
    Key: {
      uuid: authToken,
    }
  }).promise();

  let action, uuid;
  
  // get response status and object
  if (dynamoObject.Item == null) {
    // deny
    action = 'Deny';
    uuid = null;
    console.log(`${d.toString()} : authentication unsuccessful, invalid token`);
  }
  else {
    // allow
    action = 'Allow';
    uuid = dynamoObject.Item.uuid;
    console.log(`${uuid} : ${d.toString()} successfully authenticated access`);
  }

  // call back with the actual allow or deny policy
  cb(null, generatePolicy('user', action, event.methodArn, uuid));
};