pipeline {
    agent any

    environment {
        AWS_REGION = 'us-west-1'
        ECR_REPO = 'my-ecr-repo'
        IMAGE_TAG = 'latest'
        TF_DIR = './jenkins'  
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    sh "cd $TF_DIR && terraform init"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Run Terraform Plan to see the changes that will be applied
                    sh "cd $TF_DIR && terraform plan -var 'region=$AWS_REGION'"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the Terraform plan to create resources
                    sh "cd $TF_DIR && terraform apply -auto-approve -var 'region=$AWS_REGION'"
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    def loginCmd = sh(script: "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com", returnStdout: true).trim()
                    echo loginCmd
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "docker tag $ECR_REPO:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG"
                    sh "docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG"
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                script {
                    def ecsServiceUpdate = sh(script: """
                        aws ecs update-service \
                            --cluster my-cluster \
                            --service my-service \
                            --force-new-deployment \
                            --image $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
                    """, returnStdout: true).trim()
                    echo ecsServiceUpdate
                }
            }
        }
    }
}
