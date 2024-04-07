
data "aws_eks_cluster" "my-cluster" {
  name = module.eks.cluster_name
}
  data "aws_eks_cluster_auth" "my-cluster" {
    name = module.eks.cluster_name
  }
data "aws_caller_identity" "current" {} # used for accessing Account ID and ARN
data "aws_iam_user" "example" {
    user_name = "jenkins"
  }

module "eks" {
   source  = "terraform-aws-modules/eks/aws"
   version = "20.8.3"
   cluster_name = "${var.name_prefix}"
   cluster_version = "1.29"
   subnet_ids = module.vpc.private_subnets
   vpc_id =  module.vpc.vpc_id

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


   access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = []
      principal_arn     = data.aws_iam_user.example.arn

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
