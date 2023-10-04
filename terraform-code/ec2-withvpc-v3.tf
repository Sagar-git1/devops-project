provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "demoserver" {
  ami = "ami-0bb4c991fa89d4b9b"
  instance_type = "t2.micro"
  key_name = "name:redhat"
  //security_groups = ["ssh_sg"]
  vpc_security_group_ids = [ aws_security_group.ssh_sg.id ]
  subnet_id = aws_subnet.myvpc-publicsubnet-01.id
  tags = {
    Name = "demoserver"
  }
}
resource "aws_security_group" "ssh_sg" {
  name        = "ssh_sg"
  description = "Allow ssh inbound traffic"
  vpc_id = aws_vpc.myvpc.id

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

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "myvpc-publicsubnet-01" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
   tags = {
    Name = "myvpc-publicsubnet-01"
  }
}

resource "aws_subnet" "myvpc-publicsubnet-02" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  aws_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
   tags = {
    Name = "myvpc-publicsubnet-02"
  }
}

resource "aws_internet_gateway" "myvpc-igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myvpc-igw"
  }
}

resource "aws_route_table" "myvpc-public-rtb" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myvpc-igw.id
  }
}

resource "aws_route_table_association" "myvpc-rta-publicsubnet-01" {
  subnet_id = aws_subnet.myvpc-publicsubnet-01.id
  route_table_id = aws_route_table.myvpc-public-rtb.id
}

resource "aws_route_table_association" "myvpc-rta-publicsubnet-02" {
  subnet_id = aws_subnet.myvpc-publicsubnet-02.id
  route_table_id = aws_route_table.myvpc-public-rtb.id
}