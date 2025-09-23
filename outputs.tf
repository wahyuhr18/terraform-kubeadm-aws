# Bastion
output "bastion" {
  value = {
    id         = module.bastion.instance_id
    name       = module.bastion.name
    public_ip  = module.bastion.public_ip
    private_ip = module.bastion.private_ip
  }
}

# Masters
output "masters" {
  value = [
    for m in module.masters : {
      id         = m.instance_id
      name       = m.name
      private_ip = m.private_ip
    }
  ]
}

# Workers
output "workers" {
  value = [
    for w in module.workers : {
      id         = w.instance_id
      name       = w.name
      private_ip = w.private_ip
    }
  ]
}
