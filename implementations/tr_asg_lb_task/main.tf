# Create Security Group
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
    protocol = "tcp"
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

# Create a template file for the userdata script
data "template_file" "apache_setup" {
    template = "${file("./scripts/apache_setup.sh")}"
}

# Availability Zones
data "aws_availability_zones" "available" {
    state = "available"
}

# EC2 Instance
module "ec2" {
    source = "../../modules/ec2"
    machine_name = var.vm_name
    key_name = var.key_pair_name
    secgroup_id = module.security_group.secgroup_id
    user_data = data.template_file.apache_setup.rendered
    availability_zone = var.availability_zone
}

# Launch Template
module "launch_template" {
    source = "../../modules/launch_template"
    availability_zone = data.aws_availability_zones.available.names[0]
    user_data = "./scripts/apache_setup.sh"
    secgroup_id = module.security_group.secgroup_id
}

# Application Load Balancer
data "aws_subnet_ids" "private" {
  vpc_id = module.security_group.vpc_id

}

module "alb" {
    source = "../../modules/app_lb"
    lb_name = "app-lb"
    type = "application"
    security_groups = [module.security_group.secgroup_id]
    subnets = [var.subnet_one, var.subnet_two]
    vpc_id = module.security_group.vpc_id
}

# Elastic Load Balancer
# Create a new load balancer
resource "aws_elb" "elb" {
  name               = "prod-elb"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}

# Auto Scaling Group with ALB
module "asg" {
    source = "../../modules/asg"
    lb_type = "elastic"
    launch_template = module.launch_template.id
    availability_zone = data.aws_availability_zones.available.names[0]
    target_group_arns = [module.alb.target_group_id] # to be used for ALB and NLB
    load_balancers = [aws_elb.elb.id] # to be used for ELB
}

# Attach the Existing E2 with the ASG
resource "null_resource" "create-endpoint" {
  provisioner "local-exec" {
    command = "aws autoscaling attach-instances --instance-ids ${module.ec2.id} --auto-scaling-group-name ${module.asg.id}"
  }
}

