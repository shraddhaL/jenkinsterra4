terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.26.0"
    }
  }
}
provider "aws" {
   access_key = ""
   secret_key = ""
   region = "us-east-2"
}
resource "aws_instance" "web" {
  ami = "ami-01aab85a5e4a5a0fe" 
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webSG2.id]
  key_name = ""
  user_data = "${file("./aws_tomcat/install_tomcat.sh")}"
  associate_public_ip_address = true
  tags = {
    Name = "remote-exec-provisioner"
  }
}

resource "aws_security_group" "webSG2" {
  name        = "webSG2"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "DNS" {
  value = aws_instance.web.public_ip

}
