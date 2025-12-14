# EKS cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.cluster_sg_ids

    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  # If monitoring is disabled, no cluster log types are enabled to avoid unnecessary logging costs.
  enabled_cluster_log_types = var.enable_monitoring ? var.enabled_cluster_log_types : []

  tags = merge(var.tags, {
    Name = var.cluster_name
  })

  depends_on = []
}

# Node group
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  instance_types = var.instance_types

  # enable remote access (optional)
  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = var.node_sg_ids
  }

  force_update_version = true

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-nodegroup"
  })

  depends_on = [aws_eks_cluster.this]
}
