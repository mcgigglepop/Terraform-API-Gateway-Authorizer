# Terraform-API-Gateway-Authorizer

The application in this repository will provision an Amazon API Gateway Rest API using a custom Lambda Authorizing function with infrastructure as code using the Terraform markup language.

### VPC Architecture
![Highlevel arch](/images/Terraform-API-Gateway-Authorizer.png "APIGW Architecture")

By default, the following resources will be provisioned in `us-east-1`:  

- An AWS API Gateway
- A custom Lambda Authorizing Function
- A Dynamo Database
- A Lambda to Get an Item from Dynamo
- A Lambda to Put an Item in Dynamo
- A Lambda to Update an Item in Dynamo
- Appropriate IAM Role(s) and Policies

### Application Requirements  

The following dependencies are required to deploy this application:  

- The AWS CLI with a default profile configured
- Terraform

### Terraform Remote State

This application uses an S3 Bucket to manage remote state. The remote state bucket format follows the following naming convention: `{SERVICENAME}-{STAGE}-tf-artifacts`. This bucket needs to exist within your deployment environment before the application can be deployed.

### Deploying the Application  

Lambda functions need to be zipped before deployment.