#!/usr/bin/env bash

aws lambda invoke --invocation-type RequestResponse --function-name auto_update_latcraft_functions --region eu-west-1 --log-type Tail --payload '{"functions": ["publish_cards_function"]}' update_response.txt
