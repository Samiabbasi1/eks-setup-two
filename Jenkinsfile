pipeline{
    agent any

    parameters {
        booleanParam(name: 'PLAN_TERRAFORM', defaultValue : false, description:'Check to plan Terraform changes')
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue : false, description:'Check to apply Terraform changes')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue : false, description:'Check to apply Terraform changes')
    }

    stages{
        stage('Clone Directory'){
            steps{
                deleteDir()
                git branch:'main',
                    url: 'https://github.com/Samiabbasi1/eks-setup-two.git'

                sh "ls -lart"
            }
        }
        stage('Terraform init'){
            steps{
                withCredentials([[$class:'AmazonWebServicesCredentialsBinding',credentialsId:'aws-credentials-sami']]){
                    dir('root'){
                        sh "terraform init"
                    }
                }
            }
        }
        stage('terraform plan'){
            steps{
                script{
                    if(params.PLAN_TERRAFORM){
                        withCredentials([[$class:'AmazonWebServicesCredentialsBinding',credentialsId:'aws-credentials-sami']]){
                            dir('root'){
                                sh 'terraform plan'
                            }
                        }
                    }
                }
            }
        }
        stage('terraform apply'){
            steps{
                script{
                    if(params.APPLY_TERRAFORM){
                        withCredentials([[$class:'AmazonWebServicesCredentialsBinding',credentialsId:'aws-credentials-sami']]){
                            dir('root'){
                                sh 'terraform apply --auto-approve'
                            }
                        }
                    }
                }
            }
        }
        stage('terraform destroy'){
            steps{
                script{
                    if(params.DESTROY_TERRAFORM){
                        withCredentials([[$class:'AmazonWebServicesCredentialsBinding',credentialsId:'aws-credentials-sami']]){
                            dir('root'){
                                sh 'terraform destroy --auto-approve'
                            }
                        }
                    }
                }
            }
        }
    }
}
