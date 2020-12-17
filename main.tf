provider "aws" {
  region = "us-east-1"
  version = "~> 2.35" 
}

terraform {
  backend "s3" {
    bucket = "terraform-state-remote-storage2"
    key = "helloworld"
    region = "us-east-1"
}
  }
  
data "aws_ami" "prod_ami" {
  most_recent = true

  filter {
    name   = "name"
      values = ["amzn2-ami-hvm-2.0.20201126.0-x86_64-gp2"]
  }
  
  data "key_pair" "rams_key" {
  filter {
    name   = "name"
      values = ["MyUSE1KP"]
  }
   
owners = ["amazon"] # Canonical
}

resource "aws_instance" "prod" {
  ami           = data.aws_ami.prod_ami.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.rams_key.key_name
  
  tags = {
    Name = "HelloWorld"
  }
}
