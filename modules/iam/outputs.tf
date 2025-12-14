output "bastion_role_arn" {
  description = "ARN of the Bastion IAM Role (Full Admin)"
  value       = aws_iam_role.bastion_role.arn
}

output "bastion_instance_profile" {
  description = "Instance profile name for Bastion"
  value       = aws_iam_instance_profile.bastion_profile.name
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}
