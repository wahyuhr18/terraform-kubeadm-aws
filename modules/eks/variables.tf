variable "cluster_name" {
  type        = string
  description = "Nama EKS cluster"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM Role ARN untuk EKS Cluster"
}

variable "node_role_arn" {
  type        = string
  description = "IAM Role ARN untuk EKS Node Group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs untuk EKS Cluster & Node Group"
}

variable "sg_ids" {
  type        = list(string)
  description = "Security Group IDs untuk EKS Cluster & Node Group"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.29"
  description = "Versi Kubernetes untuk EKS"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
  description = "Log types yang diaktifkan untuk EKS"
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "Instance types untuk worker nodes"
}

variable "ami_type" {
  type        = string
  default     = "AL2_x86_64"
  description = "AMI type untuk EKS worker nodes"
}

variable "desired_size" {
  type        = number
  default     = 2
  description = "Desired worker node count"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Minimum worker node count"
}

variable "max_size" {
  type        = number
  default     = 4
  description = "Maximum worker node count"
}

variable "ssh_key_name" {
  type        = string
  description = "Nama SSH key untuk remote access ke worker nodes"
}

variable "endpoint_private_access" {
  type        = bool
  default     = false
  description = "Apakah private access untuk EKS endpoint diaktifkan"
}

variable "endpoint_public_access" {
  type        = bool
  default     = true
  description = "Apakah public access untuk EKS endpoint diaktifkan"
}

variable "public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR block yang boleh akses ke EKS endpoint publik"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags tambahan"
}
