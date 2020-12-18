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
    
owners = ["amazon"] # Canonical
}

resource "aws_instance" "prod_1" {
  ami           = data.aws_ami.prod_ami.id
  instance_type = "t3.micro"
  key_name      = "MyUSE1KP"
  
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_instance" "prod_2" {
  ami           = data.aws_ami.prod_ami.id
  instance_type = "t3.micro"
  key_name      = "MyUSE1KP"
  
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_instance" "prod_3" {
  ami           = data.aws_ami.prod_ami.id
  instance_type = "t3.micro"
  key_name      = "MyUSE1KP"
  
  tags = {
    Name = "HelloWorld"
  }
}

resource "null_resource" "delay" {
  depends_on             = [aws_instance.prod_1, aws_instance.prod_2, aws_instance.prod_3]
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > hosts
[webservers]
${prod_1.private_ip}
${prod_2.private_ip}
${prod_3.private_ip}
EOF
sleep 60
EOD
  }
  
  }

