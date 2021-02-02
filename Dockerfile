FROM tomcat:latest

Copy /target/*.war /usr/local/tomcat/webapps

Expose 8080
