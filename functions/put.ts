module.exports.put = async (event, context, callback) => {
    try {
        const AWS = require('aws-sdk');
        const dynamoDb = new AWS.DynamoDB.DocumentClient();
        const requestBody = JSON.parse(event.body);
        
        // create dynamodb record
        await dynamoDb.put({
            TableName: process.env.DYNAMODB_TABLE,
            Item: {
                uuid: requestBody.uuid,
                key_1: value_1
            }
        }).promise();
        
        callback(null, {
            statusCode: 201,
            body: JSON.stringify({
              response: "successfully created record",
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