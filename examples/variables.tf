variable "aws_region" {
  description = "The AWS region associated with your CloudWatch metric stream and Kinesis firehose"
  type        = string
  default     = "us-east-1"
}

variable "lightstep_access_token" {
  description = "Lightstep project access token (note: this is *not* an API Key)"
  type        = string
  sensitive   = true
}