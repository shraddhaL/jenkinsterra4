resource "null_resource" "containers_up" {
  provisioner "local-exec" {
       command = "docker-compose up -d --scale chrome=3"
  }
}

resource "null_resource" "containers_down" {
  provisioner "local-exec" {
       command = "docker-compose down"
  }
}
