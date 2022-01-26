terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.73.0"
    }
  }
  required_version = ">= v1.0.11"
}

provider "aws" {
  region = var.aws_region
}

module "lightstep_cloudwatch_metric_streams" {
  # We recommend referencing a specific tag/ref while using the module
  source = "git::git@github.com:lightstep/aws-cloudwatch-metric-stream-terraform.git?ref=0.0.1"

  lightstep_access_token = var.lightstep_access_token

  # Only send metrics from EC2
  # For additional options, see example.tfvars
  namespace_list = [
    "AWS/EC2",
  ]
}
