
data "aws_eks_cluster" "my-cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}
  data "aws_eks_cluster_auth" "my-cluster" {
    name = module.eks.cluster_name
    depends_on = [module.eks.cluster_name]
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
   cluster_endpoint_public_access = true

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

      instance_types = ["t3.small"]
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
}

# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}
