#!/usr/bin/env bash

aws lambda invoke \
--invocation-type RequestResponse \
--function-name publish_cards_on_s3_function \
--region eu-west-1 \
--log-type Tail \
--payload file://request.json \
response.json
