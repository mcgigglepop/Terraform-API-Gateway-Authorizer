# Dynamo update Function
resource "aws_lambda_function" "update_lambda" {
  filename          = "../.serverless/${var.SERVICE}.zip"
  source_code_hash  = filebase64sha256("../.serverless/${var.SERVICE}.zip")
  function_name     = "${var.SERVICE}-${var.STAGE}-update"
  role          = aws_iam_role.update_lambda_role.arn
  handler       = "functions/update.update"
  runtime       = "nodejs12.x"
  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.apigw_dynamodb_table.id
    }
  }
}

# Permission to allow execution from api gateway to invoke the lambda function
resource "aws_lambda_permission" "update_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGatewayUpdate"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.update_lambda.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.apigw_api_gateway.id}/*/${aws_api_gateway_method.update_method.http_method}${aws_api_gateway_resource.update_resource.path}"
}

# Cloudwatch Log Group Resource for the Update Function
resource "aws_cloudwatch_log_group" "update_lambda_cw_group" {
  name              = "/aws/lambda/${aws_lambda_function.update_lambda.function_name}"
}

# IAM Role for the Update Lambda Function
resource "aws_iam_role" "update_lambda_role" {
  name = "update_role"
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


# IAM Policy for the create/put log group/stream for the update function
resource "aws_iam_policy" "update_lambda_logging_policy" {
  name = "update_policy"
  path = "/"
  description = "IAM policy for logging from update lamdba"

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
                "dynamodb:Update"
            ],
            "Resource": [
                "${aws_dynamodb_table.apigw_dynamodb_table.arn}"
            ]
        }
  ]
}
EOF
}

# Policy attachment for update function role and policy
resource "aws_iam_role_policy_attachment" "update_lambda_logs_policy_attachment" {
  role = "${aws_iam_role.update_lambda_role.name}"
  policy_arn = "${aws_iam_policy.update_lambda_logging_policy.arn}"
}