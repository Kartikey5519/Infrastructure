name        = "<project_name>"
environment = "dev"
region      = "region_name"

vpc_id = "<vpc_id>"

## Cluster Configuration

cluster_version                        = "<latest_cluster_version>"
cluster_enabled_log_types              = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
subnet_ids                             = ["<subnet_id_1>", "<subnet_id_2>", "<subnet_id_3>"]
cluster_endpoint_private_access        = true
cloudwatch_log_group_retention_in_days = 7
create_oidc_provider_eks               = true

cluster_security_group_additional_rules = {
  allow_from_vpn_and_self = {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    type        = "ingress"
    cidr_blocks = ["<vpn_cidr>"]
    description = "Allow from VPN CIDR"
  },
  ingress_from_node = {
    description                = "Ingress all traffic from node security group"
    protocol                   = "-1"
    from_port                  = 0
    to_port                    = 65535
    type                       = "ingress"
    source_node_security_group = true
  },
  egress_to_node = {
    description                = "Egress all traffic to node security group"
    protocol                   = "-1"
    from_port                  = 0
    to_port                    = 65535
    type                       = "egress"
    source_node_security_group = true
  }
}

## Self Managed Node Group Configuration

node_security_group_additional_rules = {
  ingress_from_cluster = {
    description                   = "Ingress all traffic from master security group"
    protocol                      = "-1"
    from_port                     = 0
    to_port                       = 65535
    type                          = "ingress"
    source_cluster_security_group = true
  },
  egress_to_cluster = {
    description                   = "Egress all traffic from master security group"
    protocol                      = "-1"
    from_port                     = 0
    to_port                       = 65535
    type                          = "egress"
    source_cluster_security_group = true
  },
  ingress_self = {
    description = "Allow node to communicate with each other"
    protocol    = "-1"
    from_port   = 0
    to_port     = 65535
    type        = "ingress"
    self        = true
  },
  egress_self = {
    description = "Allow node to communicate with each other"
    protocol    = "-1"
    from_port   = 0
    to_port     = 65535
    type        = "egress"
    self        = true
  },
  ingress_all = {
    description = "Allow inbound traffic from VPC CIDR"
    protocol    = "-1"
    from_port   = 0
    to_port     = 65535
    type        = "ingress"
    cidr_blocks = ["10.0.0.0/16"]
  },
  egress_all = {
    description = "Allow outbound traffic to all CIDRS"
    protocol    = "-1"
    from_port   = 0
    to_port     = 65535
    type        = "egress"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

velero_s3_bucket_name = "<velero_s3_bucket_name>" #(optional)

eks_managed_node_group_defaults = {

  ## Launch Template Node Group Configuration
  ebs_optimized                          = true
  key_name                               = "<key_name>"
  update_launch_template_default_version = true
}

eks_node_policies = [
  {
    name = "AmazonEKS_CNI_Policy"
  },
  {
    name = "AmazonEKSWorkerNodePolicy"
  },
  {
    name = "AmazonEC2ContainerRegistryReadOnly"
  },
  {
    name = "AmazonEKS_CNI_Policy"
  },
  {
    name = "AmazonEKSWorkerNodePolicy"
  },
  {
    name = "AmazonEC2ContainerRegistryReadOnly"
  }
]

eks_managed_node_groups = {

  node_group_infra_1_29 = {

    ## Node Group Configuration
    min_size     = 5 #as per requirement
    desired_size = 5 #as per requirement
    max_size     = 5 #as per requirement

    subnet_ids = ["<subnet_id>"]

    capacity_type  = "ON_DEMAND"
    instance_types = ["t3.xlarge"]  #as per requirement

    ## Launch Template Configuration
    create_launch_template  = true
    launch_template_version = "1"

    pre_bootstrap_user_data = <<-EOT
      if ! grep -q imageGCHighThresholdPercent /etc/kubernetes/kubelet/kubelet-config.json; 
      then 
          sed -i '/"apiVersion*/a \ \ "imageGCHighThresholdPercent": 70,' /etc/kubernetes/kubelet/kubelet-config.json
      fi
      # Inject imageGCLowThresholdPercent value unless it has already been set.
      if ! grep -q imageGCLowThresholdPercent /etc/kubernetes/kubelet/kubelet-config.json; 
      then 
          sed -i '/"imageGCHigh*/a \ \ "imageGCLowThresholdPercent": 50,' /etc/kubernetes/kubelet/kubelet-config.json
      fi
    EOT

    bootstrap_extra_args = "--kubelet-extra-args --node-labels=<label_name>=infra"

    block_device_mappings = [
      {
        device_name = "/dev/xvda"

        ebs = {
          delete_on_termination = true
          encrypted             = false
          volume_size           = 50 #as per requirement
          volume_type           = "gp3"
        }
      }
    ]
  },

  node_group_demo_1_29 = {

    ## Node Group Configuration
    min_size     = 1
    desired_size = 1
    max_size     = 1

    subnet_ids = ["<subnet_id>"]

    capacity_type  = "ON_DEMAND"
    instance_types = ["t3.xlarge"] #as per requirement

    ## Launch Template Configuration
    create_launch_template  = true
    launch_template_version = "1"

    pre_bootstrap_user_data = <<-EOT
      if ! grep -q imageGCHighThresholdPercent /etc/kubernetes/kubelet/kubelet-config.json; 
      then 
          sed -i '/"apiVersion*/a \ \ "imageGCHighThresholdPercent": 70,' /etc/kubernetes/kubelet/kubelet-config.json
      fi
      # Inject imageGCLowThresholdPercent value unless it has already been set.
      if ! grep -q imageGCLowThresholdPercent /etc/kubernetes/kubelet/kubelet-config.json; 
      then 
          sed -i '/"imageGCHigh*/a \ \ "imageGCLowThresholdPercent": 50,' /etc/kubernetes/kubelet/kubelet-config.json
      fi
    EOT

    bootstrap_extra_args = "--kubelet-extra-args --node-labels=<label_name>=infra"

    block_device_mappings = [
      {
        device_name = "/dev/xvda"

        ebs = {
          delete_on_termination = true
          encrypted             = false
          volume_size           = 50 #as per requirement
          volume_type           = "gp3"
        }
      }
    ]
  },
}
