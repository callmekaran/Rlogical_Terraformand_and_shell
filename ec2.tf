provider "aws" {
  region = "ap-south-1"
  access_key  = "AKIAQ3EGT6YYWUZKHZPF"
  secret_key = "boqKlBBwXtxdStdL3Oml7K6Mnyf6wOA3nhp5rEOx"
# Chang this to your desired AWS region
}

data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

output "test" {
  value = data.aws_ami.ubuntu
}
resource "aws_eip" "lb" {
  instance = aws_instance.ubuntu_server.id
  domain   = "vpc"
}

resource "aws_instance" "ubuntu_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"  
  key_name      = "karan"  
  vpc_security_group_ids = [aws_security_group.allow_inbound.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx

              # Install PHP 8.2
              sudo apt-get install -y software-properties-common
              sudo add-apt-repository ppa:ondrej/php
              sudo apt-get update
              sudo apt-get install -y php8.2 php8.2-fpm php8.2-mysql

              apt-get install -y mysql-server

              # Install phpMyAdmin
              apt-get install -y phpmyadmin

              EOF

  tags = {
    Name = "Ubuntu22Server"
  }
}

resource "aws_security_group" "allow_inbound" {
  name        = "allow_inbound"
  description = "Allow inbound traffic on port 80"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
