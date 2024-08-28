# Use the official Jenkins image from Docker Hub
FROM jenkins/jenkins:lts

# Copy the Groovy initialization script into the container
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/

# Skip initial setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
