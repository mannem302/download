#!/bin/bash
echo "Below mentioned tool/Software can be installed as per your choice"
echo "Git"
echo "Maven"
echo "Java"
echo "Tomcat"
echo "Jenkins"
echo "Now you can install/download any devops tools/softwares by entering their name from above list"
read tool
case $tool in
        "tomcat"|"Tomcat"|"TOMCAT")
                echo "You have entered $tool"
                cd /var/lib/tomca*/conf > /dev/null 2>&1
                tomcat_port=`sudo cat server.xml | grep port= | cut -d '=' -f2 | cut -d '"' -f 2 | head -2 | tail -1` > /dev/null 2>&1
                tomcat_ip=`host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has" | awk '{print $4}'`
                sudo curl  --connect-timeout 3 http://$tomcat_ip:$tomcat_port > /dev/null 2>&1 
                if [ $? -eq 0 ]
                then
                echo "Tomcat-Server was available in your System"
                else
                echo "Now $tool will be installed"
                sudo apt-get update
                sudo apt-get install tomcat9 tomcat9-admin -y
                cd ~
                wget https://raw.githubusercontent.com/mannem302/download/master/tomcat-users.xml
                sudo mv ~/tomcat-users.xml /var/lib/tomcat9/conf/tomcat-users.xml
                echo "$tool was succesfully installed and users was configured"
                tomcat_ip=`host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has" | awk '{print $4}'`
		cd /var/lib/tomcat9/conf
                tomcat_port=`sudo cat server.xml | grep port= | cut -d '=' -f2 | cut -d '"' -f 2 | head -2 | tail -1`
                sudo curl --connect-timeout 3 http://$tomcat_ip:$tomcat_port | grep tomcat > /dev/null 2>&1
                if [ $? -eq 0 ]
                then
                echo "$tool was succesfully Installed "
                echo "Alternatively, Now you can open browser with IP address is $tomcat_ip and alloted port number is: $tomcat_port"
                echo "Default username- tomcat and default password- tomcat"
                else
                echo "You need to allow the port number $tomcat_port in security groups or $tomcat_port is using by Jenkins"
                fi
                fi
                ;;
        "maven"|"Maven"|"MAVEN")
                echo "You have entered $tool "
                mvn --version > /dev/null 2>&1
                if [ $? -eq 0 ]
                then
                echo "$tool is available in your server and it's Version is:"
                mvn --version
                else
                echo "Now $tool will be installed"
                sudo apt-get update
                sudo apt-get install maven -y
                echo "$tool was succesfully installed and it's Version is:"
                mvn -version
                fi
                ;;
        "git"|"Git"|"GIT")
                echo "You have entered $tool " 
                git --version > /dev/null 2>&1
                if [ $? -eq 0 ]
                then
                echo "$tool is available in your server and it's Version is:"
                git --version
                else
                echo "Now $tool will be installed"
                sudo apt-get update
                sudo apt-get install git -y
                echo "$tool was succesfully installed and it's Version is:"
                git --version
                fi
                ;;
        "java"|"Java"|"JAVA")
                echo "You have entered $tool " 
                java --version > /dev/null 2>&1
                if [ $? -eq 0 ]
                then
                echo "$tool is available in your server and it's Version is:"
                java --version
                else
                echo "Now $tool will be installed"
                sudo apt-get update              
                sudo apt-get install openjdk-17-jre -y
                echo "$tool was succesfully installed and it's Version is:"
                java --version
                fi
                ;;
       "jenkins"|"Jenkins"|"JENKINS")
                echo "You have entered $tool " 
                jenkins --version > /dev/null 2>&1
                if [ $? -eq 0 ]
                then
                echo "$tool is available in your server and it's Version is:"
                jenkins --version
                else
                echo "Now $tool will be installed"
                sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
                echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
                sudo apt-get update
                sudo apt-get install openjdk-17-jre -y
                sudo apt-get install jenkins -y
                echo "$tool was succesfully installed and it's Version is:"
                jenkins --version
                jenkins_ip=`host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has" | awk '{print $4}'`
                jenkins_port=`sudo systemctl status jenkins | grep httpPort= | cut -d '=' -f 4`
                echo "Open your browser and Enter $jenkins_ip and port number is $jenkins_port"
                echo "You have to execute like this in your browser http://$jenkins_ip:$jenkins_port "
                sudo cat /var/lib/jenkins/secrets/initialAdminPassword
                echo " Paste the password in browser"
                fi
                ;;

esac

