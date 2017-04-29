#!/usr/bin/env bash

export AWS_DEFAULT_REGION=eu-west-1

aws kms encrypt --key-id alias/latcraft_kms_key --plaintext fileb://local.properties --output text --query CiphertextBlob > local.properties.encrypted.base64

aws s3 cp ./local.properties.encrypted.base64 s3://latcraft-code
