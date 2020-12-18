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
  security_groups = [ "launch-wizard-3" ]
  
  tags = {
    Name = "PROD_1"
  }
}

resource "aws_instance" "prod_2" {
  ami           = data.aws_ami.prod_ami.id
  instance_type = "t3.micro"
  key_name      = "MyUSE1KP"
  security_groups = [ "launch-wizard-3" ]
  
  tags = {
    Name = "PROD_2"
  }
}

resource "aws_instance" "prod_3" {
  ami           = data.aws_ami.prod_ami.id
  instance_type = "t3.micro"
  key_name      = "MyUSE1KP"
  security_groups = [ "launch-wizard-3" ]
  
  tags = {
    Name = "PROD_3"
  }
}

resource "null_resource" "delay" {
  depends_on             = [aws_instance.prod_1, aws_instance.prod_2, aws_instance.prod_3]
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > hosts
[webservers]
${aws_instance.prod_1.private_ip}
${aws_instance.prod_2.private_ip}
${aws_instance.prod_3.private_ip}
EOF
aws ec2 wait instance-status-ok --instance-ids ${aws_instance.prod_1.id} && aws ec2 wait instance-status-ok --instance-ids ${aws_instance.prod_2.id} && aws ec2 wait instance-status-ok --instance-ids ${aws_instance.prod_3.id}
aws s3 cp hosts s3://ramgopkeys
EOD
  }
  
  }


output "PUB_1" {
  value = aws_instance.prod_1.public_ip
}

output "PUB_2" {
  value = aws_instance.prod_2.public_ip
}

output "PUB_3" {
  value = aws_instance.prod_3.public_ip
}


