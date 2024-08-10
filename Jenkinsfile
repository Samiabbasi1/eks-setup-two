properties([
    parameters([
        string(
            defaultValue: 'dev',
            name: 'Environment',
            description: 'environment to deploy but doing on local so doesnt matter initially....'
        ),
        choice(
            choices: ['plan', 'apply', 'destroy'],
            name: 'terraform_actions',
            description: 'choose Terraform action'
        )
    ])
])

pipeline {
    agent any

    stages {
        stage('preparing') {
            steps {
                sh 'echo preparing'
            }
        }

        stage('pulling code from github') {
            steps {
                git branch: 'main', url: 'https://github.com/Samiabbasi1/eks-setup-two.git'
            }
        }

        stage('init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('action') {
            steps {
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
