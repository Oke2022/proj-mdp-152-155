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

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-secret', variable: 'KUBECONFIG')]) {
                    sh '''
                        echo "Using kubeconfig at $KUBECONFIG"

                        # Replace image line in deployment file with the latest tag
                        sed -i "s|image:.*|image: $DOCKERHUB_REPO:$DOCKER_TAG|" $K8S_DEPLOYMENT_PATH

                        kubectl apply -f $K8S_DEPLOYMENT_PATH
                        kubectl apply -f $K8S_SERVICE_PATH
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

