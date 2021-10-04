variable "lightstep_access_token" {
  description = "Lightstep project access token"
  type      = string
  sensitive = true
}

variable "namespace_list" {
  description = "List of namespaces to include in metric stream.  Default: ALL"
  type    = list(string)
  default = []
}

variable "ingest_endpoint" {
  description = "URL of Lightstep ingest"
  type = string
  default = "https://ingest.staging.lightstep.com/cwstream"
}

variable "ingest_endpoint_name" {
  description = "Name of Lightstep ingest"
  type = string
  default = "Lightstep staging"
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
