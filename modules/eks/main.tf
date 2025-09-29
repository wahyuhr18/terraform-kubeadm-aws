# ------------------------
# EKS Cluster
# ------------------------
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.sg_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  version = var.kubernetes_version

  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = var.tags
}

# ------------------------
# EKS Node Group
# ------------------------
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types
  ami_type       = var.ami_type

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = var.sg_ids
  }

  tags = var.tags

  depends_on = [aws_eks_cluster.this]
}
