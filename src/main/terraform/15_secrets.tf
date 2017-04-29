
resource "aws_kms_key" "latcraft_kms_key" {
  description             = "latcraft_kms_key"
  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-consolepolicy-3",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access for Key Administrators",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.latcraft_lambda_executor.name}",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.latcraft_lambda.name}"
        ]
      },
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow use of the key",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.latcraft_lambda_executor.name}",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.latcraft_lambda.name}"
        ]
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow attachment of persistent resources",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.latcraft_lambda_executor.name}",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.latcraft_lambda.name}"
        ]
      },
      "Action": [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "kms:GrantIsForAWSResource": "true"
        }
      }
    }
  ]
}
EOF
}

resource "aws_kms_alias" "latcraft_kms_key_alias" {
  name                    = "alias/latcraft_kms_key"
  target_key_id           = "${aws_kms_key.latcraft_kms_key.key_id}"
}
