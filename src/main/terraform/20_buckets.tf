
resource "aws_s3_bucket" "latcraft_code" {
  bucket                  = "latcraft-code"
  acl                     = "private"
  region                  = "${var.aws_region}"
}

resource "aws_s3_bucket" "latcraft_images" {
  bucket                  = "latcraft-images"
  acl                     = "private"
  region                  = "${var.aws_region}"
}

