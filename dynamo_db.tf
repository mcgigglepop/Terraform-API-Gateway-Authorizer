# Dynamo Database Resource
resource "aws_dynamodb_table" "apigw_dynamodb_table" {
  name           ="${var.SERVICE}-${var.STAGE}-apigw-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "uuid"

  attribute {
    name = "uuid"
    type = "S"
  }
}