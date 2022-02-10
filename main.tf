terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.42.0"
    }

    random = {
      version = ">= 3.1.0"
    }
  }
  required_version = ">= v1.0.11"
}

data "aws_caller_identity" "current" {}