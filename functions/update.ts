module.exports.update = async (event, context, callback) => {
    try {
        const AWS = require('aws-sdk');
        const dynamoDb = new AWS.DynamoDB.DocumentClient();
        const requestBody = JSON.parse(event.body);
        
        // update dynamo record 
        await dynamoDb.update({
            TableName: process.env.DYNAMODB_TABLE,
            Key: {
                uuid: requestBody.uuid,
            },
            ExpressionAttributeNames: {
                '#todo_text': `${requestBody.updateKey}`,
            },
            ExpressionAttributeValues: {
                ':text': `${requestBody.updateValue}`
            },
            UpdateExpression: 'SET #todo_text = :text',
            ReturnValues: 'UPDATED_NEW'
        }).promise();

        callback(null, {
            statusCode: 201,
            body: JSON.stringify({
              response: "successfully updated record",
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