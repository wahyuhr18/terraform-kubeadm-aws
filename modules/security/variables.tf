variable "vpc_id" {
  type = string
}

variable "ssh_cidr" {
  type = string
  description = "Allowed CIDR for bastion SSH access"
}