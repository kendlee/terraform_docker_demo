terraform {
  required_version = "~> 0.12"
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  tcp_protocol = "tcp"
  all_ips      = "0.0.0.0/0"
}

resource "aws_launch_configuration" "server_config" {
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.server_secgroup.id]

  user_data = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "server_asg" {
  name                 = "${var.cluster_name}-${aws_launch_configuration.server_config.name}"

  launch_configuration = aws_launch_configuration.server_config.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

  target_group_arns    = var.target_group_arns
  health_check_type    = "EC2"

  min_size = var.min_size
  max_size = var.max_size

  min_elb_capacity = var.min_size

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "server_secgroup" {
  name = "${var.cluster_name}-server-secgroup"
}

resource "aws_security_group_rule" "all_server_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.server_secgroup.id

  from_port   = var.server_port
  to_port     = var.server_port
  protocol    = local.tcp_protocol
  cidr_blocks = [local.all_ips]
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}