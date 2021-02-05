terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
  }
}


resource "null_resource" "composedocker" {
  provisioner "local-exec" {
       command = "docker-compose up -d --scale chrome=3"
  }
}

