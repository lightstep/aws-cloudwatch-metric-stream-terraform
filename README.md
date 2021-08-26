# aws-cloudwatch-metric-stream-terraform

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

## Options
All options are documented in `variables.tf` and `example.tfvars`