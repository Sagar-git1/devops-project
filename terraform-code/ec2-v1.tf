provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "demoserver" {
  ami = "ami-0bb4c991fa89d4b9b"
  instance_type = "t2.micro"
  key_name = "name:redhat"
  tags = {
    Name = "demoserver"
  }
}