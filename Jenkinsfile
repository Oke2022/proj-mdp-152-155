pipeline {
    agent any
    
     stages {
        stage('Checkout') {
            steps {
                  checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('calculator-app')
                }
            }
        }
        stage('Run Container') {
            steps {
                script {
                    docker.image('calculator-app').run('-p 8080:8080')
                }
            }
        }
    }
}

