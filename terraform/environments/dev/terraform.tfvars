project_name = "devops-aws-project"
environment  = "dev"
aws_region   = "us-east-1"

vpc_cidr = "10.10.0.0/16"
azs      = ["us-east-1a", "us-east-1b"]

cluster_version     = "1.34"
node_instance_types = ["t3.medium"]
node_min            = 1
node_desired        = 2
node_max            = 3