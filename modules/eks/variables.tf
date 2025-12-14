variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of IAM role for EKS control plane"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of IAM role for EKS node group"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for cluster"
  type        = list(string)
}

variable "cluster_sg_ids" {
  description = "Security Groups for EKS control plane"
  type        = list(string)
  default     = []
}

variable "node_sg_ids" {
  description = "Security Groups for EKS node group (used for SSH/remote access)"
  type        = list(string)
  default     = []
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "instance_types" {
  description = "Instance types for node group"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired node count"
  type        = number
}

variable "min_size" {
  description = "Minimum node count"
  type        = number
}

variable "max_size" {
  description = "Maximum node count"
  type        = number
}

variable "ssh_key_name" {
  description = "EC2 SSH key name for node SSH (optional)"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "Enable CloudWatch logging for cluster"
  type        = bool
  default     = false
}

variable "endpoint_private_access" {
  description = "Enable private endpoint for EKS API"
  type        = bool
  default     = false
}

variable "endpoint_public_access" {
  description = "Enable public endpoint for EKS API"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to access public EKS endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  description = "Control plane log types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}
