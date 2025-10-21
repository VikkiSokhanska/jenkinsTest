pipeline {
    agent any

    environment {
        ENV_FILE = credentials('forum_env')
    }

    stages {
        stage('Clone repository') {
            steps {
                dir('repo') { // створюємо окрему папку
                    git branch: 'main', url: 'https://github.com/VikkiSokhanska/jenkinsTest.git'
                }
            }
        }

        stage('Create .env') {
            steps {
                dir('repo') {
                    sh 'echo "$ENV_FILE" > .env'
                }
            }
        }

        stage('Build and Run containers') {
            steps {
                dir('repo') {
                    sh '''
                    docker compose down || true
                    docker compose up -d --build
                    '''
                }
            }
        }
    }
}
