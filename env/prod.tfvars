region  = "ap-southeast-1"
profile = "prod"

cidr_block      = "10.120.0.0/16"
azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
public_subnets  = ["10.120.1.0/24", "10.120.2.0/24", "10.120.3.0/24"]
private_subnets = ["10.120.10.0/24", "10.120.20.0/24", "10.120.30.0/24"]

ssh_cidr = "10.0.0.0/8" # internal corp network/VPN

ami                   = "ami-0abcdef1234567890"
bastion_instance_type = "t3.small"
master_instance_type  = "t3.large"
worker_instance_type  = "t3.large"

master_count = 3
worker_count = 6
