locals {
  resource_prefix = "yl-infra"
}

variable "env" {
  description = "Environment value. Can be used if you want to pass in a different value/variable as per environment. Default value can be set to dev"
  type = string
  default = "dev"  
}

#variable "name" {
#  description = "name of the application"
#  type = string
  #default = "somename"
#}

resource "aws_instance" "public" {
  ami = data.aws_ami.amazon2023.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnets.public.ids[0]
  #subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  key_name = "yl-key-pair"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "${local.resource_prefix}-ec2-${var.env}"
  }
}

resource "aws_security_group" "allow_ssh" {
  name_prefix = "${local.resource_prefix}-sg-${var.env}"
  description = "Allow SSH inbound"
  vpc_id = data.aws_vpc.selected.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

