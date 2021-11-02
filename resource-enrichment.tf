# Overview:
#
# This Terraform snippet creates the AWS role LightstepAWSIntegrationRole and
# configures the role so that it can be assumed by Lightstep.
# It creates and attaches the policy LightstepAWSIntegrationPolicy, which allows
# reading of EC2 instance data and CloudWatch metrics.


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
