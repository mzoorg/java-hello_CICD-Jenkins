def SSH_PRV
def SSH_PUB

node {
  SSH_PRV = sh(returnStdout: true, script: 'cat /var/lib/jenkins/.ssh/id_rsa')
  SSH_PUB = sh(returnStdout: true, script: 'cat /var/lib/jenkins/.ssh/id_rsa.pub')
}

pipeline {
    environment {
        nexus_rep = '178.154.222.201:5555'
        deploy_node = '178.154.226.81'
    }
    agent {
        dockerfile {
            dir '.'
            additionalBuildArgs "--build-arg ssh_prv_key=${SSH_PRV} --build-arg ssh_pub_key=${SSH_PUB}"
            args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('git') {
            steps {
                git 'https://github.com/mzoorg/boxfuse-orig.git'
            }
        }
        
        stage('build app') {
            steps {
                sh 'mvn package'
            }
        }
        
        stage('push image') {
            steps {
                sh 'cp /deployer/Dockerfile .'
                script {
                    docker.withRegistry('http://$nexus_rep', '6e8c82ea-da4c-4fc3-9688-f7272da3f141') {
                        app_image = docker.build('$nexus_rep/boxfuseapp')
                        app_image.push()
                    }
                }
            }
        }
        
		stage('deploy via ssh') {
			steps {
				sh 'ssh-keyscan -H $deploy_node >> ~/.ssh/known_hosts'
                sh '''ssh root@$deploy_node << EOF
						docker run -it -d -p 80:8080 $nexus_rep/boxfuseapp
                    '''
			}
		}
    }
}

/*
//нерабочий вариант через докер-демон

        stage('deploy app') {
            steps {
                script {
                    docker.withServer('tcp://10.128.0.36:2375','') {
                       docker.image('$nexus_rep/boxfuseapp').withRun('-p 8080:8080') {
					   }
                    }
                }
            }
        }
*/
