FROM jenkins/jenkins:latest
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Install AWS CLI
USER root
RUN apt-get update && \
    apt-get install -y curl unzip awscli 

# Copy the Groovy initialization script into the container
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

# Switch back to Jenkins user
USER jenkins
