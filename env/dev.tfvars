region  = "us-east-1"
profile = "homelab"

cidr_block      = "10.100.0.0/16"
azs             = ["us-east-1a", "us-east-1b"]
public_subnets  = ["10.100.1.0/24", "10.100.2.0/24"]
private_subnets = ["10.100.10.0/24", "10.100.20.0/24"]

ssh_cidr = "0.0.0.0/0"

ami                   = "ami-0ff8a91507f77f867"
bastion_instance_type = "t3.micro"
master_instance_type  = "t3.small"
worker_instance_type  = "t3.small"

master_count = 1
worker_count = 2
