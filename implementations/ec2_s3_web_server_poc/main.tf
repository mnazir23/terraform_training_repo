provider "aws" {
  region  = var.aws_region
}

### IAM Role Creation

# Create IAM Role which allows READONLY access to S3
module "iam_role_s3" {
  source = "../../modules/iam_role"
  role_name = var.role_name
  role_json = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  policy_name = "s3_readonly"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

### S3 Creation
module "s3" {
    source = "../../modules/s3"
    bucket_name = var.s3_bucket_name
    acl = var.access_level
    policy_json = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_name}",
        "arn:aws:s3:::${var.s3_bucket_name}/*"
      ],
      "Condition": {
        "StringNotLike": {
          "aws:userId": [
            "${var.main_user_id}:*",
            "${module.iam_role_s3.id}:*"
          ]
        }
      }
    }
  ]
}
POLICY
}

## EC2 Instance Creation

# 1. Create a template file for the userdata script
data "template_file" "apache_setup" {
  template = "${file("./scripts/apache_setup.sh")}"
  vars = {
    bucket_name = var.s3_bucket_name
  }
}

# 3. Create security group for EC2
module "security_group" {
    source = "../../modules/security_group"
    sg_name = var.secgroup_name
}

module "security_group_rule_inbound_ssh" {
  source = "../../modules/security_group_rule"
  to_port = "22"
  from_port = "22"
  protocol = "tcp"
  cidr_value = var.cidr_value
  secgroup_id = module.security_group.secgroup_id
  rule_type = "ingress"
}

module "security_group_rule_inbound_http" {
  source = "../../modules/security_group_rule"
  to_port = "80"
  from_port = "80"
  protocol = "-1"
  cidr_value = var.cidr_value
  secgroup_id = module.security_group.secgroup_id
  rule_type = "ingress"
}

module "security_group_rule_outbound" {
  source = "../../modules/security_group_rule"
  to_port = "0"
  from_port = "0"
  protocol = "-1"
  cidr_value = var.cidr_value
  secgroup_id = module.security_group.secgroup_id
  rule_type = "egress"
}

# 4. Create EC2 with Policy and User Data Added
module "ec2" {
  source = "../../modules/ec2"
  machine_name = var.machine_name
  key_name = var.key_pair_name
  secgroup_id = module.security_group.secgroup_id
  user_data = data.template_file.apache_setup.rendered
  iam_role = module.iam_role_s3.role_name
}