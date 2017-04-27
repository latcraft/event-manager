/*
resource "aws_lambda_permission" "publish_cards_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.publish_cards_function.arn}"
  qualifier               = "${aws_lambda_alias.publish_cards_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  */
#  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.DevTernityAPI.id}/*/POST/ticket"
#}


/*
resource "aws_iam_role" "devternity_api_executor" {
  name                    = "devternity_api_executor"
  assume_role_policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      }
    },
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "devternity_api_executor_policy" {
  name = "devternity_api_executor_policy"
  role = "${aws_iam_role.devternity_api_executor.id}"
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
        "Resource": ["${aws_lambda_function.devternity_ticket_generator.arn}"]
    }
  ]
}
EOF
}

resource "aws_api_gateway_account" "api_gateway" {
  cloudwatch_role_arn = "${aws_iam_role.api_gateway_cloudwatch.arn}"
}

resource "aws_iam_role" "api_gateway_cloudwatch" {
  name = "api_gateway_cloudwatch_global"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "api_gateway_cloudwatch_policy" {
  name = "default"
  role = "${aws_iam_role.api_gateway_cloudwatch.id}"
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
    }
  ]
}
EOF
}

resource "aws_api_gateway_rest_api" "DevTernityAPI" {
  name                    = "DevTernity API"
  description             = "API to support DevTernity automation"
}

resource "aws_api_gateway_resource" "DevTernityAPITicket" {
  rest_api_id             = "${aws_api_gateway_rest_api.DevTernityAPI.id}"
  parent_id               = "${aws_api_gateway_rest_api.DevTernityAPI.root_resource_id}"
  path_part               = "ticket"
}

resource "aws_api_gateway_method" "DevTernityAPITicketPOST" {
  api_key_required        = true
  rest_api_id             = "${aws_api_gateway_rest_api.DevTernityAPI.id}"
  resource_id             = "${aws_api_gateway_resource.DevTernityAPITicket.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "DevTernityAPITicketPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.DevTernityAPI.id}"
  resource_id             = "${aws_api_gateway_resource.DevTernityAPITicket.id}"
  http_method             = "${aws_api_gateway_method.DevTernityAPITicketPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.devternity_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:devternity_ticket_generator/invocations"
}

resource "aws_api_gateway_method_response" "DevTernityAPITicketPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.DevTernityAPI.id}"
  resource_id             = "${aws_api_gateway_resource.DevTernityAPITicket.id}"
  http_method             = "${aws_api_gateway_method.DevTernityAPITicketPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "DevTernityAPITicketPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.DevTernityAPI.id}"
  resource_id             = "${aws_api_gateway_resource.DevTernityAPITicket.id}"
  http_method             = "${aws_api_gateway_method.DevTernityAPITicketPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "DevTernityAPITicketPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.DevTernityAPI.id}"
  resource_id             = "${aws_api_gateway_resource.DevTernityAPITicket.id}"
  http_method             = "${aws_api_gateway_method.DevTernityAPITicketPOST.http_method}"
  status_code             = "200"
}

resource "aws_api_gateway_api_key" "DevTernityAPIKey" {
  name                    = "devternity_api_key"
  description             = "Default DevTernity API key"
  stage_key {
    rest_api_id           = "${aws_api_gateway_rest_api.DevTernityAPI.id}"
    stage_name            = "${aws_api_gateway_deployment.DevTernityAPIDeployment.stage_name}"
  }
}

resource "aws_api_gateway_deployment" "DevTernityAPIDeployment" {
  rest_api_id             = "${aws_api_gateway_rest_api.DevTernityAPI.id}"
  stage_name              = "prod"
}
*/