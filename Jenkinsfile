pipeline {
    agent any

    environment {
        AWS_REGION = 'us-west-1'
        ECR_REPO = 'my-ecr-repo'
        IMAGE_TAG = 'latest'
    }

    

        stage('Init') {
            steps {
                dir('ecr-repo') {
                    sh 'terraform init'
                }
            }
        }

        stage('Plan') {
            steps {
                dir('ecr-repo') {
                    echo "Running terraform plan....."
                    sh 'terraform plan'
                }
            }
        }

        stage('Apply') {
            steps {
                dir('ecr-repo') {
                    echo "Running terraform apply..."
                    sh 'terraform apply -auto-approve'
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
    }
