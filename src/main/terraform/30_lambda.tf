
resource "aws_lambda_function" "publish_cards_function" {
  s3_bucket               = "${aws_s3_bucket.latcraft_code.arn}"
  function_name           = "publish_cards_function"
  description             = "Publish LatCraft Event Cards on S3"
  role                    = "${aws_iam_role.latcraft_lambda_executor.arn}"
  handler                 = "lv.latcraft.devternity.tickets.TicketGenerator::generate"
  runtime                 = "java8"
  memory_size             = "512"
  timeout                 = "300"
}

resource "aws_lambda_alias" "publish_cards_function_alias" {
  name                    = "publish_cards_function_latest"
  function_name           = "${aws_lambda_function.publish_cards_function.arn}"
  function_version        = "$LATEST"
}

resource "aws_lambda_permission" "devternity_ticket_generator_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.devternity_ticket_generator.arn}"
  qualifier               = "${aws_lambda_alias.devternity_ticket_generator_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.DevTernityAPI.id}/*/POST/ticket"
}

// TODO: add all lambda functions
