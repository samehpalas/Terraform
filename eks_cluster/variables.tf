variable "asg_sys_instance_types" {
  type        = list(string)
  default     = ["t3a.medium"]
  description = "List of EC2 instance machine types to be used in EKS for the system workload."
}

variable "asg_dev_instance_types" {
  type        = list(string)
  default     = ["t3a.medium"]
  description = "List of EC2 instance machine types to be used in EKS for development workload."
}
