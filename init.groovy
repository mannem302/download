#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.install.*
import hudson.PluginManager
import jenkins.model.JenkinsLocationConfiguration

// Define the default plugins you want to install
def plugins = [
    'git', // Git plugin
    'pipeline', // Pipeline plugin
    'workflow-aggregator', // Workflow Aggregator plugin
    'blueocean', // Blue Ocean plugin
    'docker-workflow', // Docker Workflow plugin
    'github', // GitHub plugin
    'maven-plugin' // Maven Integration plugin
]

def instance = Jenkins.getInstance()

// Set up security realm and authorization strategy
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)

// Save the configuration
instance.save()

// Install default plugins
def pluginManager = instance.getPluginManager()
def updateCenter = instance.getUpdateCenter()

plugins.each { pluginName ->
    def plugin = updateCenter.getPlugin(pluginName)
    if (plugin && !plugin.isInstalled()) {
        println "Installing ${pluginName} plugin..."
        plugin.deploy()
        plugin.getPluginManager().install(plugin.getShortName(), false)
    }
}

// Wait for plugins to be installed
def waiting = true
while (waiting) {
    waiting = pluginManager.getPlugins().findAll { !it.isEnabled() }.size() > 0
    sleep(5000)
}

// Restart Jenkins to apply changes
println "Restarting Jenkins..."
Jenkins.getInstance().restart()
