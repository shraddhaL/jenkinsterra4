

resource "docker_container" "tomcat_container" {
  name  = "mytomcat"
  image = docker_image.tomcat_image.name
  ports = {
    internal = "8080"
    external = "9090"
  }
}

resource "docker_image" "tomcat_image" {
  name = "shraddhal/tomcat_develop"
}