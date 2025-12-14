############################################
# AWS Provider Configuration
############################################
variable "region" {
  type        = string
  description = "AWS region tempat resource akan dibuat"
  default     = "us-east-1"
}

variable "profile" {
  type        = string
  description = "AWS CLI profile name (opsional)"
  default     = null
}

############################################
# Environment & Naming
############################################
variable "env" {
  type        = string
  description = "Environment name (contoh: dev, stg, prod)"
}

variable "role_name" {
  type        = string
  description = "Base name untuk IAM role & resource prefix"
  default     = "homelab"
}

variable "cluster_name" {
  type        = string
  description = "Nama base untuk EKS cluster (akan diprefiks dengan env)"
  default     = "homelab-eks"
}

############################################
# Networking (VPC, Subnets, SSH)
############################################
variable "cidr_block" {
  type        = string
  description = "CIDR block untuk VPC"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones untuk VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "Daftar CIDR untuk public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "Daftar CIDR untuk private subnets"
}

variable "ssh_cidr" {
  type        = list(string)
  description = "List CIDR yang diizinkan akses SSH (misal IP kantor atau Bastion)"
}

variable "ssh_key_name" {
  type        = string
  description = "Nama AWS EC2 Key Pair untuk Bastion dan EKS Node Group"
  default     = null
}

############################################
# Bastion Host
############################################
variable "ami" {
  type        = string
  description = "AMI ID yang digunakan untuk Bastion Host"
}

variable "bastion_instance_type" {
  type        = string
  description = "EC2 instance type untuk Bastion Host"
  default     = "t3.micro"
}

variable "iam_instance_profile" {
  type        = string
}

############################################
# EKS Cluster Configuration
############################################
variable "kubernetes_version" {
  type        = string
  description = "Versi Kubernetes untuk EKS cluster"
  default     = "1.29"
}

variable "endpoint_private_access" {
  type        = bool
  description = "Aktifkan private endpoint untuk EKS API"
  default     = false
}

variable "endpoint_public_access" {
  type        = bool
  description = "Aktifkan public endpoint untuk EKS API"
  default     = true
}

variable "public_access_cidrs" {
  type        = list(string)
  description = "CIDR list yang diizinkan akses ke EKS public endpoint"
  default     = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  description = "Control plane logs yang diaktifkan untuk EKS cluster"
  default     = ["api", "audit", "authenticator"]
}

############################################
# EKS Node Group
############################################
variable "eks_instance_types" {
  type        = list(string)
  description = "List instance types untuk node group"
  default     = ["t3.medium"]
}

variable "eks_desired_size" {
  type        = number
  description = "Jumlah node worker yang diinginkan"
  default     = 2
}

variable "eks_min_size" {
  type        = number
  description = "Jumlah node worker minimum"
  default     = 1
}

variable "eks_max_size" {
  type        = number
  description = "Jumlah node worker maksimum"
  default     = 4
}

############################################
# Monitoring & Tags
############################################
variable "enable_monitoring" {
  type        = bool
  description = "Enable CloudWatch logging dan detailed monitoring"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Global tags applied to resources"
  default = {
    Owner       = "wahyu.hidayat"
    Provisioner = "Terraform"
    ManagedBy   = "IaC"
  }
}
