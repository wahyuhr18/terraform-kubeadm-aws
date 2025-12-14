############################################
# EKS Cluster Outputs
############################################
output "eks_cluster_id" {
  description = "EKS Cluster ARN (unique identifier)"
  value       = module.eks.cluster_id
}

output "eks_cluster_name" {
  description = "Nama cluster EKS"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint API Server dari cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "Versi Kubernetes yang digunakan oleh cluster"
  value       = module.eks.cluster_version
}

output "eks_nodegroup_name" {
  description = "Nama node group yang terdaftar di EKS"
  value       = module.eks.nodegroup_name
}

############################################
# Bastion Outputs
############################################
output "bastion_instance_id" {
  description = "Instance ID Bastion Host (untuk SSM Session Manager)"
  value       = module.bastion.instance_id
}