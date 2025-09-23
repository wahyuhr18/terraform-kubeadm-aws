region  = "us-east-1"
profile = "homelab"

cidr_block      = "10.110.0.0/16"
azs             = ["us-east-1a"]
public_subnets  = ["10.110.1.0/24"]
private_subnets = ["10.110.2.0/24"]

ssh_cidr = "0.0.0.0/0"

ami                   = "ami-0ff8a91507f77f867"
bastion_instance_type = "t2.small"
master_instance_type  = "t2.medium"
worker_instance_type  = "t2.small"

master_count = 1
worker_count = 2