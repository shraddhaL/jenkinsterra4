#! /bin/bash
sudo amazon-linux-extras install tomcat8.5 -y
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo cp /tmp/roshambo.war /usr/share/tomcat/webapps/roshambo.war
