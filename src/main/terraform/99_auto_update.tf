
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

resource "aws_iam_role_policy" "latcraft_lambda_updater_policy" {
  name                  = "latcraft_lambda_updater_policy"
  role                  = "${aws_iam_role.latcraft_lambda_updater.id}"
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
      "Action": [
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "s3:ListBucket"
      ],
      "Resource": [
          "${aws_s3_bucket.latcraft_code.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectAcl"
      ],
      "Resource": [
          "${aws_s3_bucket.latcraft_code.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "latcraft_lambda_updater_bucket_permission" {
  statement_id            = "AllowExecutionFromS3Bucket"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.auto_update_latcraft_functions.arn}"
  principal               = "s3.amazonaws.com"
  source_arn              = "${aws_s3_bucket.latcraft_code.arn}"
}

resource "aws_lambda_function" "auto_update_latcraft_functions" {
  filename                = "autoUpdater.zip"
  source_code_hash        = "${base64sha256(file("autoUpdater.zip"))}"
  function_name           = "auto_update_latcraft_functions"
  description             = "Update LatCraft Lambda Functions on Code Push to S3 Bucket"
  role                    = "${aws_iam_role.latcraft_lambda_updater.arn}"
  handler                 = "autoUpdater.handler"
  runtime                 = "nodejs6.10"
  memory_size             = "128"
  timeout                 = "30"
  depends_on              = [
      "data.archive_file.latcraft_lambda_updater_zip"
  ]
}
