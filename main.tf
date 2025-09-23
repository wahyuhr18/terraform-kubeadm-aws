# VPC
module "vpc" {
  source          = "./modules/vpc"
  cidr_block      = var.cidr_block
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# IAM Role (SSM)
module "iam" {
  source    = "./modules/iam"
  role_name = "homelab-ssm-role"
}

# Resource key pair AWS
resource "aws_key_pair" "homelab" {
  key_name   = "homelab-key"
  public_key = file("${path.module}/key/homelab.pub")
}

# Security Groups
module "security" {
  source   = "./modules/security"
  vpc_id   = module.vpc.vpc_id
  ssh_cidr = var.ssh_cidr
}

# Bastion Host
module "bastion" {
  source               = "./modules/instance"
  name_prefix          = "bastion"
  ami                  = var.ami
  instance_type        = var.bastion_instance_type
  subnet_id            = module.vpc.public_subnet_ids[0]
  sg_ids               = [module.security.sg_bastion_id]
  iam_instance_profile = module.iam.instance_profile
  key_name = aws_key_pair.homelab.key_name
  associate_public_ip  = true
  

  user_data = <<-EOT
    #!/bin/bash
    yum install -y telnet curl unzip
  EOT
}

# Master Nodes
module "masters" {
  source               = "./modules/instance"
  count                = var.master_count
  name_prefix          = "master-${count.index + 1}"
  ami                  = var.ami
  instance_type        = var.master_instance_type
  subnet_id            = element(module.vpc.private_subnet_ids, count.index % length(module.vpc.private_subnet_ids))
  sg_ids               = [module.security.sg_master_id]
  iam_instance_profile = module.iam.instance_profile
  key_name = aws_key_pair.homelab.key_name

  user_data = <<-EOT
    #!/bin/bash
    $(cat ${path.root}/scripts/common.sh)
    $(cat ${path.root}/scripts/master.sh)
  EOT
}

# Worker Nodes
module "workers" {
  source               = "./modules/instance"
  count                = var.worker_count
  name_prefix          = "worker-${count.index + 1}"
  ami                  = var.ami
  instance_type        = var.worker_instance_type
  subnet_id            = element(module.vpc.private_subnet_ids, count.index % length(module.vpc.private_subnet_ids))
  sg_ids               = [module.security.sg_worker_id]
  iam_instance_profile = module.iam.instance_profile
  key_name = aws_key_pair.homelab.key_name

  user_data = <<-EOT
    #!/bin/bash
    $(cat ${path.root}/scripts/common.sh)
    $(cat ${path.root}/scripts/worker.sh)
  EOT
}
