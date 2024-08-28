#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.install.InstallState
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*

// Initialize Jenkins instance
def instance = Jenkins.getInstance()

// Create a new user with the username "admin" and password "admin"
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin")
instance.setSecurityRealm(hudsonRealm)

// Set the authorization strategy to Full Control Once Logged In
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)

// Install default plugins and SSH Agent plugin
def pluginManager = instance.getPluginManager()
def updateCenter = instance.getUpdateCenter()
def requiredPlugins = ['git', 'workflow-aggregator', 'docker-workflow', 'ssh-agent']

println "Checking if required plugins are installed..."
requiredPlugins.each { plugin ->
    if (!pluginManager.getPlugin(plugin)) {
        println "Installing plugin: ${plugin}"
        updateCenter.getPlugin(plugin).deploy()
    }
}

// Create SSH credentials with username and private key
def credentialsStore = instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
def privateKey = ''' -----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAuJtynHPXRwon8SmQkKEaE/Zh68Z9uPc9YrhlncnSHsgRGrSZ
Txo9/+NZ+206+usHtnEpIj8lGs37ATQ79rbl+7BQkwNQq1XNeN1AZ4StHqDZloZ8
bWYSGFakMwzb0C+O6kM/LAWIXVyszm/5j/DGEZRVPcMCF1dqD+06zLmXIke04+NR
PzMFc+RCfrRJm7lmY+D0A4lP3ODbUv9lDDWn3NianU73HDCYzqzj3gUCtXrOMrHP
4gLpPqm5TstHk7Y0wOLdA7ug6WpXhvLpmEa6LIt4vm4O1v8IV7/QUHaD+Hb8pF0/
+W5Xf3yf7ps5nEsGuo0N+mCPuVi8k4qPm3fvYQIDAQABAoIBABU42Y4eywrBoiHZ
M2NNAeB1nIAsS1uuIIJuzE+9WchsG3tEc7NiQupdyoRa5ELgLfzNOXtUYwGX2Fkl
FhegowOyGzErWmS38m0IklTULcqtlxX00+0HpODjZPDxc3uVXAqWPHblE+4Xr030
FW50sXBn6vy0pFLmm6zFCtNqKnOoNKm6X12H9zx0gPx3F5xpTYmeWmxIBlFRNzzQ
RZpTdWaBMnh7ll4Gj8pFdi2hFyPURW82iShu1ocgnjMUhTkn8VRG9WoxqEyMm2Ut
/jjqFhT4d18tuAuBBgutZKBu7+YqzGvBXX7KOpd0nyGzxtvWQc4iz33olQP50UsB
UopsRjkCgYEA2dl3QDRcal13woFYP0I60gcpqUtjLbhzcPMtDfIEt+EQQO4ijjda
mKHC5gj/5p8npLq0CESStUrOWxlJsmsqtZYmDoJ01O1xdknkw/bpgXX0N6kXaZoa
o2QZM3tlybpcuOaW2A7QZ8HRaT8Pbt/4a88kboxNHdWjNiVNQjCFDS8CgYEA2O+t
4ZxK21yzq+0L+40uDOOveag7P4XT8jj3S6o6MGjV+hPRc8fJOxE2XJjmxigDm4VP
7de/NMTtMi6eLtLgoeLlQKLhLpXMtWmWw5psAK3xBBGQTPxuXZaidPJNZzpF8Sce
O9/AwJaejalmH7JuRsYCspHjOxiNdFNf+gqOSG8CgYADr7dh4cDyl9RP+UpZ/6/p
H+/ninwKKQXjEmpfwwmrZuaUgrMY/vzMemhG5j4WU/kiw3oKbcahxLtLNVlW6JNX
cUwBkNmTRNVXsBZr7oCzDSDt1DGuOspam3YFtf/Z8wpgop5I169VIiV+B3AmaynU
ATRXno4rhBL39pehGBsYRwKBgBH5WdjVkEY4mhJmo5WGDwi2XLWhwLb0qajqG2ND
iWq1ZPVBaxtCtGOWe4CUkppcemAKXaMBOzBuGJEN18Fda4s+N2xxkmK/uqRVSU6P
nt83ij6iDeizCZnrfy5dXRhudZkTeqfPVDMgx6ZJINMDf6uRgGu3NrKQyDeZKNyY
v001AoGAU1foHceshDxKBsZE5b4k5HjzfbM/ep/U3QF1VnC/H2j4qOI/iIV0gc/m
8w0dNQPHyz21QjSL/dX5Z1ytSTdFIm97SDXXWSI43mxvBN2MQ9mqgR14Zp6cS04z
DoxaOGOa3J+pwd7IE1m+ydk26t0/qGkVsjIRj+Y2Nlu2BlWNmhw=
-----END RSA PRIVATE KEY-----'''

def sshCredentials = new BasicSSHUserPrivateKey(
    CredentialsScope.GLOBAL,
    "ubuntu",               // SSH Username
    new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(privateKey),
    "",                            // No passphrase
    "Ansible_Server"  // Description
)

credentialsStore.addCredentials(Domain.global(), sshCredentials)

// Mark Jenkins as fully initialized
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

instance.save()
