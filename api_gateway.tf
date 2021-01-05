# API Gateway domain base path mapping
resource "aws_api_gateway_base_path_mapping" "apigw_base_path" {
  api_id      = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  domain_name = "${var.STAGE_DOMAIN_URL}"
  stage_name  = "${var.SERVICE}"
  base_path   = "${var.SERVICE}"
}

# Root API Gateway
resource "aws_api_gateway_rest_api" "apigw_api_gateway" {
  name = "${var.SERVICE}-${var.STAGE}-api-gateway"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "deployment" {
    rest_api_id   = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
    stage_name    = "${var.SERVICE}"
    depends_on    = ["aws_api_gateway_integration.put_integration", "aws_api_gateway_integration.cors_integration_put"]
}

# Put Resource
resource "aws_api_gateway_resource" "put_resource" {
  path_part   = "put"
  parent_id   = "${aws_api_gateway_rest_api.apigw_api_gateway.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
}

# Put Method
resource "aws_api_gateway_method" "put_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.put_resource.id}"
  http_method   = "PUT"
  authorization = "CUSTOM"
  authorizer_id = "${aws_api_gateway_authorizer.apigw_api_gateway_authorizer.id}"
  api_key_required = true
}

# Put Method Integration
resource "aws_api_gateway_integration" "put_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id             = "${aws_api_gateway_resource.put_resource.id}"
  http_method             = "${aws_api_gateway_method.put_method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.put_lambda.invoke_arn}"
  
  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/xml" = <<EOF
{
   "body" : $input.json('$')
}
EOF
  }
}

# Get Resource
resource "aws_api_gateway_resource" "get_resource" {
  path_part   = "get"
  parent_id   = "${aws_api_gateway_rest_api.apigw_api_gateway.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
}

# Get Method
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.get_resource.id}"
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = "${aws_api_gateway_authorizer.apigw_api_gateway_authorizer.id}"
  api_key_required = true
}

# Get Method Integration
resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id             = "${aws_api_gateway_resource.get_resource.id}"
  http_method             = "${aws_api_gateway_method.get_method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.get_lambda.invoke_arn}"
  
  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/xml" = <<EOF
{
   "body" : $input.json('$')
}
EOF
  }
}
