# Bastion SG (SSH dari internet)
resource "aws_security_group" "bastion" {
  name        = "bastion_sg"
  description = "Bastion Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr] # hanya IP publik kamu
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

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "K8s API Server"
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
    security_groups = [aws_security_group.k8s_worker.id]
  }

  ingress {
    description     = "ETCD (cluster-internal only)"
    from_port       = 2379
    to_port         = 2380
    protocol        = "tcp"
    self            = true
  }

  ingress {
    description     = "Weavenet communication"
    from_port       = 6783
    to_port         = 6784
    protocol        = "tcp"
    security_groups = [aws_security_group.k8s_worker.id]
  }

  ingress {
    description     = "Kubelet & Control Plane Ports"
    from_port       = 10248
    to_port         = 10260
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.k8s_worker.id]
  }

  ingress {
    description     = "NodePort Services"
    from_port       = 30000
    to_port         = 32767
    protocol        = "tcp"
    security_groups = [aws_security_group.k8s_worker.id]
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

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "K8s API Server Access"
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
    security_groups = [aws_security_group.k8s_master.id]
  }

  ingress {
    description     = "Weavenet communication"
    from_port       = 6783
    to_port         = 6784
    protocol        = "tcp"
    security_groups = [aws_security_group.k8s_master.id]
  }

  ingress {
    description     = "Kubelet & Node communication"
    from_port       = 10248
    to_port         = 10260
    protocol        = "tcp"
    self            = true
    security_groups = [aws_security_group.k8s_master.id]
  }

  ingress {
    description     = "NodePort Services"
    from_port       = 30000
    to_port         = 32767
    protocol        = "tcp"
    security_groups = [aws_security_group.k8s_master.id]
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
