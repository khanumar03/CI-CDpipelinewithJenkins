provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "profilename"
}

resource "aws_key_pair" "terraform_keypair" {
  key_name   = "terraform_keypair"
  public_key = file("~/.ssh/terraform-ec2.pub")
}

resource "aws_security_group" "terraform_ec2_sg" {
  name        = "terraform_ec2_sg"
  description = "Allow"
}

resource "aws_security_group_rule" "SSH_RULE" {
  type              = "ingress"
  security_group_id = aws_security_group.terraform_ec2_sg.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "JENKINS_RULE" {
  type              = "ingress"
  security_group_id = aws_security_group.terraform_ec2_sg.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "internet1" {
  type              = "ingress"
  security_group_id = aws_security_group.terraform_ec2_sg.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "internet2" {
  type              = "ingress"
  security_group_id = aws_security_group.terraform_ec2_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "All_RULE" {
  type              = "egress"
  security_group_id = aws_security_group.terraform_ec2_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "terraform_ec2" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.terraform_keypair.id
  vpc_security_group_ids = [aws_security_group.terraform_ec2_sg.id]

  user_data = filebase64("/install.sh")

  tags = {
    Name = "terraform_ec2"
  }
}
