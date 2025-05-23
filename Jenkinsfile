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
              sh 'docker build -t calculator-app .'
            }
        }

        stage('Run Container') {
            steps {
              sh 'docker run -d -p 8080:8080 calculator-app'
            }
        }

      }
 }

