# Overview:
#
# This Terraform snippet creates the AWS role LightstepAWSIntegrationRole and
# configures the role so that it can be assumed by Lightstep.
# It creates and attaches the policy LightstepAWSIntegrationPolicy, which allows
# reading of EC2 instance data and CloudWatch metrics.
#
# Use:
#
# This snippet is intended to be sent to one of Lightstep's customers. They
# will replace [add id here] with their external id of choice and then run
# `terraform apply`. The customer will then send their TAM:
#   1. The ARN of the newly created LightstepAWSIntegrationRole role
#   2. The external ID chosen, if any
#
# Requirements:
#
#  - AWS CLI tool is installed
#  - AWS credentials are configured locally


resource "aws_iam_role" "lightstep_role" {
  name        = "LightstepAWSIntegrationRole"
  description = "Role that Lightstep will assume as part of CloudWatch integration"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::297975325230:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.external_id}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lightstep_policy" {
  name        = "LightstepAWSIntegrationPolicy"
  description = "Policy associated with LightstepAWSIntegrationRole"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "tag:GetResources",
        "ec2:DescribeRegions"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lightstep_attach" {
  role       = aws_iam_role.lightstep_role.name
  policy_arn = aws_iam_policy.lightstep_policy.arn
}
