# =====================
# AWS Region & Profile
# =====================
variable "region" {
  type        = string
  description = "AWS region tempat resource dibuat"
}

variable "profile" {
  type        = string
  default     = null
  description = "AWS CLI profile name (opsional)"
}

# =====================
# Environment & Naming
# =====================
variable "env" {
  type        = string
  description = "Environment name (contoh: dev, staging, prod)"
}

variable "role_name" {
  type        = string
  default     = "homelab"
  description = "Base name untuk IAM role & resource prefix"
}

variable "cluster_name" {
  type        = string
  default     = "homelab-eks"
  description = "Nama base untuk EKS cluster (akan diprefiks dengan env)"
}

# =====================
# VPC & Networking
# =====================
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
  description = "CIDR list untuk public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR list untuk private subnets"
}

variable "ssh_cidr" {
  type        = string
  description = "CIDR yang diizinkan akses SSH (ke Bastion)"
}

variable "ssh_key_name" {
  type        = string
  default     = null
  description = "Nama AWS EC2 Key Pair untuk Bastion dan EKS Node Group"
}

# =====================
# Bastion Host
# =====================
variable "ami" {
  type        = string
  description = "AMI ID untuk Bastion Host"
}

variable "bastion_instance_type" {
  type        = string
  description = "EC2 instance type untuk Bastion Host"
}

# =====================
# EKS Cluster
# =====================
variable "kubernetes_version" {
  type        = string
  default     = "1.29"
  description = "Versi Kubernetes untuk EKS cluster"
}

variable "endpoint_private_access" {
  type        = bool
  default     = false
  description = "Aktifkan private endpoint untuk EKS API"
}

variable "endpoint_public_access" {
  type        = bool
  default     = true
  description = "Aktifkan public endpoint untuk EKS API"
}

variable "public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR list yang diizinkan akses ke EKS public endpoint"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
  description = "Control plane logs yang diaktifkan untuk EKS cluster"
}

# =====================
# EKS Node Group
# =====================
variable "eks_instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "List instance types untuk node group"
}

variable "eks_desired_size" {
  type        = number
  default     = 2
  description = "Jumlah node worker yang diinginkan"
}

variable "eks_min_size" {
  type        = number
  default     = 1
  description = "Jumlah node worker minimum"
}

variable "eks_max_size" {
  type        = number
  default     = 4
  description = "Jumlah node worker maksimum"
}
