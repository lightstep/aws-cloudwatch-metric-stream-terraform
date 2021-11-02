variable "lightstep_access_token" {
  description = "Lightstep project access token"
  type      = string
  sensitive = true
}

variable "external_id" {
  description = "A randomly generated alphabetical string used to autheticate between Lightstep and your AWS account. Default: <empty>"
  type    = string
  default = ""
}

variable "namespace_list" {
  description = "List of namespaces to include in metric stream.  Default: ALL"
  type    = list(string)
  default = []
}

variable "ingest_endpoint" {
  description = "URL of Lightstep ingest"
  type = string
  default = "https://ingest.lightstep.com/cwstream"
}

variable "ingest_endpoint_name" {
  description = "Name of Lightstep ingest"
  type = string
  default = "Lightstep ingest"
}

variable "buffer_size" {
  description = "Size of metric data (MiB) to accumulate before flushing to Lighstep ingest."
  type      = number
  default   = 5

   validation {
    condition     = var.buffer_size >= 1 && var.buffer_size <= 128
    error_message = "Buffer size must be between 1 and 128 MB."
  }
}

variable "buffer_interval" {
  description = "Time to wait (seconds) before flushing to Lighstep ingest."
  type      = number
  default   = 300

  validation {
    condition     = var.buffer_interval >= 60 && var.buffer_interval <= 900
    error_message = "Buffer interval must be between 60 and 900 seconds."
  }
}

variable "metric_stream_name" {
  type      = string
  default   = "lightstep"
}

variable "firehose_name" {
  type      = string
  default   = "lightstep"
}

variable "aws_region" {
  description = "The AWS region associated with your CloudWatch metric stream and Kinesis firehose"
  type        = string
  default     = "us-west-2"
}

variable "expiration_days" {
  description = "How many days to keep failed requests in S3"
  type = number
  default = 90
}

variable "upgrade_to_streams" {
  description = "Set to true if you are upgrading from our previous AWS integration to our Metric Streams integration. Otherwise you may see errors relating to policies already existing."
  type = bool
  default = false
}
