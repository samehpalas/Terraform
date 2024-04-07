provider "kubernetes" {
  config_paths = "false"
  host                   =  data.aws_eks_cluster.myapp1-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp1-cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.myapp1-cluster.token   
}
data "aws_eks_cluster" "myapp1-cluster" {
  name = module.eks.cluster_name
}
  data "aws_eks_cluster_auth" "myapp1-cluster" {
    name = module.eks.cluster_name
  }
data "aws_caller_identity" "current" {} # used for accessing Account ID and ARN

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
   /*eks_managed_node_groups = {
    example = {
      min_size     = 2
      max_size     = 4
      desired_size = 3

      instance_types = ["t2.large"]
    }
  }*/
  
  # EKS Managed Node Group(s)
   eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

   eks_managed_node_groups = {
    system = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = var.asg_sys_instance_types
      labels = {
        Environment = "test"
      }
      #tags = {
       # Terraform   = "true"
        #Environment = "test"
     # }
    }
  }
  # Cluster access entry
  # To add the current caller identity as an administrator
   enable_cluster_creator_admin_permissions = true

   data "aws_iam_user" "example" {
    user_name = "jenkins
  }
   access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::123456789012:role/something"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }
}
