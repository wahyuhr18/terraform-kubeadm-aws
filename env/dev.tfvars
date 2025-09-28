# AWS
region  = "us-east-1"
profile = "homelab"

# VPC
cidr_block      = "10.110.0.0/16"
azs             = ["us-east-1a"]
public_subnets  = ["10.110.1.0/24"]
private_subnets = ["10.110.2.0/24"]

ssh_cidr = "0.0.0.0/0"

# Bastion
ami                   = "ami-0ff8a91507f77f867"
bastion_instance_type = "t2.small"

# IAM & Naming
role_name    = "homelab"
cluster_name = "homelab-eks"

# EKS
kubernetes_version = "1.29"
eks_instance_types = ["t2.medium"]

eks_desired_size = 2
eks_min_size     = 1
eks_max_size     = 3
