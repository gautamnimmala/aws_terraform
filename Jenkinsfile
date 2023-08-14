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
                sh "sudo mv terraform /usr/local/bin/"
                sh "terraform version"
            }
        }

        stage('Checkout') {
            steps {
                // Checkout your Terraform configuration repository
                checkout scm
            }
        }

        stage('Terraform init, plan, apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "aws-terraform",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']] ){
                             dir("${params.AWS_SERVICE}"){
                                //Run Terraform commands
                                sh '''
                                aws configure set region eu-central-1
                                aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                                aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                                
                                echo "Initializing Terraform"
                                terraform init

                                echo "Planning terraform changes"
                                terraform plan -out=AWS_VPC

                                echo "Applying Terraform changes"
                                terraform apply -auto-approve AWS_VPC

                                echo "Terrform deployment completed!"
                                '''
                }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {params.DESTROY == yes}
            }
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "aws-terraform",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']] ){
                             dir("${params.AWS_SERVICE}"){
                                //Run Terraform commands
                                sh '''
                                aws configure set region eu-central-1
                                aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                                aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                                
                                echo "Initializing Terraform"
                                terraform destroy -auto-approve
                                '''
                            }
                    }
            }
        }
    }
    post {
        always {
            // Clean up after execution
            sh "rm -f terraform_${TF_VERSION}_linux_amd64.zip"
            sh "rm -f AWS_VPC"
        }
    }
}

