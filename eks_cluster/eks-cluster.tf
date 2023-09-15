provider "kubernetes" {
  config_paths = "false"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.myapp1-cluster.token
}
  data "aws_eks_cluster_auth" "myapp1-cluster" {
    name = module.eks.cluster_name
  }
 output "cluster_id" {
  description = "The ID of the cluster."
  value       = module.eks.cluster_name
}
module "eks" {
   source  = "terraform-aws-modules/eks/aws"
   version = "20.8.3"
   cluster_name = "myapp1-cluster"
   cluster_version = "1.29"
   subnet_ids = module.myapp-vpc.private_subnets
   vpc_id =  module.myapp-vpc.vpc_id

   tags = {
     environment = "development"
     application = "myapp"
   }
   eks_managed_node_groups = {
    example = {
      min_size     = 2
      max_size     = 4
      desired_size = 3

      instance_types = ["t2.large"]
    }
  }
}   