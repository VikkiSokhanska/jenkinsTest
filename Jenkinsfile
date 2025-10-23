pipeline {
    agent any

    environment {
        ENV_FILE = credentials('forum_env')
    }

    stages {
        stage('Create .env') {
            steps {
                sh 'echo "$ENV_FILE" > .env'
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
