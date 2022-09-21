variable "APP_NAME" {
  type        = string
  description = "Name for the eks cluster."
  default     = "test-cluster"
}

variable "CLUSTER_VERSION" {
  default     = "latest_version"
  type        = string
  description = "Kubernetes version in EKS."
}

variable "INSTANCE_TYPES" {
  type    = list(string)
  default = ["t2.medium"]
}

variable "VPC_ID" {
  type        = string
  description = "VPC ID of the vpc where the cluster will be."
  default     = "vpc-36f4fd53"
}

variable "API_SUBNET" {
  type        = list(string)
  description = "List of the subnets for the EKS api server."
  default     = ["subnet-a0b2d68b", "subnet-098fdc323771fc4b6"]
}

variable "WORKERS_SUBNETS" {
  type        = list(string)
  description = "List of the subnets for the EKS api server."
  default     = ["subnet-a0b2d68b", "subnet-098fdc323771fc4b6"]
}

# variable "bucket" {
#   type =  string
#   default = "sohail-terraform-state"
# }
# variable "bucket_key" {
#   type = string
#   default = "sohail/gitlab-runner/terraform.tfstate"
# }

variable "API_PRIVATE_ACCESS" {
  type    = bool
  default = false
}

# variable "ENGINE" {
#   type    = string
#   default = "mysql"
# }

# variable "ENGINE_VERSION" {
#   type    = string
#   default = "5.7"
# }

# variable "DB_NAME" {
#   type    = string
#   default = "test"
# }

# variable "DB_USERNAME" {
#   type    = string
#   default = "testuser"
# }

# variable "DB_PASSWORD" {
#   type    = string
#   default = "testuserpassword"
# }

# variable "INSTANCE_CLASS" {
#   type    = string
#   default = "db.t3.micro"
# }

# variable "DB_PARAMETER_GROUP_NAME" {
#   type    = string
#   default = "default.mysql5.7"
# }

variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

