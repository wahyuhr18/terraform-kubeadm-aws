# Masters
output "masters" {
  description = "Master nodes with IDs and IPs"
  value = {
    for idx, m in module.masters :
    "master-${idx + 1}" => {
      id         = m.instance_id
      private_ip = m.private_ip
      public_ip  = m.public_ip
    }
  }
}

# Workers
output "workers" {
  description = "Worker nodes with IDs and IPs"
  value = {
    for idx, w in module.workers :
    "worker-${idx + 1}" => {
      id         = w.instance_id
      private_ip = w.private_ip
      public_ip  = w.public_ip
    }
  }
}

# Bastion (opsional)
output "bastion" {
  description = "Bastion instance ID and IP"
  value = {
    id         = module.bastion.instance_id
    private_ip = module.bastion.private_ip
    public_ip  = module.bastion.public_ip
  }
}
