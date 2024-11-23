resource "aws_instance" "public" {
  ami = "ami-04c913012f8977029"
  instance_type = "t2.micro"
  subnet_id = "subnet-0caaf48818e0596cc"
  associate_public_ip_address = true
  key_name = "yl-key-pair"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "yl-ec2"
  }
}

resource "aws_security_group" "allow_ssh" {
  name = "yl-terraform-security-group"
  description = "Allow SSH inbound"
  vpc_id = "vpc-01c494fe1e8787c82"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}