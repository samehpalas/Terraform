variable vpc_cidr_block {}

variable private_subnet_cidr_blocks {}

variable public_subnet_cidr_blocks {}

variable "asg_sys_instance_types" {
  type        = list(string)
  default     = ["t3a.medium"]
  description = "List of EC2 instance machine types to be used in EKS for the system workload."
}


variable "name_prefix" {
  type        = string
  default     = "app3-eks"
  description = "Prefix to be used on each infrastructure object Name created in AWS."
}

variable "environment" {
  type    = string
  default = "test"
}
