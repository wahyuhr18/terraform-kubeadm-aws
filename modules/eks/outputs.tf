# modules/eks/outputs.tf
output "cluster_id" {
  description = "EKS Cluster ARN"
  value       = aws_eks_cluster.this.id
}

output "cluster_name" {
  description = "Nama cluster EKS"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint API server dari EKS"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_version" {
  description = "Versi Kubernetes"
  value       = aws_eks_cluster.this.version
}

output "nodegroup_name" {
  description = "Nama node group yang dibuat"
  value       = aws_eks_node_group.this.node_group_name
}
