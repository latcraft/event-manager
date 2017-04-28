
variable "aws_region" {
  default = "eu-west-1"
}

variable "lambda_code_package_prefix" {
  default = "lv.latcraft.event.tasks"
}

variable "lambda_code_default_method" {
  default = "execute"
}

data "aws_caller_identity" "current" {

}

output "aws_account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

provider "aws" {
  region = "${var.aws_region}"
}
