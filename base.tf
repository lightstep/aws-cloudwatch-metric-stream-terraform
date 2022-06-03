terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.42.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # If required, you can assume a role with sufficient permissions to create the metric stream
  # assume_role {
  #  role_arn = "arn:aws:iam::<ACCOUNTID>:role/<ROLE-NAME>"
  # }
}

data "aws_caller_identity" "current" {}
