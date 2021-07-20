pipeline {
    agent any

    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "Terraform 1.0.1"
    }
    
    parameters {
        string(name: 'CONSUL_STATE_PATH', defaultValue: 'networking/state/globo-primary', description: 'Path in Consul for state data')
        string(name: 'WORKSPACE', defaultValue: 'development', description:'workspace to use in Terraform')
    }
    
    environment {
        TF_HOME = tool('Terraform 1.0.1')
        TF_INPUT = "0"
        TF_IN_AUTOMATION = "TRUE"
        TF_VAR_consul_address = "host.docker.internal"
        TF_LOG = "WARN"
        AWS_ACCESS_KEY_ID = credentials('aws_access_key')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
        PATH = "$TF_HOME:$PATH"
    }
    

    stages {
        stage('Build') {
            steps {
                // git 'https://github.com/MariCarmenSaldivar/tf-jenkins.git'
                dir('awsinfra/networking-template/'){
                    sh 'terraform --version'
                    sh "terraform init --backend-config='path=${params.CONSUL_STATE_PATH}'"
                }
            }
        }
        stage('InfraValidate'){
            steps {
                dir('awsinfra/networking-template/'){
                    sh 'terraform validate'
                }
            }
        }
        stage('InfraPlan'){
            steps{
                dir('awsinfra/networking-template/'){
                    script {
                        try {
                            sh "terraform workspace new ${params.WORKSPACE}"
                        } catch (err){
                            sh "terraform workspace select ${params.WORKSPACE}"
                        }
                        sh "terraform plan -out terraform-networking.tfplan;echo \$? > status"
                        stash name:"terraform-networking-plan", includes: "terraform-networking.tfplan"
                    }
                }
            }
        }
    }
}