# aws-cloudwatch-metric-stream-terraform

Terraform module which creates AWS Cloudwatch Metric Streams to forward data to [Lightstep](https://lioghtstep.com).

## Prerequisites
1. [Terraform v1.0+](https://learn.hashicorp.com/tutorials/terraform/install-cli)
1. A Lightstep project [access token](https://docs.lightstep.com/docs/create-and-manage-access-tokens)
1. AWS Access Key/Secret with IAM permissions to create the following resources:
    * aws_cloudwatch_metric_stream 
    * aws_iam_role
    * aws_iam_role_policy
    * aws_kinesis_firehose_delivery_stream
    * aws_s3_bucket
    * aws_s3_bucket_public_access_block

## Usage

### Default

Add the following module to an existing terraform file. For a full example, see the [`examples/`](https://github.com/lightstep/aws-cloudwatch-metric-stream-terraform/tree/main/examples) directory.

```hcl
module "lightstep_cloudwatch_metric_streams" {
  source  = "git::git@github.com:lightstep/aws-cloudwatch-metric-stream-terraform.git?ref=main"
  lightstep_access_token = var.lightstep_access_token
  # For additional configuration options, see example.tfvars
}
```

Run `terraform init` to install the module and `terraform apply` to apply changes and create AWS CloudWatch Metrics streams to send data to Lightstep.

It may take up to 15 minutes for data to appear in your Lightstep project depending on your chosen values for `buffer_interval` (default: 5 min) and `buffer_size` (default: 5 Mib).

### Options
All options are documented in `variables.tf` and `example.tfvars`

### Development

This repository uses `pre-commit` to automatically format and lint code before commits.

To configure this git repository:

```
    # install pre-commit (Mac OS X)
    $ brew install pre-commit

    # install hooks in this repository
    $ pre-commit install
```