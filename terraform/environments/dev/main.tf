locals {
  name = "${var.project_name}-${var.environment}"
}

module "vpc" {
  source             = "../../modules/vpc"
  name               = local.name
  vpc_cidr           = var.vpc_cidr
  azs                = var.azs
  single_nat_gateway = true
}

module "eks" {
  source             = "../../modules/eks"
  name               = local.name
  cluster_version    = var.cluster_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  control_plane_logs = ["api"]

  node_instance_types = var.node_instance_types
  node_min            = var.node_min
  node_desired        = var.node_desired
  node_max            = var.node_max
}