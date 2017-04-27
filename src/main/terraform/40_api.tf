
resource "aws_api_gateway_rest_api" "latcraft_api" {
  name                    = "LatCraft API"
  description             = "API to support LatCraft automation"
}

resource "aws_iam_role" "latcraft_api_executor" {
  name                    = "latcraft_api_executor"
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
