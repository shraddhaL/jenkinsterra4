
variable "private_key" {
  type = string
}
variable "secret" {
  type = string
}
variable "access" {
  type = string
}
module "tomcat_container" {
  source = "./tomcat_container"
}

 module "selenium_containers" {
  source = "./selenium_containers"
} 



 module "aws_tomcat" {
  source = "./aws_tomcat"
   
}   

