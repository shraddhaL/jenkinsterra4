resource "null_resource" "composedocker" {
  provisioner "local-exec" {
       command = "docker-compose up -d --scale chrome=3"
  }
}

resource "null_resource" "composedocker" {
  provisioner "local-exec" {
       command = "docker-compose down"
  }
}
