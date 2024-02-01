provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "terraform_openMRS" {
  ami           =  "ami-02e67322dc61af39c"
  instance_type = "t2.micro"
  key_name = aws_key_pair.openMRS-Key.key_name
  vpc_security_group_ids = [aws_security_group.instance.id]
  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "openMRS-Key" {
  key_name   = "OpenMRS instance key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKYIw9jvX4oKcj6s51OycjLJMmX0RV3i1nb/Ib2xtfb2LgFvp+DjQle6rt83I85NFRm9Tv3wtXQDCAggjIXFlT5erSS020evjLnfGAbm51QOx2/yKRwEcZZCdfBtFwPZZmo6phfNS9cTzFPMBpLeVqcY7oVYia8sFCjMlerewXKwK0CXkMmkXlsnoKQPQiIw2JokiN8GBfgJYZ884fygr0xOkIQCRHPRUmDgD8q5YpX36934RX48rTw+pQoMYM2pTMQCguFmUODibaiCdvbUvEJzF7v6Q/QoySTHqUrozc/B6bbwBB+KsBoPSNsM1A9kwIggF8MMROda6fX4ddfK2H"
}
