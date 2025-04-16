variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "main"
}

variable "eks_cluster_role_name" {
  description = "IAM role name for the EKS cluster"
  type        = string
  default     = "EKSCLUSTERROLE"
}

variable "eks_node_role_name" {
  description = "IAM role name for the EKS worker nodes"
  type        = string
  default     = "Noderole"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster and node group"
  type        = list(string)
  default     = [
    "subnet-0d2946b4c4b74b62f",
    "subnet-008ab151b9f9c72f4",
    "subnet-04a60648c68144bb2"
  ]
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
  default     = "Noderole"
}

variable "desired_size" {
  description = "Desired number of worker nodes in the node group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes in the node group"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes in the node group"
  type        = number
  default     = 1
}

variable "max_unavailable" {
  description = "Number of nodes that can be unavailable during updates"
  type        = number
  default     = 1
}

variable "region" {
  description = "AWS region to deploy EKS"
  type        = string
  default     = "us-east-1"  # or any region you are working in
}
