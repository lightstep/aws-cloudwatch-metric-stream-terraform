



resource "aws_cloudwatch_metric_stream" "main" {
  name          = var.metric_stream_name
  role_arn      = aws_iam_role.lightstep_metric_stream.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.lightstep.arn
  output_format = "opentelemetry0.7"

  dynamic "include_filter" {
    for_each = var.namespace_list
    iterator = item

    content {
      namespace = item.value
    }
  }
}


resource "aws_iam_role" "lightstep_metric_stream" {
  name               = "${var.metric_stream_name}-metric-stream"
  assume_role_policy = data.aws_iam_policy_document.lightstep_metric_stream_assume.json
}

data "aws_iam_policy_document" "lightstep_metric_stream_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy" "lightstep_metric_stream_firehose" {
  name   = "firehose"
  policy = data.aws_iam_policy_document.lightstep_metric_stream_firehose.json
  role   = aws_iam_role.lightstep_metric_stream.id
}

data "aws_iam_policy_document" "lightstep_metric_stream_firehose" {
  statement {
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch",
    ]

    resources = [aws_kinesis_firehose_delivery_stream.lightstep.arn]
  }
}



resource "aws_kinesis_firehose_delivery_stream" "lightstep" {
  name        = var.firehose_name
  destination = "http_endpoint"

  http_endpoint_configuration {
    url                = var.ingest_endpoint
    name               = var.ingest_endpoint_name
    access_key         = var.lightstep_access_token
    buffering_size     = var.buffer_size
    buffering_interval = var.buffer_interval
    retry_duration     = var.buffer_interval
    role_arn           = aws_iam_role.lightstep_firehose.arn
    s3_backup_mode     = "FailedDataOnly"

    processing_configuration {
      enabled = false
    }

    request_configuration {
      content_encoding = "GZIP"
    }

    cloudwatch_logging_options {
      enabled = false
    }
  }

  s3_configuration {
    bucket_arn      = aws_s3_bucket.lightstep_firehose_backup.arn
    buffer_interval = var.buffer_interval
    buffer_size     = var.buffer_size
    prefix          = "metrics/"
    role_arn        = aws_iam_role.lightstep_firehose.arn

    cloudwatch_logging_options {
      enabled = false
    }
  }

  server_side_encryption {
    enabled = false
  }
  
}


resource "aws_iam_role" "lightstep_firehose" {
  name               = "${var.firehose_name}-firehose"
  assume_role_policy = data.aws_iam_policy_document.lightstep_firehose_assume.json
}

data "aws_iam_policy_document" "lightstep_firehose_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["firehose.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy" "lightstep_firehose_s3_backup" {
  name   = "${var.firehose_name}-firehose-s3-backup"
  policy = data.aws_iam_policy_document.lightstep_firehose_s3_backup.json
  role   = aws_iam_role.lightstep_firehose.id
}

data "aws_iam_policy_document" "lightstep_firehose_s3_backup" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
    ]

    resources = [aws_s3_bucket.lightstep_firehose_backup.arn]
  }

  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = ["${aws_s3_bucket.lightstep_firehose_backup.arn}/*"]
  }
}

## Kinesis Firehose - S3 error/backup bucket
resource "aws_s3_bucket" "lightstep_firehose_backup" {
  bucket = "${var.firehose_name}-firehose-s3-backup-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
  lifecycle_rule {
    id      = "expiration"
    enabled = true

    expiration {
        days = var.expiration_days
    }
  }
}

## no public access allowed to the backup bucket
resource "aws_s3_bucket_public_access_block" "backup_bucket_no_public_access" {
  bucket = "${aws_s3_bucket.lightstep_firehose_backup.id}"
  block_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}


## roles required for resource enrichment service

