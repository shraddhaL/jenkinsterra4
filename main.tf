
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
  ami = data.aws_ami.ubuntu.id
  
  provisioner "file" {
    source      = "end_to_end/docker-compose.yml"
    destination = "/end_to_end"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /end_to_end",
      "docker-compose up -d --scale chrome=3",
    ]
  }
}
