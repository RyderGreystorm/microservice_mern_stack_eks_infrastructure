properties([
    parameters([
        string (
            defaultValue: 'terraform',
            name: 'Variables'
        ),
        choice(
            choices: ['plan', 'apply', 'destroy'],
            name: 'Execution_choice'
        )
    ])
])

pipeline {
    agent any
    stages {
        stage('Preparing') {
            steps {
                sh 'echo  Preparing to install infrastructure'
            }
        }
        stage('Workspace Cleanup') {
            steps {
                deleteDir()
            }
        }
        stage('Git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/RyderGreystorm/projects'
            }
        }
        stage('Terraform Init') {
            steps {
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                    sh 'terraform -chdir=microservice_mern_stack_eks_infrastructure/eks_cluster/ init'
                }
            }
        }
        stage('Terraform validate') {
            steps {
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                    sh 'terraform -chdir=microservice_mern_stack_eks_infrastructure/eks_cluster/ validate'
                }
            }
        }
        stage('Action Choice') {
            steps {
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                    script {
                        try {
                            if (params.Execution_choice == 'plan') {
                                sh "terraform -chdir=microservice_mern_stack_eks_infrastructure/eks_cluster/ plan -var-file=${params.Variables}.tfvars"
                            } else if (params.Execution_choice == 'apply') {
                                sh "terraform -chdir=microservice_mern_stack_eks_infrastructure/eks_cluster/ apply -var-file=${params.Variables}.tfvars -auto-approve"
                            } else if (params.Execution_choice == 'destroy') {
                                sh "terraform -chdir=microservice_mern_stack_eks_infrastructure/eks_cluster/ destroy -var-file=${params.Variables}.tfvars -auto-approve"
                            } else {
                                error "Invalid value for Execution_choice: ${params.Execution_choice}"
                            }
                        } catch (Exception e) {
                            error "Terraform ${params.Execution_choice} failed: ${e.message}"
                        }
                    }
                }
            }
        }
    }
}
