provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "demoserver" {
  ami = "ami-0bb4c991fa89d4b9b"
  instance_type = "t2.micro"
  key_name = "name:redhat"
  security_groups = ["ssh_sg"]
  tags = {
    Name = "demoserver"
  }
}
resource "aws_security_group" "ssh_sg" {
  name        = "ssh_sg"
  description = "Allow ssh inbound traffic"

  ingress {
    description      = "allow ssh inbound"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh_sg"
  }
}