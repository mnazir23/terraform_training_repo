resource "aws_autoscaling_group" "lb_asg" {
    count              = var.lb_type == "appnet" ? 1 : 0
    name               = var.group_name
    availability_zones = [var.availability_zone]
    desired_capacity   = var.desired_capacity
    max_size           = var.max_size
    min_size           = var.min_size
    target_group_arns  = var.target_group_arns


    launch_template {
        id      = var.launch_template
        version = var.template_version
    }
}

resource "aws_autoscaling_group" "elb_asg" {
    count              = var.lb_type == "elastic" ? 1 : 0
    name               = var.group_name
    availability_zones = [var.availability_zone]
    desired_capacity   = var.desired_capacity
    max_size           = var.max_size
    min_size           = var.min_size
    load_balancers      = var.load_balancers
    

    launch_template {
        id      = var.launch_template
        version = var.template_version
    }
}

resource "aws_autoscaling_policy" "scaling_policy" {
  name                   = "new_scp"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = var.lb_type == "appnet" ? aws_autoscaling_group.lb_asg.0.name : aws_autoscaling_group.elb_asg.0.name
}

