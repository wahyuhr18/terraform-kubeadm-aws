output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "Nama EKS Cluster"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "EKS Cluster API Server endpoint"
}

output "cluster_ca" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "Certificate authority data untuk kubeconfig"
}

output "cluster_id" {
  value = aws_eks_cluster.this.id
}