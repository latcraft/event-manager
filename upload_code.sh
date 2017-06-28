#!/usr/bin/env bash

export AWS_DEFAULT_REGION=eu-west-1

./gradlew clean build

aws s3 cp ./build/distributions/*.zip s3://latcraft-code/event-manager.zip

aws lambda update-function-code --function-name copy_contacts_from_event_brite_to_send_grid_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name create_new_event_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name get_stats_from_event_brite_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name list_event_brite_venues_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name list_suppressed_emails_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name publish_campaign_on_send_grid_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name publish_cards_on_s3_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name publish_event_on_event_brite_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name publish_event_on_lanyrd_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name publish_event_on_twitter_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name send_campaign_on_send_grid_function --s3-bucket latcraft-code --s3-key event-manager.zip
aws lambda update-function-code --function-name craftbot_function --s3-bucket latcraft-code --s3-key event-manager.zip
