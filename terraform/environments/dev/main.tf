locals {
  name = "${var.project_name}-${var.environment}"
}

module "vpc" {
  source             = "../../modules/vpc"
  name               = local.name
  vpc_cidr            = var.vpc_cidr
  azs                = var.azs
  single_nat_gateway = true
}