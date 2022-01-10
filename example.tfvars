#####################
## Common settings ##
##################### 

## REQUIRED - your Lightstep project access token
## See https://docs.lightstep.com/docs/create-and-manage-access-tokens
lightstep_access_token           = "<lightstep-access-token-here>"


## OPTIONAL - restrict the metric stream to a list of namespaces
## Leaving this empty will include ALL namespaces
namespace_list = [
  "AWS/ApiGateway",
  "AWS/Lambda",
  # ...
]

## OPTIONAL - select your AWS region
## The AWS region associated with your CloudWatch metric stream and Kinesis firehose,
## if not the default (us-west-2).
# aws_region = "us-west-2"


#####################
## Custom settings ##
##################### 

## Expiration
# expiration_days = 90


## performance levers
## ------------------

## Size of data (MiB) to accumulate before flushing to Lightstep ingest.
## The higher buffer size may be lower in cost with higher latency. 
## The lower buffer size will be faster in delivery with higher cost and less latency.
## Minimum: 1 MiB, maximum: 128 MiB. Recommended: 5 MiB.
# buffer_size = 1

## Time to wait (seconds) before flushing to Lighstep ingest.
## The higher interval allows more time to collect data and the size of data may be bigger. 
## The lower interval sends the data more frequently and may be more advantageous when looking at shorter cycles of data activity.
## Minimum: 60 seconds, maximum: 900 seconds. Recommended: 300 seconds.
# buffer_interval = 60


## naming
## ------

## Change the name of the metric stream if desired
# metric_stream_name = "lightstep"

## Change the name of the delivery firehose if desired
# firehose_name = "lightstep"