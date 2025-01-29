pipeline {
    agent any
    environment {
        IMAGE_NAME = "my-ecr-app"
        IMAGE_TAG = "v${BUILD_NUMBER}"
        AWS_REGION = "us-west-1"
        ECR_REPO = "891377009188.dkr.ecr.us-west-1.amazonaws.com/demo-ecr-repo"
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
                }
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh 'docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}'
                    sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}'
                    sh 'docker push ${ECR_REPO}:${IMAGE_TAG}'
                }
            }
        }         


    }
}