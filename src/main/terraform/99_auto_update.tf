
data "archive_file" "latcraft_lambda_updater_zip" {
  type        = "zip"
  source_file = "autoUpdater.js"
  output_path = "autoUpdater.zip"
}

resource "aws_iam_role" "latcraft_lambda_updater" {
  name = "latcraft_lambda_updater"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "latcraft_lambda_updater_bucket_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.auto_update_latcraft_functions.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.latcraft_code.arn}"
}

resource "aws_s3_bucket_notification" "latcraft_code_update_notification" {
  bucket = "${aws_s3_bucket.latcraft_code.id}"
  lambda_function {
    lambda_function_arn = "${aws_lambda_function.auto_update_latcraft_functions.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }
}

resource "aws_lambda_function" "auto_update_latcraft_functions" {
  filename                = "autoUpdater.zip"
  source_code_hash        = "${base64sha256(file("autoUpdater.zip"))}"
  function_name           = "auto_update_latcraft_functions"
  description             = "Update LatCraft Lambda Functions on Code Push to S3 Bucket"
  role                    = "${aws_iam_role.latcraft_lambda_updater.arn}"
  handler                 = "exports.handler"
  runtime                 = "nodejs6.10"
  memory_size             = "128"
  timeout                 = "30"
  depends_on              = [
      "data.archive_file.latcraft_lambda_updater_zip"
  ]
}
