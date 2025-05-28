pipeline { 
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds') 
        DOCKER_IMAGE = 'calculator-app'
        DOCKER_TAG = 'latest'
        DOCKERHUB_REPO = 'okejoshua/calculator-app'
    }

    stages {
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

        stage('Run Container') {
            steps {
		sh '''
		# Remove any existing container with the same name
		docker rm -f calculator-app || true

		# Run the new container version with a fixed name
		docker run -d --name calculator-app -p 9090:8080 $DOCKER_IMAGE:$DOCKER_TAG'
		'''
            }
        }
    }
}

