provider "aws" {
  region = "us-east-1"
  version = "~> 2.35" 
}
terraform {
  backend "s3" {
    bucket = "terraform-state-remote-storage"
    key = "helloworld"
    region = "us-east-1"
}
}
module "helloworld"{
source = "."
}

data "aws_ami" "prod_ami" {
  most_recent = true

  filter {
    name   = "name"
      values = ["amzn2-ami-hvm-2.0.20201126.0-x86_64-gp2"]
  }

owners = ["amazon"] # Canonical
}

resource "aws_instance" "prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}
