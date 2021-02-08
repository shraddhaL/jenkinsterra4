#! /bin/bash
sudo amazon-linux-extras install tomcat8.5 -y
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo chmod 777 /usr/share/tomcat/
sudo chmod 777 /usr/share/tomcat/webapps
cd /usr/share/tomcat/webapps/
