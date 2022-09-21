variable "CLUSTER_NAME" {
  type        = string
  description = "Name for the eks cluster."
}

variable "API_SUBNET" {
  type        = list(string)
  description = "List of the subnets for the EKS api server."
}

variable "VPC_ID" {
  type        = string
  description = "VPC ID of the vpc where the cluster will be."
}

variable "CLUSTER_VERSION" {
  default     = "1.22"
  type        = string
  description = "Kubernetes version in EKS."
}

variable "API_PUBLIC_ACCESS" {
  default = true
  type    = bool
}

variable "API_PRIVATE_ACCESS" {
  type    = bool
  default = true
}

variable "ENABLED_CLUSTER_LOG_TYPES" {
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "CLUSTER_LOG_RETENTATION_IN_DAYS" {
  default = 7
}


variable "INSTANCE_TYPES" {
  type = list(string)
}

variable "ROOT_VOLUME_TYPE" {
  default = "standard"
}

variable "ROOT_VOLUME_SIZE" {
  default = 50
}

variable "MAX_SIZE" {
  default = 10
}

variable "MIN_SIZE" {
  default = 1
}

variable "DESIRED_SIZE" {
  default = 2
}

variable "FORCE_DELETE" {
  default = false
}

variable "WORKERS_SUBNETS" {
  type = list(string)
}

variable "map_user" {
  default = [
    
    {
      groups   = ["system:masters"]
      userarn  = "arn:aws:iam::737971166371:user/gitlab-runner"
      username = "gitlab-runner"
    },
    {
      groups   = ["system:masters"]
      userarn  = "arn:aws:iam::737971166371:user/sohail"
      username = "sohail"
    }
  ]
}
