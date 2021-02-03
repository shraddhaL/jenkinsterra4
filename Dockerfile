FROM tomcat:latest

Copy /target/*.war /opt/tomcat/tomcat9/webapps

Expose 8080
