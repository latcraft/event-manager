#!/usr/bin/env bash

#
# This is an example script on how to call LatCraft API. The following variables have to be defined:
#
# export API_KEY=<ACTUAL API KEY>
# export API_ID=<ACTUAL API ID>
#

curl -v \
--header "x-api-key: $API_KEY" \
-XPOST "https://$API_ID.execute-api.eu-west-1.amazonaws.com/prod/list_event_brite_venues" \
-d @request.json
