# Overview:
#
# This Terraform snippet creates the AWS role LightstepAWSIntegrationRole and
# configures the role so that it can be assumed by Lightstep.
# It creates and attaches the policy LightstepAWSIntegrationPolicy, which allows
# reading of EC2 instance data and CloudWatch metrics.
#
# This file does not need to run if the customer has previously set up Lightstep's AWS integration 
# prior to the release of the Metric Streams integration. 
# Please set the `upgrade_to_streams` variable to `true` before applying this terraform.


resource "random_string" "external_id" {
  length           = 8
  special          = true
  override_special = "_=,.@:/-"
}

data "aws_iam_policy_document" "lightstep_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::297975325230:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        "${random_string.external_id.result}",
      ]
    }
  }
}

resource "aws_iam_role" "lightstep_role" {
  count       = var.upgrade_to_streams ? 0 : 1
  name        = "LightstepAWSIntegrationRole"
  description = "Role that Lightstep will assume as part of CloudWatch integration"

  assume_role_policy = data.aws_iam_policy_document.lightstep_assume_role_policy.json
}

resource "aws_iam_policy" "lightstep_policy" {
  count       = var.upgrade_to_streams ? 0 : 1
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
  count      = var.upgrade_to_streams ? 0 : 1
  role       = aws_iam_role.lightstep_role[0].name
  policy_arn = aws_iam_policy.lightstep_policy[0].arn
}
