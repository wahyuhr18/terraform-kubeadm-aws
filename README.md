# 🚀 Terraform AWS Homelab Kubernetes

This project provides Terraform configurations to build a **Kubernetes homelab cluster on AWS** using **kubeadm**.  
It supports **multi-environment** (dev, prod) deployments with **Single-AZ** (simple, cost-efficient) or **Multi-AZ** (high availability) options.  
A **bash runner (`run.sh`)** is included to simplify setup and management.

---

## ✨ Features

- 🏗️ **Custom VPC** with public & private subnets  
- 🌐 **Internet Gateway + NAT Gateway** for outbound access  
- 🔒 **Security Groups** for bastion, masters & workers  
- ⚙️ **Flexible scaling** of master and worker nodes  
- 🌍 Supports **Single-AZ** and **Multi-AZ** clusters  
- 📑 **Multi-environment setup** with isolated dev & prod configs  
- 🤖 **Easy automation** via `run.sh` menu

---

## 📂 Project Structure

env/
├─ dev.tfvars
├─ prod.tfvars
├─ modules/
├─ main.tf
├─ variables.tf
├─ outputs.tf
└─ run.sh

> **Modules breakdown**:
> - **VPC**: Creates VPC, public/private subnets, Internet/NAT gateways  
> - **Security**: Security Groups for bastion, master, and worker nodes  
> - **IAM**: Roles & policies for SSM and EC2 
> - **Instance**: EC2 instances for bastion, master, and worker nodes  

---

## ⚡ Quick Start

```bash
git clone https://github.com/your-username/aws-homelab-kubernetes.git
cd aws-homelab-kubernetes
chmod +x run.sh
./run.sh


Choose auth mode (AWS Profile or Access Keys)
Select env (dev / prod)
Pick action: apply, plan, or destroy

Example:
prod apply → Create production infra
dev destroy → Remove dev cluster

🔮 Next Steps
Add Ansible to bootstrap Kubernetes with kubeadm
Extend to staging or test environments

Optionally migrate to EKS later

