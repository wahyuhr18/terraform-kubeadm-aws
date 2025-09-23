region  = "ap-southeast-1"
profile = "staging"

cidr_block      = "10.110.0.0/16"
azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
public_subnets  = ["10.110.1.0/24", "10.110.2.0/24", "10.110.3.0/24"]
private_subnets = ["10.110.10.0/24", "10.110.20.0/24", "10.110.30.0/24"]

ssh_cidr = "123.45.67.89/32" # hanya kantor/VPN

ami                   = "ami-abcdef0123456789a"
bastion_instance_type = "t3.micro"
master_instance_type  = "t3.medium"
worker_instance_type  = "t3.medium"

master_count = 2
worker_count = 3
