
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
    aws = {
     # source = "hashicorp/aws"
     # version = "3.26.0"
      access_key = "AKIAUKBXP6VHTML56ZNF"
   secret_key = "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"
   region = "us-east-2"
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
  ami = "ami-01aab85a5e4a5a0fe"
    instance_type = "t2.micro"
  
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
