# aws-cloudwatch-metric-stream-terraform


## Prerequisites
1. A Lightstep project access token
1. AWS Access Key/Secret with IAM permissions to create the following resources:
    * aws_cloudwatch_metric_stream 
    * aws_iam_role
    * aws_iam_role_policy
    * aws_kinesis_firehose_delivery_stream
    * aws_s3_bucket
    * aws_s3_bucket_public_access_block
## Installation

```BASH
% git clone git@github.com:lightstep/aws-cloudwatch-metric-stream-terraform.git
% cd aws-cloudwatch-metric-stream-terraform

% export AWS_ACCESS_KEY_ID=<access-key-id>
% export AWS_SECRET_ACCESS_KEY=<secret-access-key>
% terraform init
# Enter your Lightstep project access token when prompted
% terraform apply
var.lightstep_access_token
  Lightstep project access token

  Enter a value: 



# The above is the minimal install with default values.
# For custom install, edit example.tfvars.  Then run:
% terraform apply -var-file="example.tfvars"
```

It may take up to 15 minutes for data to appear in your Lightstep project depending on your chosen values for `buffer_interval` (default: 5 min) and `buffer_size` (default: 5 Mib).

## Options
All options are documented in `variables.tf` and `example.tfvars`