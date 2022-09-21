locals {
  aws_auth_configmap_data = {
    mapRoles = [{
      rolearn  = aws_iam_role.eks_node.arn,
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    }]
    mapUsers = var.map_user
  }

}
