#! /bin/bash
sudo amazon-linux-extras install tomcat8.5 -y
sudo systemctl enable tomcat
sudo systemctl start tomcat
cd /usr/share/tomcat/webapps/
sudo chmod 777 /usr/share/tomcat/
sudo chmod 777 /usr/share/tomcat/webapps
sudo groupadd tomcat
sudo chown -R :tomcat /opt/tomcat/webapps
sudo chmod g+w /opt/tomcat/webapps
