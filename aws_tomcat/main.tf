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
  key_name = "azureaws"
 
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

resource "null_resource" "copy_execute" {
  triggers = {
    public_ip = aws_instance.web.public_ip
  }

  connection {
    type  = "ssh"
    host  = aws_instance.web.public_ip
    user        = "ec2-user"
    private_key = file("azureaws.pem")
  }

  provisioner "remote-exec" {
      connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.web.public_ip 
      private_key = file("azureaws.pem")
    }
    inline = [
        "sudo amazon-linux-extras install tomcat8.5 -y",
        "sudo systemctl enable tomcat",
        "sudo systemctl start tomcat",
        "cd /usr/share/tomcat/webapps/",
        "sudo chmod 777 /usr/share/tomcat/",
        "sudo chmod 777 /usr/share/tomcat/webapps",
    ]
  }
    provisioner "file" {
    source      = "/opt/tomcat/tomcat9/webapps/roshambo.war"
    destination = "/usr/share/tomcat/webapps/roshambo.war"
  
   connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.web.public_ip 
      private_key = file("azureaws.pem")
    }
  } 
    depends_on = [ aws_instance.web ]
}

output "DNS" {
  value = aws_instance.web.public_ip

}
