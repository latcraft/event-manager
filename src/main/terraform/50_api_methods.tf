
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
          "${aws_lambda_function.publish_cards_function.arn}"
        ]
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "publish_cards_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.publish_cards_function.arn}"
  qualifier               = "${aws_lambda_alias.publish_cards_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPIPublishCards.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPIPublishCards" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "publish_cards"
}

resource "aws_api_gateway_method" "LatCraftAPIPublishCardsPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCards.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPIPublishCardsPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCards.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCardsPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.publish_cards_function.function_name}/invocations"
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishCardsPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCards.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCardsPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPIPublishCardsPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCards.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCardsPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPIPublishCardsPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPIPublishCards.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPIPublishCardsPOST.http_method}"
  status_code             = "200"
}

