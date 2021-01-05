# API Gateway Usage Plan
resource "aws_api_gateway_usage_plan" "apigw_usage_plan" {
  name = "${var.SERVICE}_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.apigw_api_gateway.id
    stage  = aws_api_gateway_deployment.deployment.stage_name
  }
}

# API Gateway Key
resource "aws_api_gateway_api_key" "apigw_auth_key" {
  name = "${var.SERVICE}_auth_key"
}

# API Gateway Key Usage Plan
resource "aws_api_gateway_usage_plan_key" "apigw_auth_key_usage_plan" {
  key_id        = aws_api_gateway_api_key.apigw_auth_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.apigw_usage_plan.id
}

# Key Output
output "apigw_auth_key" {
    value = aws_api_gateway_api_key.apigw_auth_key.value
}