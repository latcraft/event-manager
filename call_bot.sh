#!/usr/bin/env bash

#
# This is an example script on how to call CraftBot API. The following variables have to be defined:
#
# export COMMAND_SECRET=<ACTUAL COMMAND SECRET>
# export API_ID=<ACTUAL API ID>
#

curl -v \
--data "token=$COMMAND_SECRET&text=help" \
--header "Content-Type:application/x-www-form-urlencoded" \
-XPOST "https://$API_ID.execute-api.eu-west-1.amazonaws.com/prod/craftbot"

