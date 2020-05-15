resource "aws_iam_instance_profile" "instance_profile" {
  count = var.iam_role == "None" ? 0 : 1
  name = "instance_profile"
  role = var.iam_role
}

resource "aws_instance" "prod-web" {
  ami           = "ami-085925f297f89fce1"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.secgroup_id]
  key_name = var.key_name
  availability_zone = var.availability_zone
  user_data = var.user_data
  iam_instance_profile = var.iam_role == "None" ? null : aws_iam_instance_profile.instance_profile.0.name

  tags = {
    Name = var.machine_name
  }
}