provider "aws" {
  region = "ap-south-1"
  access_key  = "AKIAQ3EGT6YYWUZKHZPF"
  secret_key = "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"
}

#create a security group for RDS Database Instance
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["13.235.148.192/32"]                #WEBSERVER IP
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create a RDS Database Instance
resource "aws_db_instance" "myinstance" {
  engine               = "mysql"
  identifier           = "myrdsinstance"
  allocated_storage    =  20
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "myrdsuser"
  password             = "myrdspassword"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot  = true
  publicly_accessible =  true
}
