pipeline {
    agent any

    environment {
        IMAGE_NAME = "mmt-backend"
        CONTAINER_NAME = "mmt-backend-container"
        APP_URL = "http://35.154.222.198:8000/api/v1/app/health/checkHealth"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/codhub-dev/MMT-Backend.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
                sh "docker push ${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy to Server') {
            steps {
                sshagent(['your-ssh-credentials']) {
                    sh """
                        ssh user@your-ec2-instance '
                        docker stop ${CONTAINER_NAME} || true
                        docker rm ${CONTAINER_NAME} || true
                        docker pull ${IMAGE_NAME}:latest
                        docker run -d --name ${CONTAINER_NAME} -p 8000:8000 ${IMAGE_NAME}:latest
                        '
                    """
                }
            }
        }

        stage('Post-Deployment Health Check') {
            steps {
                script {
                    def response = sh(script: "curl -s -o /dev/null -w '%{http_code}' ${APP_URL}", returnStdout: true).trim()
                    if (response != '200') {
                        error("Health check failed with status code: ${response}")
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh "docker image prune -f"
            }
        }
    }

    post {
        failure {
            echo "Deployment failed! Investigate the issue."
            // Optional: Add rollback logic here
        }
        success {
            echo "Deployment successful!"
        }
    }
}
