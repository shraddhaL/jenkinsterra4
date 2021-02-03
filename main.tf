terraform {
 required_version = "~>0.12"
}

provider "docker" {
  host = "tcp://docker:2345/"
  }

resource "docker_container" "tomcat_container" {
  name  = "mytomcat"
  image = docker_image.tomcat_image.latest
  ports = {
    internal = "8080"
    external = "9090"
  }
}

resource "docker_image" "tomcat_image" {
  name = "shraddhal/tomcat_develop:latest"
}
