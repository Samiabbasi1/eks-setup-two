properties([
    parameters([
        string(
            defaultValue: 'dev',
            name: 'Environment',
            description: 'Environment to deploy, but doing it on local so doesn\'t matter initially...'
        ),
        choice(
            choices: ['plan', 'apply', 'destroy'],
            name: 'terraform_actions',
            description: 'Choose Terraform action'
        )
    ])
])

pipeline {
    agent any

    stages {
        stage('preparing') {
            steps {
                echo 'Preparing the environment...'
            }
        }

        stage('pulling code from GitHub') {
            steps {
                git branch: 'main', url: 'https://github.com/Samiabbasi1/eks-setup-two.git'
            }
        }

        stage('terraform init') {
            steps {
                dir('/root') {  
                    sh 'terraform init'
                }
            }
        }

        stage('terraform validate') {
            steps {
                dir('/root') {  
                    sh 'terraform validate'
                }
            }
        }

        stage('terraform action') {
            steps {
                dir('/root') {  
                    script {
                        if (params.terraform_actions == 'plan') {
                            sh "terraform plan"
                        } else if (params.terraform_actions == 'apply') {
                            sh "terraform apply --auto-approve"
                        } else if (params.terraform_actions == 'destroy') {
                            sh "terraform destroy --auto-approve"
                        } else {
                            error "Invalid value for action"
                        }
                    }
                }
            }
        }
    }
}

