output "CLUSTER_SECURITY_GROUP_ID" {
  value = aws_security_group.eks_cluster.id
}

output "CLUSTER_AUTH_BASE64" {
  value = aws_eks_cluster.EKS_CLUSTER.certificate_authority[0].data
}

output "CLUSTER_ENDPOINT" {
  value = aws_eks_cluster.EKS_CLUSTER.endpoint
}

output "CLUSTER_VERSION" {
  value = aws_eks_cluster.EKS_CLUSTER.version
}

output "CLUSTER_ID" {
  value = aws_eks_cluster.EKS_CLUSTER.id
}

output "NODE_GROUP_ARN" {
  value = local.aws_auth_configmap_data
}
