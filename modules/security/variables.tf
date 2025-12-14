variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ssh_cidr" {
  description = "Allowed CIDR list for SSH access"
  type        = list(string)
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "tags" {
  description = "Map of tags"
  type        = map(string)
  default     = {}
}