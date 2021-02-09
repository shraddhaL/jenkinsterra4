
module "tomcat_container" {
  source = "./tomcat_container"
}

 module "selenium_containers" {
  source = "./selenium_containers"
} 
   
 module "aws_tomcat" {
  source = "./aws_tomcat"
    access_key = var.access
   secret_key = var.secret
   private_key  = var.private_key
}   
variable "access" {
  type = string
}
variable "secret" {
  type = string
}
variable "private_key" {
  type = string
}
