## EKS ControlPlane

module "eks" {
  source = "../../tf-modules"

  cluster_name                            = local.cluster_name
  vpc_id                                  = var.vpc_id
  create_iam_role                         = true
  iam_role_name                           = format("%s-eks-master-role", local.cluster_name)
  iam_role_use_name_prefix                = var.eks_iam_role_use_name_prefix
  cluster_version                         = var.cluster_version
  cluster_enabled_log_types               = var.cluster_enabled_log_types
  subnet_ids                              = var.subnet_ids
  cluster_endpoint_private_access         = var.cluster_endpoint_private_access
  cluster_endpoint_public_access          = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs    = var.cluster_endpoint_public_access_cidrs
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  cluster_security_group_use_name_prefix  = var.cluster_security_group_use_name_prefix
  cloudwatch_log_group_retention_in_days  = var.cloudwatch_log_group_retention_in_days
  enable_irsa                             = var.create_oidc_provider_eks

  create_node_security_group           = true
  node_security_group_additional_rules = var.node_security_group_additional_rules
  node_security_group_use_name_prefix  = var.node_security_group_use_name_prefix

  tags = var.tags
}
