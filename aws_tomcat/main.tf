terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.26.0"
    }
  }
}
provider "aws" {
   access_key = "AKIAUKBXP6VH4WUSR6GX"
   secret_key = "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"
   region = "us-east-2"
}
resource "aws_instance" "web" {
  ami = "ami-01aab85a5e4a5a0fe" 
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webSG2.id]
  key_name = "azureaws"
  user_data = "${data.template_file.user_data.rendered}"
  associate_public_ip_address = true
  tags = {
    Name = "file-provisioner"
  }
  
   provisioner "file" {
      connection {
     type  = "ssh"
    host  = aws_instance.web.public_ip
    user        = "ec2-user"
    }
    source      = "/opt/tomcat/tomcat9/webapps/roshambo.war"
    destination = "/tmp/roshambo.war"
     }
  
   provisioner "remote-exec" {
      connection {
      type  = "ssh"
    host  = aws_instance.web.public_ip
    user        = "ec2-user"
    }
    inline = [
    "cp /tmp/roshambo.war /usr/share/tomcat/webapps/roshambo.war",
    ]
  }
  
  
}

data "template_file" "user_data" {
  template = "${file("aws_tomcat/install_tomcat.sh")}"


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

