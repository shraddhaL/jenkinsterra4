
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
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

resource "docker_container" "tomcat_container" {
  name  = "mytomcat"
  image = docker_image.tomcat_image.latest
  ports {
    internal = 8080
    external = 9090
  }
}

resource "docker_image" "tomcat_image" {
  name = "shraddhal/tomcat_develop"
}






resource "aws_instance" "web" {
  ami = "ami-01aab85a5e4a5a0fe" 
    instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.webSG.id}"]
   key_name = "azureaws"
   associate_public_ip_address = true
   tags = {
    Name = "remote-exec-provisioner"
  }
}

resource "aws_security_group" "webSG" {
  name        = "webSG"

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
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5900
    to_port     = 5900
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 4444
    to_port   = 4444
    protocol  = "tcp"

    # To keep this example simple, we allow incoming SSH requests from any IP. In real-world usage, you should only
    # allow SSH requests from trusted servers, such as a bastion host or VPN server.
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

  // copy our example script to the server
provisioner "file" {
    source      = "end_to_end/docker-compose.yml"
    destination = "/end_to_end/docker-compose.yml"
  } 

  // change permissions to executable and pipe its output into a new file
  provisioner "remote-exec" {
      connection {
      type        = "ssh"
      user        = "ec2-user"
        
    host        = aws_instance.web.public_ip 
      private_key = file("azureaws.pem")
    }
    inline = [
      "sudo curl -L https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo chmod 777 /end_to_end",
      "cd /end_to_end",
      "docker-compose --version",
      "docker-compose up -d --scale chrome=3",
    ]
  }
  
    depends_on = [ aws_instance.web ]
}

