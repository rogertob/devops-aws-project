variable "aws_region" {
    description = "AWS Region"
    type = string
}

variable "project_name" {
    description = "Project Name"
    type = string
}

variable "environment" {
  description = "Environment Name"
  type = string
}

variable "vpc_cidr" { 
    description = "VPC CIDR"
    type = string 
}

variable "azs" { 
    description = "Availability Zones"
    type = list(string) 
}