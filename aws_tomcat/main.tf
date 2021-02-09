terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.26.0"
    }
  }
}
provider "aws" {
   access_key = var.access
   secret_key = var.secret
   region = "us-east-2"
}

resource "aws_key_pair" "my_key" {
  key_name   = "mykey"
  private_key =file(var.private_key)
}
resource "aws_instance" "web" {
  ami = "ami-01aab85a5e4a5a0fe" 
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webSG2.id]
  key_name = aws_key_pair.my_key.key_name
  user_data = data.template_file.asg_init.rendered
  associate_public_ip_address = true
  tags = {
    Name = "deploy-on-aws"
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

resource "null_resource" "copy_file" {
  triggers = {
    public_ip = aws_instance.web.public_ip
  }

  connection {
    type  = "ssh"
    host  = aws_instance.web.public_ip
    user        = "ec2-user"
    private_key =file(var.private_key)
  }

provisioner "file" {
    source      = "/opt/tomcat/tomcat9/webapps/roshambo.war"
      destination = "/tmp/roshambo.war"
      connection {
        type     = "ssh"
        user     = "ec2-user"
        host     = aws_instance.web.public_ip 
        private_key =file(var.private_key)
      }
    }
  
    depends_on = [ aws_instance.web ]
}




output "DNS" {
  value = aws_instance.web.public_ip
  value=format("Access the AWS hosted webapp from here: http://%s%s", aws_instance.web.public_dns, ":8080/roshambo")
}

data "template_file" "asg_init" {
  template = file("${path.module}/userdata.tpl")
}
variable "access" {
  type = string
}
variable "secret" {
  type = string
}
variable "private_key" {
  type = string
}

