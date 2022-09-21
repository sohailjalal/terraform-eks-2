def tfCmd(String command, String options = '') {
    ACCESS = "export AWS_PROFILE=${params.PROFILE} && export TF_ENV_profile=${params.PROFILE}"
    sh ("cd $WORKSPACE && ${ACCESS} && terraform init")
    sh ("echo ${command} ${options}")
    sh ("ls && pwd")
    sh ("cd $WORKSPACE && ${ACCESS} && terraform init && terraform ${command} ${options} && terraform show -no-color > show-${ENV_NAME}.txt")
}

pipeline {
    agent any 
    environment {
        PROJECT_DIR = "eks-update/"
    }


    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        // timestamps()
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    parameters {
      choice (name: 'AWS_REGION', choices: [ 'us-east-1', 'ap-northeast-1', 'us-east-2'], description: 'Pick a Region. Defaults to ap-northeast-1')
        
        choice (name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Run terraform plan / apply / destroy')

        string (name: 'PROFILE', defaultValue: 'sohail', description: 'Optional, Target AWS Profile')

        string (name: 'ENV_NAME', defaultValue: 'tf-AWS', description: 'Env name.')

        string (name: 'APP_NAME', defaultValue: 'test-cluster', description: 'Name of EKS cluster.')

        choice (name: 'CLUSTER_VERSION', choices: [ '1.20', '1.21', '1.19'], description: 'Kubernetes version in EKS.')

        string (name: 'VPC_ID', defaultValue: 'vpc-36f4fd53', description: 'VPC ID on which the cluster will be on.')

        string (name: 'INSTANCE_TYPES', defaultValue: '["t2.medium"]', description: 'List of the instance type to create the nodegroup.')

        string (name: 'API_SUBNET', defaultValue: '["subnet-76a41c7a", "subnet-0abc2c6f"]', description: 'List of subnet for API server.')

        string (name: 'WORKER_SUBNETS', defaultValue: '["subnet-7513612c"]', description: 'List of subnets for worker node.')


        choice (name: 'API_PRIVATE_ACCESS', choices: [ 'true', 'false'], description: 'Allow api server to be accessed using public endpoint.')

      


    }

    stages {

        stage('Set Environment Variable'){
            steps {
                script {
                    env.PROFILE = "${params.PROFILE}"
                    env.ACTION = "${params.ACTION}"
                    env.AWS_DEFAULT_REGION = "${params.AWS_REGION}"
                    env.ENV_NAME = "${params.ENV_NAME}"
                    env.CLUSTER_NAME = "${params.CLUSTER_NAME}"
                    env.DESIRED_SIZE = "${params.DESIRED_SIZE}"
                    env.CLUSTER_VERSION = "${params.CLUSTER_VERSION}"
                    env.VPC_ID = "${params.VPC_ID}"
                    env.INSTANCE_TYPES = "${params.INSTANCE_TYPES}"
                    env.API_SUBNET = "${params.API_SUBNET}"
                    env.WORKER_SUBNETS = "${params.WORKER_SUBNETS}"
                    
                    env.API_PRIVATE_ACCESS = "${params.API_PRIVATE_ACCESS}"
                 
                }
            }
        }

        stage('Checkout & Environment Prep'){
            steps{
                script {
                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']){
                        withCredentials([
                            [ $class: 'AmazonWebServicesCredentialsBinding',
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                                credentialsId: 'AWS-Access',

                            ]])
                        {
                            try {
                                currentBuild.displayName += "[$AWS_REGION]::[$ACTION]"
                                sh ("""
                                        aws configure --profile ${params.PROFILE} set aws_access_key_id ${AWS_ACCESS_KEY_ID}
                                        aws configure --profile ${params.PROFILE} set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
                                        aws configure --profile ${params.PROFILE} set region ${AWS_REGION}
                                        export AWS_PROFILE=${params.PROFILE}
                                        export TF_ENV_profile=${params.PROFILE}
                                """)
                                tfCmd('version')
                            } catch (ex) {
                                echo 'Err: Build Failed with Error: ' + ex.toString()
                                currentBuild.result = "UNSTABLE"
                            }
                        }
                        
                    }
                }
            }
        }
        stage('Terraform Plan'){
                when { anyOf
                            {
                                environment name: 'ACTION', value: 'plan';
                                environment name: 'ACTION', value: 'apply';
                            }

                }
                steps {

                        dir("${PROJECT_DIR}"){
                                script {
                                        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                                                withCredentials([
                                                    [ $class: 'AmazonWebServicesCredentialsBinding',
                                                            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                                            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                                                            credentialsId: 'AWS-Access'
                                                    ]])
                                                {
                                                    try {
                                                        sh ("""
                                                        touch $WORKSPACE/terraform.tfvars
                                                        echo 'CLUSTER_NAME = "${CLUSTER_NAME}"' >> $WORKSPACE/terraform.tfvars
                                                        echo 'DESIRED_SIZE = "${DESIRED_SIZE}"'  >> $WORKSPACE/terraform.tfvars
                                                        echo 'CLUSTER_VERSION = "${CLUSTER_VERSION}"' >> $WORKSPACE/terraform.tfvars
                                                        echo 'VPC_ID = "${VPC_ID}"' >> $WORKSPACE/terraform.tfvars
                                                        echo 'INSTANCE_TYPES = ${INSTANCE_TYPES}' >> $WORKSPACE/terraform.tfvars
                                                        echo 'API_SUBNET = ${API_SUBNET}' >> $WORKSPACE/terraform.tfvars
                                                        echo 'WORKERS_SUBNETS = ${WORKER_SUBNETS}' >> $WORKSPACE/terraform.tfvars
                                                      
                                                        echo 'API_PRIVATE_ACCESS = "${API_PRIVATE_ACCESS}"' >> $WORKSPACE/terraform.tfvars
                                                        cat $WORKSPACE/terraform.tfvars
                                                        """)
                                                        tfCmd('plan', '-detailed-exitcode -var AWS_REGION=${AWS_DEFAULT_REGION} -var-file=terraform.tfvars -out plan.out')
                                                    } catch (ex) {
                                                        if(ex == 2 && "${ACTION}" == 'apply'){
                                                            currentBuild.result = "UNSTABLE"
                                                        } else if (ex == 2 && "${ACTION}" == 'plan') {
                                                            echo "Update found in plan.out"
                                                        } else {
                                                            echo "Try Running terrafom in debug mode."
                                                        }
                                                    }
                                                }
                                        }
                                }
                        }
                }
        }

        stage('Terraform Apply'){
                when { anyOf
                            {
                                environment name: 'ACTION', value: 'apply';
                            }

                }

                steps {
                        dir("${PROJECT_DIR}") {
                                script {
                                        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                                                withCredentials([
                                                    [ $class: 'AmazonWebServicesCredentialsBinding',
                                                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                                                        credentialsId: 'AWS-Access',
                                                        ]])
                                                    {
                                                    try {
                                                        tfCmd('apply', 'plan.out')
                                                    } catch (ex) {
                                                        currentBuild.result = "UNSTABLE"
                                                    }
                                                }
                                        }
                                }
                        }
                }
        }
        
        stage('Terraform Destroy') {
                when { anyOf 
                            {
                                environment name: 'ACTION', value: 'destroy';
                            }
                }
                steps {
                        script {
                            def IS_APPROVED = input(
                                    message: "Destroy ${ENV_NAME} !?!",
                                    ok: 'Yes',
                                    parameters: [
                                        string(name: 'IS_APPROVED', defaultValue: 'No', description: 'Think again!!!')
                                    ]
                                )
                                if (IS_APPROVED != 'Yes') {
                                        currentBuild.result = "ABORTED"
                                        error "User cancelled"
                                }
                        }

                        dir("${PROJECT_DIR}") {
                            script {

                                    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                                            withCredentials([
                                                [ $class: 'AmazonWebServicesCredentialsBinding',
                                                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                                                    credentialsId: 'AWS-Access',
                                                    ]])
                                                {
                                                    try {
                                                        
                                                        tfCmd('destroy', '-auto-approve')
                                                    } catch (ex) {
                                                        currentBuild.result = "UNSTABLE"
                                                    }
                                                }
                                        }
                                }
                        }
                }
        }
    }
    post { 
        always { 
            deleteDir()
        }
    }
}
