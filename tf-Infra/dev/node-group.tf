## EKS Managed Node Group

module "eks_managed_node_group" {
  source = "../../tf-modules/modules/eks-managed-node-group"

  for_each = { for k, v in var.eks_managed_node_groups : k => v }

  ## User Data
  cluster_name               = module.eks.cluster_id
  cluster_endpoint           = module.eks.cluster_endpoint
  cluster_auth_base64        = module.eks.cluster_certificate_authority_data
  enable_bootstrap_user_data = true
  pre_bootstrap_user_data    = try(each.value.pre_bootstrap_user_data, var.eks_managed_node_group_defaults.pre_bootstrap_user_data, "")
  bootstrap_extra_args       = try(each.value.bootstrap_extra_args, var.eks_managed_node_group_defaults.bootstrap_extra_args, "")

  ## Launch Template
  create_launch_template      = try(each.value.create_launch_template, var.eks_managed_node_group_defaults.create_launch_template, false)
  launch_template_name        = try(each.value.launch_template_name, format("%s-%s", local.cluster_name, each.key))
  launch_template_version     = try(each.value.launch_template_version, var.eks_managed_node_group_defaults.launch_template_version, "$Default")
  launch_template_description = try(each.value.launch_template_description, var.eks_managed_node_group_defaults.launch_template_description, null)

  ebs_optimized   = try(each.value.ebs_optimized, var.eks_managed_node_group_defaults.ebs_optimized, true)
  ami_id          = data.aws_ami.eks_default.image_id
  key_name        = try(each.value.key_name, var.eks_managed_node_group_defaults.key_name, null)
  cluster_version = var.cluster_version

  create_security_group                  = var.create_node_security_group
  vpc_security_group_ids                 = compact(concat([module.eks.node_security_group_id], try(each.value.vpc_security_group_ids, var.eks_managed_node_group_defaults.vpc_security_group_ids, [])))
  cluster_security_group_id              = var.create_node_security_group ? var.cluster_security_group_id : null
  update_launch_template_default_version = try(each.value.update_launch_template_default_version, var.eks_managed_node_group_defaults.update_launch_template_default_version, true)

  block_device_mappings = try(each.value.block_device_mappings, var.eks_managed_node_group_defaults.block_device_mappings, [])
  network_interfaces    = try(each.value.network_interfaces, var.eks_managed_node_group_defaults.network_interfaces, [])

  launch_template_tags = merge(
    {
      "Name" = format("%s-%s", local.cluster_name, each.key)
    },
    try(each.value.launch_template_tags, var.eks_managed_node_group_defaults.launch_template_tags, {})
  )

  ## IAM Role
  create_iam_role = false
  iam_role_arn    = aws_iam_role.eks_node_role.arn

  ## Security Group
  vpc_id = var.create_node_security_group ? var.vpc_id : null

  ## Node Group
  name = try(each.value.node_group_name, format("%s-%s", local.cluster_name, each.key))

  subnet_ids = try(each.value.subnet_ids, var.eks_managed_node_group_defaults.subnet_ids, null)

  min_size      = try(each.value.min_size, var.eks_managed_node_group_defaults.min_size, 1) #as per requirement
  desired_size  = try(each.value.desired_size, var.eks_managed_node_group_defaults.desired_size, 1) #as per requirement
  max_size      = try(each.value.max_size, var.eks_managed_node_group_defaults.max_size, 3) #as per requirement
  capacity_type = try(each.value.capacity_type, var.eks_managed_node_group_defaults.capacity_type, "ON_DEMAND")

  instance_types = try(each.value.instance_types, var.eks_managed_node_group_defaults.instance_types, null)

  labels = try(each.value.node_labels, var.eks_managed_node_group_defaults.node_labels, null)

  taints = try(each.value.node_taints, var.eks_managed_node_group_defaults.node_taints, {})

  ## Below tag applies to both launch template and node group if specified
  tags = merge(var.tags, try(each.value.tags, var.eks_managed_node_group_defaults.tags, {}))

  depends_on = [
    aws_iam_role.eks_node_role
  ]
}
