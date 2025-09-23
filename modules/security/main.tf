# Bastion SG (SSH from internet)
resource "aws_security_group" "bastion" {
  name        = "bastion_sg"
  description = "Bastion Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_sg"
  }
}

# Master SG
resource "aws_security_group" "k8s_master" {
  name        = "k8s_master_sg"
  description = "Kubernetes Master Security Group"
  vpc_id      = var.vpc_id

  # SSH from Bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  # Allow all traffic inside master SG (ETCD, Kubelet, etc.)
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s_master_sg"
  }
}

# Worker SG
resource "aws_security_group" "k8s_worker" {
  name        = "k8s_worker_sg"
  description = "Kubernetes Worker Security Group"
  vpc_id      = var.vpc_id

  # SSH from Bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  # Allow all traffic inside worker SG
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s_worker_sg"
  }
}

# --- Cross-SG rules ---

# K8s API (Master → Worker)
resource "aws_security_group_rule" "api_master_to_worker" {
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  security_group_id         = aws_security_group.k8s_worker.id
  source_security_group_id  = aws_security_group.k8s_master.id
  description              = "K8s API access from master to worker"
}

# WeaveNet (Master ↔ Worker)
resource "aws_security_group_rule" "weavenet_master_to_worker" {
  type                     = "ingress"
  from_port                = 6783
  to_port                  = 6784
  protocol                 = "tcp"
  security_group_id         = aws_security_group.k8s_master.id
  source_security_group_id  = aws_security_group.k8s_worker.id
  description              = "WeaveNet traffic from worker to master"
}

# NodePort services (Master → Worker)
resource "aws_security_group_rule" "nodeport_master_to_worker" {
  type                     = "ingress"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  security_group_id         = aws_security_group.k8s_worker.id
  source_security_group_id  = aws_security_group.k8s_master.id
  description              = "NodePort services from master to worker"
}

# Kubelet / Control Plane (Master intra-cluster)
resource "aws_security_group_rule" "kubelet_master" {
  type                     = "ingress"
  from_port                = 10248
  to_port                  = 10260
  protocol                 = "tcp"
  security_group_id         = aws_security_group.k8s_master.id
  source_security_group_id  = aws_security_group.k8s_master.id
  description              = "Kubelet & Control Plane intra-master"
}

# Kubelet / Node communication (Worker intra-cluster)
resource "aws_security_group_rule" "kubelet_worker" {
  type                     = "ingress"
  from_port                = 10248
  to_port                  = 10260
  protocol                 = "tcp"
  security_group_id         = aws_security_group.k8s_worker.id
  source_security_group_id  = aws_security_group.k8s_worker.id
  description              = "Kubelet & Node intra-worker"
}

# ETCD (Master intra-cluster)
resource "aws_security_group_rule" "etcd_master" {
  type                     = "ingress"
  from_port                = 2379
  to_port                  = 2380
  protocol                 = "tcp"
  security_group_id         = aws_security_group.k8s_master.id
  source_security_group_id  = aws_security_group.k8s_master.id
  description              = "ETCD intra-master"
}
