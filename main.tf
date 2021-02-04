
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
  

}

