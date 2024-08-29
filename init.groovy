#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.install.*
import jenkins.model.JenkinsLocationConfiguration

def instance = Jenkins.getInstance()

// Set up security realm and authorization strategy
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)

// Save the configuration
instance.save()

