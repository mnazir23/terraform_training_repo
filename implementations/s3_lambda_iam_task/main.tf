# 1. Create Source & Destination S3 Buckets
module "s3_source" {
    source = "../../modules/s3"
    bucket_name = var.source_bucket
    acl = var.access_level
}

module "s3_destination" {
    source = "../../modules/s3"
    bucket_name = var.destination_bucket
    acl = var.access_level
}


# 2. Create Fine Grained IAM Role for the Lambda Function
resource "aws_iam_policy" "s3_lambda_policy" {
  name        = var.policy_name
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [ 
                "s3:GetObject"
            ],
            "Resource": [
                "${module.s3_source.arn}/*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [ 
                "s3:PutObject"
            ],
            "Resource": [
                "${module.s3_destination.arn}/*"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

module "s3_lambda_role" {
    source = "../../modules/iam_role"
    role_name = var.role_name
    role_json = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
    policy_name = var.policy_name
    policy_arn = aws_iam_policy.s3_lambda_policy.arn
}

# 3. Update S3 Buckets Policies to Only Allow Access to the Main User & the IAM Role

# Source Bucket
resource "aws_s3_bucket_policy" "source_bucket_policy" {
    bucket = module.s3_source.id

    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.source_bucket}",
                "arn:aws:s3:::${var.source_bucket}/*"
            ],
            "Condition": {
                "StringNotLike": {
                    "aws:userId": [
                        "${var.main_user_id}:*",
                        "${module.s3_lambda_role.id}:*"
                    ]
                }
            }
        }
    ]
}
POLICY
}

# Destination Bucket
resource "aws_s3_bucket_policy" "destination_bucket_policy" {
    bucket = module.s3_destination.id

    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.destination_bucket}",
                "arn:aws:s3:::${var.destination_bucket}/*"
            ],
            "Condition": {
                "StringNotLike": {
                    "aws:userId": [
                        "${var.main_user_id}:*",
                        "${module.s3_lambda_role.id}:*"
                    ]
                }
            }
        }
    ]
}
POLICY
}

# 4. Create Lambda Function
data "archive_file" "lambda_function_file" {
  type        = "zip"
  source_file = "./files/${var.function_name}.js"
  output_path = "${var.function_name}.zip"
}

resource "aws_lambda_function" "s3_lambda_function" {
    filename      = "${var.function_name}.zip"
    function_name = var.function_name
    role          = module.s3_lambda_role.arn
    handler       = "${var.function_name}.handler"

    source_code_hash = data.archive_file.lambda_function_file.output_base64sha256

    runtime = var.runtime_env

    environment {
        variables = {
            sourceBucket = var.source_bucket,
            destinationBucket = var.destination_bucket
        }
  }
}

# 5. Add Trigger for S3 Source Bucket
resource "aws_lambda_permission" "allow_source_bucket" {
    statement_id  = var.statement_id
    action        = var.action
    function_name = aws_lambda_function.s3_lambda_function.function_name
    principal     = var.principal
    source_arn    = module.s3_source.arn
    depends_on    = [aws_lambda_function.s3_lambda_function]
}

resource "aws_s3_bucket_notification" "s3_lambda_trigger" {
    bucket = module.s3_source.id

    lambda_function {
        lambda_function_arn = aws_lambda_function.s3_lambda_function.arn
        events              = ["s3:ObjectCreated:*"]
    }

    depends_on = [aws_lambda_permission.allow_source_bucket]
}