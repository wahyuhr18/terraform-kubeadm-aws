output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificate" {
  value = module.eks.cluster_certificate
}

output "eks_node_group_name" {
  value = module.eks.node_group_name
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}
