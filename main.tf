variable "private_key" {
  type = string
}
variable "public_key" {
  type = string
}
variable "secret" {
  type = string
}
variable "access" {
  type = string
}
/*
module "tomcat_container" {
  source = "./tomcat_container"
}

 module "selenium_containers" {
  source = "./selenium_containers"
} */

 module "aws_tomcat" {
  source = "./aws_tomcat"
   private_key = var.private_key
   public_key = var.public_key
   secret = var.secret
   access = var.access
}     
   /*provider "aws" {
   access_key = var.access
   secret_key = var.secret
   region = "us-east-2"
}

resource "aws_key_pair" "my_key" {
  key_name   = "my_key"
  public_key =file(var.public_key)
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
}
output "aws_link" {
  value=format("Access the AWS hosted webapp from here: http://%s%s", aws_instance.web.public_dns, ":8080/roshambo")
}

data "template_file" "asg_init" {
  template = file("${path.module}/userdata.tpl")
}
*/
