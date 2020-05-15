resource "aws_launch_template" "launch_template" {
    name = var.template_name
    image_id = var.ami_id
    instance_type = var.vm_size
    key_name = var.key_pair_name

    placement {
        availability_zone = var.availability_zone
    }

    vpc_security_group_ids = [var.secgroup_id]
    user_data = filebase64(var.user_data)
}