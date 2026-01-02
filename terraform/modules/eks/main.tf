module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  enable_irsa = true
  cluster_encryption_config = {} 
  cluster_enabled_log_types = var.control_plane_logs

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  eks_managed_node_groups = {
    default = {
      name           = "core-ng"
      instance_types = var.node_instance_types
      min_size       = var.node_min
      desired_size   = var.node_desired
      max_size       = var.node_max
      subnet_ids     = var.private_subnet_ids
    }
  }
}
