# ------------------------
# VPC
# ------------------------
module "vpc" {
  source          = "./modules/vpc"
  env             = var.env
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
  env      = var.env

  tags = {
    Environment = var.env
    Project     = var.cluster_name
  }
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
  subnet_id            = module.vpc.private_subnet_ids[0]
  sg_ids               = [module.security.sg_bastion_id]
  iam_instance_profile = var.iam_instance_profile
  key_name             = aws_key_pair.homelab.key_name

  user_data            = <<-EOT
    #!/bin/bash
    set -euo pipefail

    sudo rm -f /usr/bin/aws
    sudo rm -f /usr/bin/aws_completer

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    yum install -y telnet curl unzip
    yum update
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  EOT
  
  depends_on = [module.vpc, module.iam, module.security]
}

# ------------------------
# EKS Cluster + Node Group
# ------------------------
module "eks" {
  source = "./modules/eks"

  # Inputs
  cluster_name       = "${var.env}-${var.cluster_name}"
  cluster_role_arn   = module.iam.eks_cluster_role_arn
  node_role_arn      = module.iam.eks_node_role_arn
  subnet_ids         = module.vpc.private_subnet_ids

  # Security groups: controlplane + nodegroup
  cluster_sg_ids     = [module.security.sg_controlplane_id]
  node_sg_ids        = [module.security.sg_nodegroup_id]

  kubernetes_version = var.kubernetes_version

  instance_types = var.eks_instance_types
  desired_size   = var.eks_desired_size
  min_size       = var.eks_min_size
  max_size       = var.eks_max_size
  ssh_key_name   = aws_key_pair.homelab.key_name

  enable_monitoring = var.enable_monitoring

  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access
  public_access_cidrs     = var.public_access_cidrs
  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = merge(var.tags, {
    Environment = var.env
    Project     = var.cluster_name
  })

  depends_on = [
    module.vpc,
    module.iam,
    module.security
  ]
}
