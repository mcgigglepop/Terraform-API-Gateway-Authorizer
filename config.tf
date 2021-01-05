# TF Provider
provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile = "default"    
}

# AWS Caller Identity
data "aws_caller_identity" "current" {}


# Terraform Backend State
terraform {
    backend "s3" {
        profile = "default"
        bucket  = "apigw-dev-tf-artifacts"
        key     = "terraform-states/sls-deployers/apigw-config.tfstate"
        region  = "us-east-1"
    }
}