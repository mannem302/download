#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.install.*
import jenkins.model.JenkinsLocationConfiguration

import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.cloudbees.plugins.credentials.SystemCredentialsProvider

// Initialize Jenkins instance
def instance = Jenkins.getInstance()

// Set up security realm and authorization strategy
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)

// Save the Jenkins configuration
instance.save()

// Adding SSH credentials with username and private key
def privateKey = """-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA6/7DIkwHHyNKE9MdaIGi4v+40+tcSCZsBtG2cLYdfh/NmSHw
i6J1en+Tip6OLX9TWNHnrsS0Kjk/c5IUDpxEZy64oCyPhi6xe73YyWGw1+cuLmfC
Sgu7o6ssHnZvW4ThWiswYy3S8J52SE1c/NrvBfWeiccn34ecwM4bTghrrexAyMoJ
/6ukB6Y1lvOUVXFicJlUPS3Lzy3sk5MvyvqbXTroJAcM34e0LvIMa78OK4KjdfWm
QMddIs7r44Kqzxc6DyDj+fh7wio20cU0gEOxlZvjyRP8GXmLNEMrZeVvdSNR4Owi
YYvED9LXR+wg+JXBBfWWnx/MMyB3nKjy36vU2QIDAQABAoIBAB4NsZf6iqWiftqL
diFK8Q1rd4Q1YuklS3iK2Gr+Jj9bmXk440NFCyTwfj+W9ZBBuMGE6bZOAoumArib
D8bUi7mAL67mPdjetWeGw8bRlA3KuQzb1dhMKjcro1C10HSdNX2gJmda/JP7+iA3
CfKBhxMBNpFhNWi4AnRjSwLi+6OIRhQZumIy5Z+ZGTU/Sr03bILVhnZTtFKX8suN
vAXudwStR0cAhl9OXraQs+BlQg41LOwX1EmLXRR6kDqJlozjV3WZfCeNk6ALxqz5
iUw/LPT+WRk2Z6xpwVZeL8aMVpQAqKW6Bcqlxr9EcsHE4LKx9blnIgAaZmYYG53H
NzGDaUkCgYEA+MGQMOO0s0O8O4yeD/c0ymB7RhP9m0lLRVmDf0RjEL2zctjMA//3
Yt+f5D/95jvYrj6BztiZe5Zu+YHlenRI1ComoVFEQ25L8npgCbRaKUM4kI/8FNG9
BG7uxCJms0bytrp4xkLIpoH/2iw4N+tVXxQes6xv4HKUjz0BZr97oW8CgYEA8t4R
d5H03DLt8IVhW37eQESRWPJ2OkSapqDsbZtP67M2W/L1bN+p5gwKnPECyH89J8ns
7aI5VW/ru/6LbSJ+RL0DCl9HuQtvovn1I7+RKACSnuCGHcraGm29uzmNq0yz3kBw
67Zc/d33vBLw/1Vvuruk2IrgTt+SisMSceiHOjcCgYEA6s+UM4IOJZWPzkprPbjl
PQ+b7cebAgVKpxjbFrxQIxJenM9mrXPmao+a15NMMRNW8wuP7tfo8Y9MC/wAyPmR
caykMGyM2nX3/NhlZWO4I/EPKO6xTlm5acDpY3zxotMa8z/MF6Ic04gtIh3Rp39e
Y9STMplYNe8Sqq80bm/b3MMCgYEAllRqz25i+GH18ik9aBsRiwpmRX5fPBX2/Ckj
73xxbd3SSfwLeka/rYvKjfaI2H4Z5qUQqM7/Wika65TVzMnLCtVMKoFrrdisU18R
I/2R5gbkur8ThSFo+27uQBOR43Ro6atNujl5OhLJI3s9/W5u6FD56qebzHaLCKVS
p3tdKOUCgYEA1BT1NqohWm4OWX+R8E550k/aEAecOHjUhoCvU/bCmZOYmFr+GdUr
1Rx/USlNATK57BSvYlRKMJlKdJ22Bc/423ZS4WAearHeXX41xfMYYA+wdG1or911
SxvRglOHu7rxbuq0O3vsl9oKGmIjMMiSjv+OdwjoR/pPpg4spyqWSbY=
-----END RSA PRIVATE KEY-----
""".stripIndent().trim()

def sshKeyCredentials = new BasicSSHUserPrivateKey(
    CredentialsScope.GLOBAL,
    "TA_CONNECT",             // ID for the credentials
    "ubuntu",              // SSH Username
    new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(privateKey),
    "",                          // Passphrase (if any)
    "JAT_KEY"     // Description of the credentials
)

SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), sshKeyCredentials)

println("SSH credentials added successfully.")
