pipeline {
    agent any

    environment {
        TF_VERSION = '1.5.5' // Set the desired Terraform version
    }

    stages {
        stage('Install Terraform') {
            steps {
                // Install the specified Terraform version
                sh "curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
                sh "unzip terraform_${TF_VERSION}_linux_amd64.zip"
                sh "mv terraform /usr/local/bin/"
                sh "terraform version"
            }
        }

        stage('Checkout') {
            steps {
                // Checkout your Terraform configuration repository
                checkout scm
            }
        }

        stage('required AWS Service') {
            steps{
                // Change Directory to the required AWS Service
                cd "${params.AWS_SERVICE}"
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize the Terraform working directory
                sh "terraform init"
            }
        }

        stage('Terraform Plan') {
            steps {
                // Run Terraform plan and capture the output
                sh "terraform plan -out=tfplan"
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the Terraform plan
                sh "terraform apply -auto-approve tfplan"
            }
        }

        stage('Terraform Destroy') {
            steps {
                // Destroy the created infrastructure (optional)
                sh "terraform destroy -auto-approve"
            }
        }
    }

    post {
        always {
            // Clean up after execution
            sh "rm -f terraform_${TF_VERSION}_linux_amd64.zip"
            sh "rm -f tfplan"
        }
    }
}
