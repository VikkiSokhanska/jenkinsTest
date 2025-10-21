pipeline {
    agent any

    environment {
        ENV_FILE = credentials('forum_env')
    }

    stages {
        stage('Clone repository') {
            steps {
                git branch: 'main', url: 'https://github.com/VikkiSokhanska/jenkinsTest.git'
            }
        }

        stage('Create .env') {
            steps {
                sh 'cp "$ENV_FILE" .env'
            }
        }

        stage('Build and Run containers') {
            steps {
                sh '''
                docker compose down || true
                docker compose up -d --build
                '''
            }
        }
    }
}
