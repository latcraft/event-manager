
resource "aws_lambda_function" "craftbot_function" {
  s3_bucket               = "${aws_s3_bucket.latcraft_code.bucket}"
  s3_key                  = "event-manager.zip"
  function_name           = "craftbot_function"
  description             = "CraftBot"
  role                    = "${aws_iam_role.latcraft_lambda_executor.arn}"
  handler                 = "${var.lambda_code_package_prefix}.router.CraftBotCommands::${var.lambda_code_default_method}"
  runtime                 = "java8"
  memory_size             = "512"
  timeout                 = "300"
  kms_key_arn             = "${aws_kms_key.latcraft_kms_key.arn}"
  environment {
    variables = {
      HOME                = "/var/task"
      JAVA_FONTS          = "/var/task/fonts"
    }
  }
}

resource "aws_lambda_alias" "craftbot_function_alias" {
  name                    = "craftbot_function_latest"
  function_name           = "${aws_lambda_function.craftbot_function.arn}"
  function_version        = "$LATEST"
}

resource "aws_cloudwatch_event_rule" "craftbot_warm_up" {
  name        = "craftbot_warm_up"
  description = "Ping CraftBot to keep it warm"
  schedule_expression = "rate(15 minutes)"
}

resource "aws_cloudwatch_event_target" "craftbot_warm_up" {
  rule      = "${aws_cloudwatch_event_rule.craftbot_warm_up.name}"
  target_id = "craftbot_warm_up"
  arn       = "${aws_lambda_function.craftbot_function.arn}"
  input     = <<INPUT
{
  "ping": "true"
}
INPUT
}
