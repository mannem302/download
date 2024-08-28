# Use the official Jenkins image from Docker Hub
FROM jenkins/jenkins:lts

# Install AWS CLI
USER root
RUN apt-get update && \
    apt-get install -y curl unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Switch back to Jenkins user
USER jenkins

# Copy the Groovy initialization script into the container
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/

# Skip initial setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false


