#!/usr/bin/env bash

export AWS_DEFAULT_REGION=eu-west-1

./gradlew clean build

aws s3 cp ./build/distributions/*.zip s3://latcraft-code/event-manager.zip

aws lambda update-function-code --function-name publish_cards_function --s3-bucket latcraft-code --s3-key event-manager.zip
