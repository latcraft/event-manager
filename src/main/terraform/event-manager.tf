
provider "aws" {
  region                  = "${var.aws_region}"
}

variable "latcraft_function_dist" {
  default = "../../../build/distributions/event-manager.zip"
}

resource "aws_s3_bucket" "latcraft_code" {
  bucket                  = "latcraft-code"
  acl                     = "private"
}

resource "aws_s3_bucket" "latcraft_images" {
  bucket                  = "latcraft-images"
  acl                     = "private"
}


//    _                 _         _
//   | |               | |       | |
//   | | __ _ _ __ ___ | |__   __| | __ _
//   | |/ _` | '_ ` _ \| '_ \ / _` |/ _` |
//   | | (_| | | | | | | |_) | (_| | (_| |
//   |_|\__,_|_| |_| |_|_.__/ \__,_|\__,_|
//
//

resource "aws_iam_role" "latcraft_lambda_executor" {
  name                    = "latcraft_lambda_executor"
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

resource "aws_iam_role_policy" "latcraft_lambda_executor_policy" {
    name                  = "devternity_lambda_executor_policy"
    role                  = "${aws_iam_role.latcraft_lambda_executor.id}"
    policy                = <<EOF
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
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.latcraft_images.arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:GetObjectAcl"
      ],
      "Resource": ["${aws_s3_bucket.latcraft_images.arn}/*"]
    }
  ]
}
EOF
}

resource "aws_lambda_function" "publish_cards_function" {
  s3_bucket               = "${aws_s3_bucket.latcraft_code.arn}"
  function_name           = "publish_cards_function"
  description             = "DevTernity ticket generator"
  role                    = "${aws_iam_role.latcraft_lambda_executor.arn}"
  handler                 = "lv.latcraft.devternity.tickets.TicketGenerator::generate"
  runtime                 = "java8"
  memory_size             = "512"
  timeout                 = "300"
  source_code_hash        = "${base64sha256(file(var.devternity_function_dist))}"
}

resource "aws_lambda_alias" "devternity_ticket_generator_alias" {
  name                    = "devternity_ticket_generator_latest"
  function_name           = "${aws_lambda_function.devternity_ticket_generator.arn}"
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

//                _               _
//               (_)             | |
//     __ _ _ __  _    __ _  __ _| |_ _____      ____ _ _   _
//    / _` | '_ \| |  / _` |/ _` | __/ _ \ \ /\ / / _` | | | |
//   | (_| | |_) | | | (_| | (_| | ||  __/\ V  V / (_| | |_| |
//    \__,_| .__/|_|  \__, |\__,_|\__\___| \_/\_/ \__,_|\__, |
//         | |         __/ |                             __/ |
//         |_|        |___/                             |___/
//

// TODO: add API gateway entry points
