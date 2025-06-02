pipeline { 
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds') 
        DOCKER_IMAGE = 'calculator-app'
        DOCKER_TAG = 'latest'
        DOCKERHUB_REPO = 'okejoshua/calculator-app'
        K8S_DEPLOYMENT_PATH = 'kubernetes/deployment.yml'
        K8S_SERVICE_PATH = 'kubernetes/service.yml'
    }

    stages {
	stage('Clean Workspace Before Build') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
            }
        }

        stage('Tag Image for Docker Hub') {
            steps {
                sh 'docker tag $DOCKER_IMAGE:$DOCKER_TAG $DOCKERHUB_REPO:$DOCKER_TAG'
            }
        }

        stage('Docker Hub Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh 'docker push $DOCKERHUB_REPO:$DOCKER_TAG'
            }
        }

        stage('Run Ansible Playbook to Deploy to Kubernetes') {
	     steps {
                sshagent(['ansible-ssh-key']) {
            	    sh '''
                	ssh -o StrictHostKeyChecking=no ubuntu@10.0.0.140 '
			cd /home/ubuntu/proj-mdp-152-155 &&
                	ansible-playbook -i ansible/inventory/host.ini ansible/playbooks/k8s-app-deploy.yml
                	'
            	    '''
        	}	
            }

	}
    }
    post {
        always {
            cleanWs()
        }
    }
}

