# AWS Region & Profile
variable "region" {
  type        = string
  description = "AWS region tempat resource dibuat"
}

variable "profile" {
  type        = string
  default     = null
  description = "AWS CLI profile name (opsional)"
}

# VPC & Networking
variable "cidr_block" { type = string }
variable "azs" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "ssh_cidr" { type = string }

# AMI & Bastion
variable "ami" { type = string }
variable "bastion_instance_type" { type = string }

# IAM & Naming
variable "role_name" {
  type    = string
  default = "homelab"
}

# EKS Cluster
variable "cluster_name" {
  type    = string
  default = "homelab-eks"
}

variable "kubernetes_version" {
  type    = string
  default = "1.29"
}

variable "eks_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "eks_desired_size" {
  type    = number
  default = 2
}

variable "eks_min_size" {
  type    = number
  default = 1
}

variable "eks_max_size" {
  type    = number
  default = 4
}
