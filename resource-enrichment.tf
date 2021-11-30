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



# Default policy when no external id is provided
data "aws_iam_policy_document" "lightstep_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::297975325230:root"]
    }
  }
}


# When an external id is provided, we configure a condition on role assumption
data "aws_iam_policy_document" "lightstep_assume_role_policy_with_xid" {
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
        "${var.external_id}",
      ]
    }
  }
}

resource "aws_iam_role" "lightstep_role" {
  count       = var.upgrade_to_streams ? 0 : 1
  name        = "LightstepAWSIntegrationRole"
  description = "Role that Lightstep will assume as part of CloudWatch integration"

  assume_role_policy = var.external_id == "" ? data.aws_iam_policy_document.lightstep_assume_role_policy.json : data.aws_iam_policy_document.lightstep_assume_role_policy_with_xid.json
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
