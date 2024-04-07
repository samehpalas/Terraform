provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  config_paths = "false"
  host                   =  data.aws_eks_cluster.my-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.my-cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.my-cluster.token   
}
