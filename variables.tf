# AWS Region & Profile
variable "region" { type = string }
variable "profile" {
  type    = string
  default = null
}

# VPC CIDR
variable "cidr_block" { type = string }

# Multi-AZ setup
variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

# SSH Source
variable "ssh_cidr" { type = string }

# AMI & Instances
variable "ami" { type = string }
variable "bastion_instance_type" { type = string }
variable "master_instance_type" { type = string }
variable "worker_instance_type" { type = string }

# Cluster Size
variable "master_count" { type = number }
variable "worker_count" { type = number }