variable "region" {
  description = "AWS region"
  type        = string
}

variable "profile" {
  description = "AWS CLI profile"
  type        = string
  default     = null
}

variable "env" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "bucket_name" {
  description = "Name of S3 bucket for Terraform remote state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of DynamoDB table for state locking"
  type        = string
}
