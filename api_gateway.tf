# API Gateway domain base path mapping
resource "aws_api_gateway_base_path_mapping" "apigw_base_path" {
  api_id      = "${aws_api_gateway_rest_api.apigw_api_gateway.id}"
  domain_name = "${var.STAGE_DOMAIN_URL}"
  stage_name  = "${var.SERVICE}"
  base_path   = "${var.SERVICE}"
}