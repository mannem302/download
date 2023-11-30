#!/bin/bash 
echo "Below mentioned tool/Software can be installed as per your choice"
echo "Git"
echo "Java"
echo "Maven"
#echo "Jfrog"
echo "Tomcat"
#echo "Docker"
echo "Jenkins"
#echo "SonarQube"
#echo "Grafana"
#echo "Prometheus with Node Exporter"
read -p "Now you can install/download any devops tools/softwares by entering their name from above list:" tool 
my_system_ip()
{
   host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has" | awk '{print $4}'
}
tomcat_version()
{
tomcat_port=`sudo cat /var/lib/tomcat*/conf/server.xml | grep port= | cut -d '=' -f 2 | cut -d '"' -f 2 | head -2 | tail -1` > /dev/null 2>&1
tomcat_ip=`my_system_ip`
tomcat_user=`sudo cat /var/lib/tomcat*/conf/tomcat-users.xml | grep "manager-gui" | grep "username=" | cut -d "=" -f 2 | cut -d '"' -f 2`
tomcat_password=`sudo cat /var/lib/tomcat*/conf/tomcat-users.xml | grep "manager-gui" | grep "password=" | cut -d "=" -f 2 | cut -d '"' -f 2`
#read -p "Enter tomcat username: " username
#read -sp "Enter tomcat password: " password
version=`curl http://$tomcat_ip:$tomcat_port/manager/html -u ${tomcat_user}:${tomcat_password} | grep "Apache Tomcat" | cut -d ">" -f 3 | cut -d "<" -f 1 | cut -d " " -f 1,2`
echo "Tomcat Server Version is: $version"
}
jenkins_web()
{
  jenkins_ip=`my_system_ip`
  jenkins_port=`sudo systemctl status jenkins | grep httpPort= | cut -d '=' -f 4`
  #read -p "Enter your $tool username: " username
  #read -sp "Enter your $tool password: " password
  curl http://{jenkins_ip}:{jenkins_port} 
}
case $tool in
        "tomcat"|"Tomcat"|"TOMCAT")
           echo "You have entered $tool"
	         service=`sudo ls /usr/lib/systemd/system | grep tomcat*`
           cd /var/lib/tomcat*/conf > /dev/null 2>&1
           if [ $? -eq 0 ]
           then
           echo "Tomcat-Server was available in your system"
	         sudo systemctl restart $service  
	         tomcat_ip=`my_system_ip`
           tomcat_port=`sudo cat server.xml | grep port= | cut -d '=' -f 2 | cut -d '"' -f 2 | head -2 | tail -1` > /dev/null 2>&1
	         echo " Please wait process is going on .... "
	         sleep 5 
           sudo curl --connect-timeout 2 http://$tomcat_ip:$tomcat_port | grep tomcat > /dev/null 2>&1 
             if [ $? -eq 0 ]
             then
             tomcat_version
             echo "Now you can open browser http://$tomcat_ip:$tomcat_port"
	           echo "Your Tomcat-Server username is '$tomcat_user' and password is '$tomcat_password'"
             echo "$tool is working as expected"
             else 
	           tomcat_port=`sudo cat server.xml | grep port= | cut -d '=' -f 2 | cut -d '"' -f 2 | head -2 | tail -1` > /dev/null 2>&1
             alloted_port=`sudo systemctl status jenkins | grep httpPort= | cut -d '=' -f 4` 
               if [ $tomcat_port -eq $alloted_port ]
               then
               echo " $tomcat_port is using by jenkins, so automatically tomcat port will assign to another available port"
               sudo sed -i 's/8080/8081/g' /var/lib/tomcat9/conf/server.xml 2>&1
               sudo systemctl restart $service
	             echo "Please wait process is going on .... "
	             sleep 5 
               sudo curl --connect-timeout 2 http://$tomcat_ip:$tomcat_port | grep tomcat > /dev/null 2>&1
                 if [ $? -eq 0 ] 
                 then
                 tomcat_version
                 echo "Now you can open browser http://$tomcat_ip:$tomcat_port"
                 else
                 echo "You need to allow the port number $tomcat_port in security groups"
                 fi
               else
               echo "You need to allow the port number $tomcat_port in security groups"
               fi
             fi
           else
           echo "Now $tool will be installed"
           sudo apt-get update
           sudo apt-get install openjdk-11-jre -y
           sudo apt-get install tomcat9 tomcat9-admin -y
	         cd ~
           wget https://raw.githubusercontent.com/mannem302/download/master/tomcat-users.xml
           sudo mv ~/tomcat-users.xml /var/lib/tomcat9/conf/tomcat-users.xml
           echo "$tool was installed sucessfully and users was configured"
           tomcat_port=`sudo cat /var/lib/tomcat*/conf/server.xml | grep port= | cut -d '=' -f 2 | cut -d '"' -f 2 | head -2 | tail -1` > /dev/null 2>&1
           tomcat_ip=`my_system_ip`
           tomcat_user=`sudo cat /var/lib/tomcat*/conf/tomcat-users.xml | grep "manager-gui" | grep "username=" | cut -d "=" -f 2 | cut -d '"' -f 2`
           tomcat_password=`sudo cat /var/lib/tomcat*/conf/tomcat-users.xml | grep "manager-gui" | grep "password=" | cut -d "=" -f 2 | cut -d '"' -f 2`
           sudo curl --connect-timeout 2 http://$tomcat_ip:$tomcat_port | grep tomcat > /dev/null 2>&1
             if [ $? -eq 0 ]
             then
             echo "Now you can open browser using the URL http://$tomcat_ip:$tomcat_port"
             echo "Default username- '$tomcat_user' and default password- '$tomcat_password'"
             else
             sudo curl --connect-timeout 2 http://$tomcat_ip:$tomcat_port | grep tomcat > /dev/null 2>&1
             if [ $? -ne 0 ]
             then
             echo "You need to allow the port number $tomcat_port in security groups"
             fi
             alloted_port=`sudo systemctl status jenkins | grep httpPort= | cut -d '=' -f 4`
               if [ $tomcat_port -eq $alloted_port ]
               then
               echo " $tomcat_port is using by jenkins, so automatically tomcat port will assign to another available port"
               sudo sed -i 's/8080/8081/g' /var/lib/tomcat*/conf/server.xml 2>&1
               sudo systemctl restart tomcat9.service 
	             echo "Please wait process is going on .... "
	             sleep 6
	             tomcat_port=`expr $alloted_port + 1`
	             echo " $tomcat_port is now allocated to $tool" 
               sudo curl --connect-timeout 4 http://$tomcat_ip:$tomcat_port | grep tomcat > /dev/null 2>&1
                 if [ $? -eq 0 ] 
                 then
                 tomcat_version
                 echo "Now you can open browser http://$tomcat_ip:$tomcat_port"
		             echo "Default username- '$tomcat_user' and default password- '$tomcat_password'"
                 else
                 echo "You need to allow the port number $tomcat_port in security groups"
                 fi
               else
               echo "You need to allow the port number $tomcat_port in security groups"
               fi
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
                echo "$tool was installed sucessfully and it's Version is:"
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
                echo "$tool was installed sucessfully and it's Version is:"
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
                sudo apt-get install openjdk-11-jre -y		
                echo "$tool was installed sucessfully and it's Version is:"
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
                jenkins_ip=`my_system_ip`
                jenkins_port=`sudo cat /lib/systemd/system/jenkins.service | grep "JENKINS_PORT" | cut -d "=" -f 3 | cut -d '"' -f 1`
                service=`sudo ls /usr/lib/systemd/system | grep jenkins`
                echo "Please wait process is going on ...."
                sudo systemctl restart $service
                echo "Please wait $tool URL generation under progress .... wait 70 sec's only"
                sleep 70
                sudo curl --connect-timeout 2 http://$jenkins_ip:$jenkins_port  > /dev/null 2>&1
                  if [ $? -eq 0 ]
                  then
                  echo "Open your browser and Enter http://$jenkins_ip and port number is $jenkins_port"
                  echo "You have to execute like this in your browser http://$jenkins_ip:$jenkins_port "
                  echo "$tool server is working as expected "
                  else
                  alloted_port=`sudo cat /var/lib/tomcat*/conf/server.xml | grep port= | cut -d '=' -f 2 | cut -d '"' -f 2 | head -2 | tail -1` > /dev/null 2>&1
                  jenkins_port=`sudo cat /lib/systemd/system/jenkins.service | grep "JENKINS_PORT" | cut -d "=" -f 3 | cut -d '"' -f 1` 
                    if [ $jenkins_port -eq $alloted_port ]
                    then
                    echo "$jenkins_port is using by tomcat, so automatically jenkins port will assign to another available port"
                    sudo sed -i 's/8080/8081/g' /lib/systemd/system/jenkins.service 2>&1
                    sudo systemctl daemon-reload
                    service=`sudo ls /usr/lib/systemd/system | grep jenkins`
                    sudo systemctl restart $service
	                  echo "Please wait process is going on .... wait 130 Sec's only"
	                  sleep 130 
                    jenkins_port=`sudo cat /lib/systemd/system/jenkins.service | grep "JENKINS_PORT" | cut -d "=" -f 3 | cut -d '"' -f 1`
                    sudo curl --connect-timeout 2 http://$jenkins_ip:$jenkins_port | grep jenkins > /dev/null 2>&1
                      if [ $? -eq 0 ] 
                      then
                      echo "Open your browser and Enter $jenkins_ip and port number is $jenkins_port"
                      echo "You have to execute like this in your browser http://$jenkins_ip:$jenkins_port "
                      echo "$tool is working as expected "
                      else
                      echo "You need to allow the port number $jenkins_port in security groups"
                      fi
                    else
                    echo "You need to allow the port number $jenkins_port in security groups"
                    fi
                  fi
                else
                echo "Now $tool will be installed"
                sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
                echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
                sudo apt-get update
                sudo apt-get install openjdk-11-jre -y
                sudo apt-get install jenkins -y
                echo "$tool was installed sucessfully and it's Version is:"
                jenkins --version
                echo "Please wait process is going on....."
                jenkins_ip=`my_system_ip`
                jenkins_port=`sudo cat /lib/systemd/system/jenkins.service | grep "JENKINS_PORT" | cut -d "=" -f 3 | cut -d '"' -f 1` > /dev/null 2>&1
                alloted_port=`sudo cat /var/lib/tomcat*/conf/server.xml | grep port= | cut -d '=' -f 2 | cut -d '"' -f 2 | head -2 | tail -1` > /dev/null 2>&1
                sleep 10
                sudo curl --connect-timeout 2 http://$jenkins_ip:$jenkins_port | grep Authentication > /dev/null
                 if [ $? -ne 0 ] && [ $alloted_port -eq $jenkins_port ]
                 then
                 echo "$jenkins_port to be allowed in security groups or it is using by other services and now $jenkins_port will be changed"
                 sudo sed -i 's/8080/8081/g' /lib/systemd/system/jenkins.service 2>&1
                 sudo systemctl daemon-reload
                 service=`sudo ls /usr/lib/systemd/system | grep jenkins`
                 sudo systemctl restart $service
	               echo "Please wait process is going on .... wait 130 Sec's only"
                 jenkins_port1=`expr $alloted_port + 1`
                 jenkins_port=`sudo cat /lib/systemd/system/jenkins.service | grep "JENKINS_PORT" | cut -d "=" -f 3 | cut -d '"' -f 1` > /dev/null 2>&1
                 sleep 130
                 sudo curl --connect-timeout 4 http://$jenkins_ip:$jenkins_port | grep Authentication > /dev/null 2>&1
                  if [ $? -eq 0 ]
                  then
                  echo "Open your browser and Enter $jenkins_ip and port number is $jenkins_port"
                  echo "You have to execute like this in your browser http://$jenkins_ip:$jenkins_port "
                  echo "-------------------------------------"
                  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
                  echo "-------------------------------------"
                  echo "Copy the above line and paste it in the 'Administrator password' field"
                  else
                  echo "You need to allow the port number $jenkins_port in security groups"
                  fi
                 else
                 echo "Open your browser and Enter $jenkins_ip and port number is $jenkins_port"
                 echo "You have to execute like this in your browser http://$jenkins_ip:$jenkins_port "
                 echo "-------------------------------------"
                 sudo cat /var/lib/jenkins/secrets/initialAdminPassword
                 echo "-------------------------------------"
                 echo "Copy the above displayed password and paste it in the 'Administrator password' field in your browser"
                 fi
                fi
                ;;
                *)
                echo "Invalid Selection, Please enter the valid name as shown below"
                echo "git/Git/GIT | tomcat/Tomcat/TOMCAT | maven/Maven/MAVEN | java/Java/JAVA | jenkins/Jenkins/JENKINS" 

esac

