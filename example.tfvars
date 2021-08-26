#####################
## Common settings ##
##################### 

## REQUIRED - your Lightstep project access token
## See https://docs.lightstep.com/docs/create-and-manage-access-tokens
lightstep_access_token           = "C1alT7VqPFe2qY1IrVVS5jty0f1JEJ1j3iCmQQFb2ZWApEmKAU7odbr9IX23JWTSL0UEmKJ7gbZIznWZHgNV1qlkYQBfV53h+Aj4io2f"


## OPTIONAL - restrict the metric stream to a list of namespaces
## Leaving this empty will include ALL namespaces
namespace_list = [
  # "AWS/ApiGateway",
  # "AWS/Lambda",
  # ...
]


#####################
## Custom settings ##
##################### 

## Endpoints
## ---------

## Staging
# ingest_endpoint_name = "Staging Lightstep ingest"
# ingest_endpoint = "https://ingest.staging.lightstep.com/cwstream"

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