## 🚀 Terraform AWS Homelab Kubernetes

This project provides Terraform configurations to build a Kubernetes homelab cluster on AWS using kubeadm.
It supports multi-environment (dev, staging, prod) deployments with Single-AZ or Multi-AZ options.
A bash runner (run.sh) is included to simplify setup, management, and kubeconfig updates.

## ✨ Features

🏗️ Custom VPC with public & private subnets
🌐 Internet Gateway + NAT Gateway for outbound access
🔒 Security Groups for bastion, master, and worker nodes
🔑 Key Pair management for SSH access
⚙️ Bastion host for secure access to private instances
⚡ EKS Cluster with Node Group using defined instance types and scaling
📑 Multi-environment setup: dev, staging, prod
🤖 Automation via run.sh with menu-driven options:
Select AWS authentication mode (existing profile or create new)
Choose environment (dev, staging, prod)
Pick action: plan, apply, destroy
Updates kubeconfig automatically after deployment

##📂 Project Structure

```bash
terraform-kubeadm-aws/
├── env/                  
│   ├── dev/                 
│   │   ├── dev.tfvars        
│   │   └── dev-backend.tf
│   ├── staging/             
│   │   ├── staging.tfvars    
│   │   └── backend.tf
│   └── prod/                
│       ├── prod.tfvars       
│       └── backend.tf
├── key/                  
│   └── homelab.pub          # Public key for EC2 Key Pair
├── modules/                        
│   ├── vpc/                  
│   ├── iam/                  
│   ├── security/             
│   ├── instance/             
│   └── eks/                  
├── main.tf                  # Root module
├── outputs.tf            
├── provider.tf           
├── run.sh                   # Bash runner for automation
├── terraform.tfvars      
└── variables.tf          
```

##🏗️ Modules Breakdown

vpc	Creates VPC, public/private subnets, Internet/NAT gateways
iam	Creates IAM roles & instance profiles:
• SSM Role
• EKS Cluster Role
• EKS Node Role
security	Creates Security Groups for bastion, master, and worker nodes
instance	Launches Bastion host EC2 with SSH & essential packages
eks	Deploys EKS Cluster with Node Group, including version, instance types, scaling, and SSH access

⚡ Quick Start

```bash
git clone https://github.com/wahyuhr18/terraform-kubeadm-aws.git
cd terraform-kubeadm-aws
chmod +x run.sh
./run.sh
```

Runner Steps:

Select Authentication Mode:
1 → Use existing AWS profile
2 → Create a new AWS profile (will exit after creation, rerun script)

Select Environment:
1 → prod
2 → staging
3 → dev
Select Action:
1 → apply → Deploy infrastructure
2 → destroy → Remove infrastructure
3 → plan → Preview Terraform changes

The runner will:

Initialize Terraform with environment-specific backend config
Run the selected action (plan, apply, destroy)
Update kubeconfig automatically for the deployed cluster
Test cluster connectivity via kubectl get nodes

Examples:
# Deploy production cluster
./run.sh → select prod → apply

# Destroy development cluster
./run.sh → select dev → destroy

# Preview staging changes
./run.sh → select staging → plan

🔮 Next Steps
fix bug
