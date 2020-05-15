resource "aws_s3_bucket" "prod-bucket" {
  bucket = var.bucket_name
  acl    = var.acl

  tags = {
    Name        = var.bucket_name
  }
}

resource "aws_s3_bucket_policy" "access_policy" {
  count = var.policy_json == "None" ? 0 : 1
  bucket = aws_s3_bucket.prod-bucket.id

  policy = var.policy_json
}