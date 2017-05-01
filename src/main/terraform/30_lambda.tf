
resource "aws_lambda_function" "publish_cards_function" {
  s3_bucket               = "${aws_s3_bucket.latcraft_code.bucket}"
  s3_key                  = "event-manager.zip"
  function_name           = "publish_cards_function"
  description             = "Publish LatCraft Event Cards on S3"
  role                    = "${aws_iam_role.latcraft_lambda_executor.arn}"
  handler                 = "${var.lambda_code_package_prefix}.PublishCardsOnS3::${var.lambda_code_default_method}"
  runtime                 = "java8"
  memory_size             = "512"
  timeout                 = "300"
  kms_key_arn             = "${aws_kms_key.latcraft_kms_key.arn}"
  environment {
    variables = {
      HOME                = "/var/tasks"
      JAVA_FONTS          = "/var/tasks/fonts"
    }
  }
}

resource "aws_lambda_alias" "publish_cards_function_alias" {
  name                    = "publish_cards_function_latest"
  function_name           = "${aws_lambda_function.publish_cards_function.arn}"
  function_version        = "$LATEST"
}

