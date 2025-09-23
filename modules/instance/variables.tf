variable "name_prefix" { type = string }
variable "ami" { type = string }
variable "instance_type" { type = string }
variable "subnet_id" { type = string }
variable "sg_ids" { type = list(string) }
variable "iam_instance_profile" { type = string }
variable "user_data" { type = string }
variable "associate_public_ip" {
  type    = bool
  default = false
}
variable "key_name" { type = string }