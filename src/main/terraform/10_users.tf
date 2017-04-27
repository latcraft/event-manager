
resource "aws_iam_user" "latcraft_lambda" {
  name = "latcraft_lambda"
}

resource "aws_iam_user_policy_attachment" "latcraft_lambda_policy_attachment" {
  user       = "${aws_iam_user.latcraft_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
}
