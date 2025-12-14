output "sg_bastion_id" {
  description = "Security Group ID for Bastion Host"
  value       = aws_security_group.bastion.id
}

output "sg_controlplane_id" {
  description = "Security Group ID for EKS Control Plane"
  value       = aws_security_group.eks_controlplane.id
}

output "sg_nodegroup_id" {
  description = "Security Group ID for EKS Node Group"
  value       = aws_security_group.eks_nodegroup.id
}
