module.exports.get = async (event, context, callback) => {
  try {
      const AWS = require('aws-sdk');
      const dynamoDb = new AWS.DynamoDB.DocumentClient();
      const requestBody = JSON.parse(event.body);
      
      // get dynamo record 
      const dynamoObject = await dynamoDb.get({
          TableName: process.env.DYNAMODB_TABLE,
          Key: {
              uuid: requestBody.uuid,
          }
      }).promise();

      callback(null, {
          statusCode: 201,
          body: JSON.stringify({
            dynamoObject: dynamoObject,
          }),
          headers: {
            'Access-Control-Allow-Origin': '*',
          },
      });
  }
  catch (err) {
      console.log(`${err}`);
      errorResponse(err.message, context.awsRequestId, callback)
  }

  function errorResponse(errorMessage, awsRequestId, callback) {
      callback(null, {
        statusCode: 500,
        body: JSON.stringify({
          Error: errorMessage,
          Reference: awsRequestId,
        }),
        headers: {
          'Access-Control-Allow-Origin': '*',
        },
      });
  }
};