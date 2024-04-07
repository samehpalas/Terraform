provider "aws" {
  region = "us-east-1"
}



data "aws_availability_zones" "azs" {}

module "${var.name_prefix}-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }
 
  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/roles/elb" = 1 //elb in public subnet of the cluster
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/roles/internal-elb" = 1
  }
}
