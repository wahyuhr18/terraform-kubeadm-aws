variable "cluster_name" { type = string }
variable "cluster_role_arn" { type = string }
variable "node_role_arn" { type = string }
variable "subnet_ids" { type = list(string) }
variable "sg_ids" { type = list(string) }
variable "kubernetes_version" { type = string }

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "desired_size" { type = number }
variable "min_size" { type = number }
variable "max_size" { type = number }

variable "depends_on_iam" { description = "Dependency IAM role" }
