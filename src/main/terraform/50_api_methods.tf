

resource "aws_iam_role_policy" "latcraft_api_executor_policy" {
  name = "latcraft_api_executor_policy"
  role = "${aws_iam_role.latcraft_api_executor.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
      ],
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "lambda:InvokeFunction"
        ],
        "Resource": [
          "${aws_lambda_function.copy_contacts_from_event_brite_to_send_grid_function.arn}", "${aws_lambda_function.create_new_event_function.arn}", "${aws_lambda_function.get_stats_from_event_brite_function.arn}", "${aws_lambda_function.list_event_brite_venues_function.arn}", "${aws_lambda_function.list_suppressed_emails_function.arn}", "${aws_lambda_function.publish_campaign_on_send_grid_function.arn}", "${aws_lambda_function.publish_cards_on_s3_function.arn}", "${aws_lambda_function.publish_event_on_event_brite_function.arn}", "${aws_lambda_function.publish_event_on_lanyrd_function.arn}", "${aws_lambda_function.publish_event_on_twitter_function.arn}", "${aws_lambda_function.send_campaign_on_send_grid_function.arn}", "${aws_lambda_function.craftbot_function.arn}"  
        ]
    }
  ]
}
EOF
}


resource "aws_lambda_permission" "copy_contacts_from_event_brite_to_send_grid_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.copy_contacts_from_event_brite_to_send_grid_function.arn}"
  qualifier               = "${aws_lambda_alias.copy_contacts_from_event_brite_to_send_grid_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPICopyContactsFromEventBriteToSendGrid.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPICopyContactsFromEventBriteToSendGrid" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "copy_contacts_from_event_brite_to_send_grid"
}

resource "aws_api_gateway_method" "LatCraftAPICopyContactsFromEventBriteToSendGridPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICopyContactsFromEventBriteToSendGrid.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPICopyContactsFromEventBriteToSendGridPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICopyContactsFromEventBriteToSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICopyContactsFromEventBriteToSendGridPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.copy_contacts_from_event_brite_to_send_grid_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPICopyContactsFromEventBriteToSendGridPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICopyContactsFromEventBriteToSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICopyContactsFromEventBriteToSendGridPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPICopyContactsFromEventBriteToSendGridPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICopyContactsFromEventBriteToSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICopyContactsFromEventBriteToSendGridPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPICopyContactsFromEventBriteToSendGridPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICopyContactsFromEventBriteToSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICopyContactsFromEventBriteToSendGridPOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPICopyContactsFromEventBriteToSendGridPOSTIntegration"
  ]  
}


resource "aws_lambda_permission" "create_new_event_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.create_new_event_function.arn}"
  qualifier               = "${aws_lambda_alias.create_new_event_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPICreateNewEvent.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPICreateNewEvent" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "create_new_event"
}

resource "aws_api_gateway_method" "LatCraftAPICreateNewEventPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICreateNewEvent.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPICreateNewEventPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICreateNewEvent.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICreateNewEventPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.create_new_event_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPICreateNewEventPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICreateNewEvent.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICreateNewEventPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPICreateNewEventPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICreateNewEvent.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICreateNewEventPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPICreateNewEventPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICreateNewEvent.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICreateNewEventPOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPICreateNewEventPOSTIntegration"
  ]  
}


resource "aws_lambda_permission" "get_stats_from_event_brite_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.get_stats_from_event_brite_function.arn}"
  qualifier               = "${aws_lambda_alias.get_stats_from_event_brite_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPIGetStatsFromEventBrite.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPIGetStatsFromEventBrite" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "get_stats_from_event_brite"
}

resource "aws_api_gateway_method" "LatCraftAPIGetStatsFromEventBritePOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIGetStatsFromEventBrite.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPIGetStatsFromEventBritePOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIGetStatsFromEventBrite.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIGetStatsFromEventBritePOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.get_stats_from_event_brite_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPIGetStatsFromEventBritePOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIGetStatsFromEventBrite.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIGetStatsFromEventBritePOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPIGetStatsFromEventBritePOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIGetStatsFromEventBrite.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIGetStatsFromEventBritePOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPIGetStatsFromEventBritePOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIGetStatsFromEventBrite.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIGetStatsFromEventBritePOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPIGetStatsFromEventBritePOSTIntegration"
  ]  
}


resource "aws_lambda_permission" "list_event_brite_venues_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.list_event_brite_venues_function.arn}"
  qualifier               = "${aws_lambda_alias.list_event_brite_venues_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPIListEventBriteVenues.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPIListEventBriteVenues" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "list_event_brite_venues"
}

resource "aws_api_gateway_method" "LatCraftAPIListEventBriteVenuesPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIListEventBriteVenues.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPIListEventBriteVenuesPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIListEventBriteVenues.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIListEventBriteVenuesPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.list_event_brite_venues_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPIListEventBriteVenuesPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIListEventBriteVenues.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIListEventBriteVenuesPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPIListEventBriteVenuesPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIListEventBriteVenues.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIListEventBriteVenuesPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPIListEventBriteVenuesPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIListEventBriteVenues.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIListEventBriteVenuesPOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPIListEventBriteVenuesPOSTIntegration"
  ]  
}


resource "aws_lambda_permission" "list_suppressed_emails_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.list_suppressed_emails_function.arn}"
  qualifier               = "${aws_lambda_alias.list_suppressed_emails_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPIListSuppressedEmails.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPIListSuppressedEmails" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "list_suppressed_emails"
}

resource "aws_api_gateway_method" "LatCraftAPIListSuppressedEmailsPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIListSuppressedEmails.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPIListSuppressedEmailsPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIListSuppressedEmails.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIListSuppressedEmailsPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.list_suppressed_emails_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPIListSuppressedEmailsPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIListSuppressedEmails.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIListSuppressedEmailsPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPIListSuppressedEmailsPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIListSuppressedEmails.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIListSuppressedEmailsPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPIListSuppressedEmailsPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIListSuppressedEmails.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIListSuppressedEmailsPOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPIListSuppressedEmailsPOSTIntegration"
  ]  
}


resource "aws_lambda_permission" "publish_campaign_on_send_grid_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.publish_campaign_on_send_grid_function.arn}"
  qualifier               = "${aws_lambda_alias.publish_campaign_on_send_grid_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPIPublishCampaignOnSendGrid.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPIPublishCampaignOnSendGrid" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "publish_campaign_on_send_grid"
}

resource "aws_api_gateway_method" "LatCraftAPIPublishCampaignOnSendGridPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCampaignOnSendGrid.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPIPublishCampaignOnSendGridPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCampaignOnSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCampaignOnSendGridPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.publish_campaign_on_send_grid_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishCampaignOnSendGridPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCampaignOnSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCampaignOnSendGridPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishCampaignOnSendGridPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCampaignOnSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCampaignOnSendGridPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPIPublishCampaignOnSendGridPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCampaignOnSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCampaignOnSendGridPOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPIPublishCampaignOnSendGridPOSTIntegration"
  ]  
}


resource "aws_lambda_permission" "publish_cards_on_s3_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.publish_cards_on_s3_function.arn}"
  qualifier               = "${aws_lambda_alias.publish_cards_on_s3_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPIPublishCardsOnS3.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPIPublishCardsOnS3" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "publish_cards_on_s3"
}

resource "aws_api_gateway_method" "LatCraftAPIPublishCardsOnS3POST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCardsOnS3.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPIPublishCardsOnS3POSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCardsOnS3.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCardsOnS3POST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.publish_cards_on_s3_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishCardsOnS3POSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCardsOnS3.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCardsOnS3POST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishCardsOnS3POSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCardsOnS3.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCardsOnS3POST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPIPublishCardsOnS3POSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCardsOnS3.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCardsOnS3POST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPIPublishCardsOnS3POSTIntegration"
  ]  
}


resource "aws_lambda_permission" "publish_event_on_event_brite_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.publish_event_on_event_brite_function.arn}"
  qualifier               = "${aws_lambda_alias.publish_event_on_event_brite_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPIPublishEventOnEventBrite.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPIPublishEventOnEventBrite" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "publish_event_on_event_brite"
}

resource "aws_api_gateway_method" "LatCraftAPIPublishEventOnEventBritePOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnEventBrite.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPIPublishEventOnEventBritePOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnEventBrite.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnEventBritePOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.publish_event_on_event_brite_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishEventOnEventBritePOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnEventBrite.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnEventBritePOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishEventOnEventBritePOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnEventBrite.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnEventBritePOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPIPublishEventOnEventBritePOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnEventBrite.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnEventBritePOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPIPublishEventOnEventBritePOSTIntegration"
  ]  
}


resource "aws_lambda_permission" "publish_event_on_lanyrd_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.publish_event_on_lanyrd_function.arn}"
  qualifier               = "${aws_lambda_alias.publish_event_on_lanyrd_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPIPublishEventOnLanyrd.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPIPublishEventOnLanyrd" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "publish_event_on_lanyrd"
}

resource "aws_api_gateway_method" "LatCraftAPIPublishEventOnLanyrdPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnLanyrd.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPIPublishEventOnLanyrdPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnLanyrd.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnLanyrdPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.publish_event_on_lanyrd_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishEventOnLanyrdPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnLanyrd.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnLanyrdPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishEventOnLanyrdPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnLanyrd.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnLanyrdPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPIPublishEventOnLanyrdPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnLanyrd.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnLanyrdPOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPIPublishEventOnLanyrdPOSTIntegration"
  ]  
}


resource "aws_lambda_permission" "publish_event_on_twitter_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.publish_event_on_twitter_function.arn}"
  qualifier               = "${aws_lambda_alias.publish_event_on_twitter_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPIPublishEventOnTwitter.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPIPublishEventOnTwitter" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "publish_event_on_twitter"
}

resource "aws_api_gateway_method" "LatCraftAPIPublishEventOnTwitterPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnTwitter.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPIPublishEventOnTwitterPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnTwitter.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnTwitterPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.publish_event_on_twitter_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishEventOnTwitterPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnTwitter.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnTwitterPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishEventOnTwitterPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnTwitter.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnTwitterPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPIPublishEventOnTwitterPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishEventOnTwitter.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishEventOnTwitterPOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPIPublishEventOnTwitterPOSTIntegration"
  ]  
}


resource "aws_lambda_permission" "send_campaign_on_send_grid_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.send_campaign_on_send_grid_function.arn}"
  qualifier               = "${aws_lambda_alias.send_campaign_on_send_grid_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPISendCampaignOnSendGrid.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPISendCampaignOnSendGrid" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "send_campaign_on_send_grid"
}

resource "aws_api_gateway_method" "LatCraftAPISendCampaignOnSendGridPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPISendCampaignOnSendGrid.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPISendCampaignOnSendGridPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPISendCampaignOnSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPISendCampaignOnSendGridPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.send_campaign_on_send_grid_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPISendCampaignOnSendGridPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPISendCampaignOnSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPISendCampaignOnSendGridPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPISendCampaignOnSendGridPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPISendCampaignOnSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPISendCampaignOnSendGridPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPISendCampaignOnSendGridPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPISendCampaignOnSendGrid.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPISendCampaignOnSendGridPOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPISendCampaignOnSendGridPOSTIntegration"
  ]  
}

