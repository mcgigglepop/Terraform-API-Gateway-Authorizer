# API Gateway Authorizer
resource "aws_api_gateway_authorizer" "apigw_api_gateway_authorizer" {
  name                   = "authorizer"
  rest_api_id            = aws_api_gateway_rest_api.apigw_api_gateway.id
  authorizer_uri         = aws_lambda_function.apigw_authorizer_lambda.invoke_arn
  authorizer_credentials = aws_iam_role.apigw_authorizer_invocation_role.arn
}

# API Gateway Authorizer Function
resource "aws_lambda_function" "apigw_authorizer_lambda" {
  filename          = "../.serverless/${var.SERVICE}.zip"
  source_code_hash  = filebase64sha256("../.serverless/${var.SERVICE}.zip")
  function_name     = "${var.STAGE}-${var.STAGE}-authorizer-function"
  role              = aws_iam_role.apigw_authorizer_lambda_role.arn
  handler           = "functions/authorizer.handler"
  runtime           = "nodejs12.x"

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.apigw_dynamodb_table.id
    }
  }
}

# Authorizer Log Group
resource "aws_cloudwatch_log_group" "authorizer_lambda_cw_group" {
  name              = "/aws/lambda/${aws_lambda_function.apigw_authorizer_lambda.function_name}"
  retention_in_days = 14
}

# Authorizer Function Invocation Role 
resource "aws_iam_role" "apigw_authorizer_invocation_role" {
  name = "apigw_api_gateway_auth_invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Authorizer Function Invocation Policy
resource "aws_iam_role_policy" "apigw_authorizer_invocation_policy" {
  role = aws_iam_role.apigw_authorizer_invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "arn:aws:lambda:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.apigw_authorizer_lambda.function_name}"
    }
  ]
}
EOF
}

# Role for the Lambda Authorizer
resource "aws_iam_role" "apigw_authorizer_lambda_role" {
  name = "apigw_api_gateway_authorizer_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem"
            ],
            "Resource": [
                "${aws_dynamodb_table.apigw_dynamodb_table.arn}"
            ]
        }
  ]
}
EOF
}

# Policy fot the Lambda Authorizer
resource "aws_iam_policy" "authorizer_lambda_logging_policy" {
  name = "apigw_api_gateway_authorizer_policy"
  path = "/"
  description = "IAM policy for a custom authorizer"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow",
      "Sid": "VisualEditor0"
    }
  ]
}
EOF
}

# Authorizer Role/Policy Attachment
resource "aws_iam_role_policy_attachment" "authorizer_lambda_policy_attachment" {
  role        = aws_iam_role.apigw_authorizer_lambda_role.name
  policy_arn  = aws_iam_policy.authorizer_lambda_logging_policy.arn
}


