# Dynamo Get Function
resource "aws_lambda_function" "get_lambda" {
  filename          = "../.serverless/${var.SERVICE}.zip"
  source_code_hash  = filebase64sha256("../.serverless/${var.SERVICE}.zip")
  function_name     = "${var.SERVICE}-${var.STAGE}-get"
  role              = aws_iam_role.get_lambda_role.arn
  handler           = "functions/get.get"
  runtime           = "nodejs12.x"
  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.apigw_dynamodb_table.id
    }
  }
}

# Permission to allow execution from api gateway to invoke the lambda function
resource "aws_lambda_permission" "get_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGatewayGet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.apigw_api_gateway.id}/*/${aws_api_gateway_method.get_method.http_method}${aws_api_gateway_resource.get_resource.path}"
}

# Cloudwatch Log Group Resource for the Get Function
resource "aws_cloudwatch_log_group" "get_lambda_cw_group" {
  name              = "/aws/lambda/${aws_lambda_function.get_lambda.function_name}"
}

# IAM Role for the Get Lambda Function
resource "aws_iam_role" "get_lambda_role" {
  name               = "get_role"
  assume_role_policy = <<POLICY
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
    }
  ]
}
POLICY
}


# IAM Policy for the create/put log group/stream for the get function
resource "aws_iam_policy" "get_lambda_logging_policy" {
  name = "get_policy"
  path = "/"
  description = "IAM policy for logging from get lamdba"

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

# Policy attachment for get function role and policy
resource "aws_iam_role_policy_attachment" "get_lambda_logs_policy_attachment" {
  role        = aws_iam_role.get_lambda_role.name
  policy_arn  = aws_iam_policy.get_lambda_logging_policy.arn
}