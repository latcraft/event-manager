
resource "aws_lambda_permission" "craftbot_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.craftbot_function.arn}"
  qualifier               = "${aws_lambda_alias.craftbot_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPICraftBot.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPICraftBot" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "craftbot"
}

resource "aws_api_gateway_method" "LatCraftAPICraftBotPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICraftBot.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPICraftBotPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICraftBot.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICraftBotPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.craftbot_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPICraftBotPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICraftBot.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICraftBotPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPICraftBotPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICraftBot.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICraftBotPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPICraftBotPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICraftBot.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICraftBotPOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPICraftBotPOSTIntegration"
  ]
}
