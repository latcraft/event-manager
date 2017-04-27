
resource "aws_s3_bucket" "latcraft_code" {
  bucket                  = "latcraft-code"
  acl                     = "private"
}

resource "aws_s3_bucket" "latcraft_images" {
  bucket                  = "latcraft-images"
  acl                     = "private"
}

