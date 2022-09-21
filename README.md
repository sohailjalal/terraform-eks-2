## Introduction 
Terraform is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently. This includes both low-level components like compute instances, storage, and networking, as well as high-level components like DNS entries and SaaS features.

We are creating an AWS EKS cluster with terraform script.
Terraform helps to deploy all resource at onces and update as required.

## Instructions to run from terminal
1. Download the terraform script file in your pc.
2. Install terraform in a terminal
3. Install awscli
4. Run the script using terraform. Commands are below
    terraform init
    terraform plan
    terraform apply

## Instruction to run on jenkins
1. Download the terraform script file
2. Push the file to git repository
3. Run Jenkins in EC2 instance 
4. Create a Jenkins pipeline
5. Add git repository url in Jenkins pipeline configuration
6. Run Jenkins pipeline 

## Changes needs to be done before using terraform script 

 In variables.tf
 1. VPC_ID
 2. API_SUBNET
 3. WORKERS_SUBNETS
 4. bucket   
 5. bucket_key

 In eks/variables.tf
 1. map_user

# Change Arn
 1. Change userarn 
 2. Change s3 bucket name and key in provider.tf
 
## Jenkins requirements
1. Add the following plugins by going to manage Jenkins --> manage plugins 
    amazon ecr plugin
    amazon web service Sdk
    ansicolor
    blue ocean
    build with parameters
    Cloudbees aws credentials plugin
    docker 
    github
    timestamper
    terraform plugin

2. Add AWS credentials access key and secret access key. ID should be AWS-Access.

3. Set up terraform in Jenkins. Go to manage Jenkins --> Globle tool configure 
   At the bottom add terraform, provide name and uncheck auto installation.
   for installation of terraform, open Jenkins EC2 instance and run following commands

    wget https://releases.hashicorp.com/terraform/1.2.9/terraform_1.2.9_linux_amd64.zip
    unzip terraform_1.2.9_linux_amd64.zip
    mv terraform /use/bin/
    terraform --version

    add path /user/bin/ install directory  in Jenkins 
    
4. Note that EKS cluster name should be same as in springboot Jenkinsfile in login k8s stage.

5. In springboot Jenkinsfile replace Cloning Git stage. To do that we have to go to Jenkins, select springboot pipeline and go 
   to configure, at bottom of configuration setting, click pipeline sytax and select checkout version control in top down menu.
   add git respository then generate script and copy this script then paste on springboot Jenkinsfile in Cloning Git stage.
   commmit the chnages in git repository.

6. Open eks-terraform-2 pipeline and click on build with parameters, we have to provide parameters with following AWS vpc and subnetes.
   and click on build.

7. Now create RDS in AWS. we need mysql for the database and add username and password.
   After creating RDS, copy endpoint url and open mysql workbrench and connect RDS with workbrench.

8. Create a database, table and insert data, using following query in workbench.

    create datasbase {database name}
    
    create table {table name} (
        bookid int,
        bookname varchar(50),
        author varchar(50),
        price int,
    )

    insert into {table name} values (1 , 'Harry Potter' , 'jk rowling', 500)

9. Open springboot application scr/main/resources/application.properties replace your RDS endpoint url and add database name, username 
   and password.

10. After creating EKS clutser we have to open pipeline and click on build now.

11. Go to EC2 service, open loadbalancer, copy DNS name of loadbalancer run on browser.

11. Application should visible at  {DNS name of loadbalancer}/book
