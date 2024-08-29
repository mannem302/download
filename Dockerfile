# Use the official Jenkins image from Docker Hub
FROM jenkins/jenkins:lts

# Install AWS CLI
USER root
RUN apt-get update && \
    apt-get install -y curl unzip awscli 

# Set PATH to include AWS CLI for Jenkins user
RUN echo 'export PATH=$PATH:/usr/local/bin' >> /etc/profile

# Copy the Groovy initialization script into the container
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/

# Skip initial setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Switch back to Jenkins user
USER jenkins
