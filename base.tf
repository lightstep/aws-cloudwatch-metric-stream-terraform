terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.42.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}