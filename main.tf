# ------------------------
# VPC
# ------------------------
module "vpc" {
  source          = "./modules/vpc"
  cidr_block      = var.cidr_block
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

}

# ------------------------
# IAM (SSM + EKS Cluster Role + Node Role)
# ------------------------
module "iam" {
  source    = "./modules/iam"
  role_name = "${var.env}-${var.role_name}"
}

# ------------------------
# Security Groups
# ------------------------
module "security" {
  source   = "./modules/security"
  vpc_id   = module.vpc.vpc_id
  ssh_cidr = var.ssh_cidr

}

# ------------------------
# Key Pair
# ------------------------
resource "aws_key_pair" "homelab" {
  key_name   = "${var.env}-${var.role_name}-key"
  public_key = file("${path.module}/key/homelab.pub")
}

# ------------------------
# Bastion Host
# ------------------------
module "bastion" {
  source               = "./modules/instance"
  name_prefix          = "${var.env}-bastion"
  ami                  = var.ami
  instance_type        = var.bastion_instance_type
  subnet_id            = module.vpc.public_subnet_ids[0]
  sg_ids               = [module.security.sg_bastion_id]
  iam_instance_profile = module.iam.instance_profile
  key_name             = aws_key_pair.homelab.key_name
  associate_public_ip  = true

  user_data = <<-EOT
    #!/bin/bash
    yum install -y telnet curl unzip
  EOT
}

# ------------------------
# EKS Cluster + Node Group
# ------------------------
module "eks" {
  source = "./modules/eks"

  cluster_name       = "${var.env}-${var.cluster_name}"
  cluster_role_arn   = module.iam.eks_cluster_role_arn
  node_role_arn      = module.iam.eks_node_role_arn
  subnet_ids         = module.vpc.private_subnet_ids
  sg_ids             = [module.security.sg_master_id]
  kubernetes_version = var.kubernetes_version

  instance_types = var.eks_instance_types
  desired_size   = var.eks_desired_size
  min_size       = var.eks_min_size
  max_size       = var.eks_max_size
  ssh_key_name   = aws_key_pair.homelab.key_name

  # pastikan IAM selesai dulu
  depends_on = [module.iam]

  tags = {
    Environment = var.env
    Project     = var.cluster_name
  }
}
