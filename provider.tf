provider "aws" {
  region = var.AWS_REGION
}


terraform {
  backend "s3" {
    bucket =  "sohail-terraform-state"
    region = "us-east-1"
    key    = "sohail/gitlab-runner/terraform.tfstate"
  }
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.9.4"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.CLUSTER_ENDPOINT
  cluster_ca_certificate = base64decode(module.eks.CLUSTER_AUTH_BASE64)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.CLUSTER_ENDPOINT
    cluster_ca_certificate = base64decode(module.eks.CLUSTER_AUTH_BASE64)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  host                   = module.eks.CLUSTER_ENDPOINT
  cluster_ca_certificate = base64decode(module.eks.CLUSTER_AUTH_BASE64)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}
