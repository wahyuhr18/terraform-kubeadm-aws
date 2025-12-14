# ------------------------
# Bastion Security Group
# ------------------------
resource "aws_security_group" "bastion" {
  name        = "${var.env}-bastion-sg"
  description = "Allow SSH access to Bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-bastion-sg"
      Role = "bastion"
    }
  )
}

# ------------------------
# EKS Control Plane SG
# ------------------------
resource "aws_security_group" "eks_controlplane" {
  name        = "${var.env}-eks-controlplane-sg"
  description = "EKS Control Plane Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Kubernetes API access (Bastion/Admin)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-eks-controlplane-sg"
      Role = "controlplane"
    }
  )
}

# ------------------------
# EKS Node Group SG
# ------------------------
resource "aws_security_group" "eks_nodegroup" {
  name        = "${var.env}-eks-nodegroup-sg"
  description = "EKS Node Group Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description              = "Traffic from Control Plane"
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    security_groups          = [aws_security_group.eks_controlplane.id]
  }

  ingress {
    description = "Node-to-node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description      = "SSH from Bastion host"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-eks-nodegroup-sg"
      Role = "nodegroup"
    }
  )
}
