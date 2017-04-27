resource "aws_iam_user" "latcraft_lambda" {
  name = "latcraft_lambda"
}

resource "aws_iam_user_policy" "student_policy" {
  name = "latcraft_lambda"
  user = "${aws_iam_user.latcraft_lambda.name}"
  policy = "${file("student.policy")}"
}
