pipeline {
    agent any
    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'project-1', url: 'git@github.com:your/repo.git'
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

