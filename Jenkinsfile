pipeline {
    agent any
    
    environment {
        GIT_SSH_COMMAND = 'ssh -o StrictHostKeyChecking=no'
    }
    stages {
        stage('Clone Repo') {
            steps { 
              git credentialsId: 'github-access',
                git branch: 'project-1', url: 'https://github.com/Oke2022/proj-mdp-152-155.git'
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

