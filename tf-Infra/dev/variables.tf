## EKS Cluster Variables

variable "name" {
  default = ""
  type    = string
}

variable "region" {
  default = ""
  type    = string
}

variable "environment" {
  default = ""
  type    = string
}

variable "vpc_id" {
  default = ""
  type    = string
}

variable "eks_iam_role_use_name_prefix" {
  default = false
  type    = bool
}

variable "cluster_version" {
  default = ""
  type    = string
}

variable "cluster_enabled_log_types" {
  default = [""]
  type    = list(string)
}

variable "cluster_security_group_use_name_prefix" {
  default = false
  type    = bool
}

variable "subnet_ids" {
  default = [""]
  type    = list(string)
}

variable "cluster_endpoint_private_access" {
  default = false
  type    = bool
}

variable "cluster_endpoint_public_access" {
  default = false
  type    = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  default = ["0.0.0.0/0"]
  type    = list(string)
}

variable "cluster_security_group_additional_rules" {
  default = {}
  type    = any
}

variable "node_security_group_use_name_prefix" {
  default = false
  type    = bool
}

variable "node_security_group_additional_rules" {
  default = {}
  type    = any
}

variable "cloudwatch_log_group_retention_in_days" {
  default = 15
  type    = number
}

variable "create_oidc_provider_eks" {
  default = false
  type    = bool
}

variable "tags" {
  default = {}
  type    = map(string)
}

## EKS Managed Node Group Configuration

variable "cluster_name" {
  default = ""
  type    = string
}

variable "create_node_security_group" {
  default = false
  type    = bool
}

variable "cluster_security_group_id" {
  default = ""
  type    = string
}

variable "ami_id" {
  default = ""
  type    = string
}

variable "eks_managed_node_group_defaults" {
  default = {}
  type    = any
}

variable "eks_managed_node_groups" {
  default = {}
  type    = any
}

variable "eks_node_policies" {
  default = [""]
  type    = list(string)
}

variable "velero_s3_bucket_name" {
  default = ""
  type    = string
}
