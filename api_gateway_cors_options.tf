# CORS OPTIONS Method for Put Endpoint
resource "aws_api_gateway_method" "cors_method_put" {
  rest_api_id   = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.put_resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# CORS Integration for Put Endpoint
resource "aws_api_gateway_integration" "cors_integration_put" {
  rest_api_id = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.put_resource.id}"
  http_method = "${aws_api_gateway_method.cors_method_put.http_method}"
  type                    = "MOCK"
  request_templates = {
    "application/json" = <<EOF
{ "statusCode": 200 }
EOF
  }
}

# CORS Method Response for Put Endpoint
resource "aws_api_gateway_method_response" "cors_method_response_put" {
  rest_api_id = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.put_resource.id}"
  http_method = "${aws_api_gateway_method.cors_method_put.http_method}"

  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# CORS Integration Response for Put Endpoint
resource "aws_api_gateway_integration_response" "cors_integration_response_put" {
  rest_api_id = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id = "${aws_api_gateway_method.cors_method_put.resource_id}"
  http_method = "${aws_api_gateway_method.cors_method_put.http_method}"

  status_code = "${aws_api_gateway_method_response.cors_method_response_put.status_code}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# CORS OPTIONS Method for Get Endpoint
resource "aws_api_gateway_method" "cors_method_get" {
  rest_api_id   = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.get_resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# CORS Integration for Put Endpoint
resource "aws_api_gateway_integration" "cors_integration_get" {
  rest_api_id = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.get_resource.id}"
  http_method = "${aws_api_gateway_method.cors_method_get.http_method}"
  type                    = "MOCK"
  request_templates = {
    "application/json" = <<EOF
{ "statusCode": 200 }
EOF
  }
}

# CORS Method Response for Get Endpoint
resource "aws_api_gateway_method_response" "cors_method_response_get" {
  rest_api_id = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.get_resource.id}"
  http_method = "${aws_api_gateway_method.cors_method_get.http_method}"

  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# CORS Integration Response for Get Endpoint
resource "aws_api_gateway_integration_response" "cors_integration_response_get" {
  rest_api_id = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  resource_id = "${aws_api_gateway_method.cors_method_get.resource_id}"
  http_method = "${aws_api_gateway_method.cors_method_get.http_method}"

  status_code = "${aws_api_gateway_method_response.cors_method_response_get.status_code}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}