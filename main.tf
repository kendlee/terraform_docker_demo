terraform {
  required_version = "~> 0.12"
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  tcp_protocol = "tcp"
  any_port     = 0
  any_protocol = "-1"
  ssh_port     = 22
  all_ips      = "0.0.0.0/0"
}

resource "aws_key_pair" "server_key" {
  key_name   = "terraform-docker-demo"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_instance" "server_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.server_secgroup.id]
  key_name               = aws_key_pair.server_key.key_name

  tags = {
    "Name" = "${var.cluster_name}-server-instance-1"
  }

  provisioner "remote-exec" {
    inline = ["echo 'VM is ready!'"]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${path.module}/id_rsa")
  }
}

resource "aws_security_group" "server_secgroup" {
  name = "${var.cluster_name}-server-secgroup"
}

resource "aws_security_group_rule" "allow_server_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.server_secgroup.id

  from_port   = var.server_port
  to_port     = var.server_port
  protocol    = local.tcp_protocol
  cidr_blocks = [local.all_ips]
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.server_secgroup.id

  from_port   = local.ssh_port
  to_port     = local.ssh_port
  protocol    = local.tcp_protocol
  cidr_blocks = [local.all_ips]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type = "egress"
  security_group_id = aws_security_group.server_secgroup.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = [local.all_ips]
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}