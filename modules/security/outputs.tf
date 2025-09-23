output "sg_bastion_id" {
  value = aws_security_group.bastion.id
}

output "sg_master_id" {
  value = aws_security_group.k8s_master.id
}

output "sg_worker_id" {
  value = aws_security_group.k8s_worker.id
}
