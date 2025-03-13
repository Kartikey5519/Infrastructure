data "aws_caller_identity" "current" {}

locals {
  cluster_name = format("%s-%s", var.name, var.environment)
  oidc_string  = trimprefix(module.eks.cluster_oidc_issuer_url, "https://")
}

data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["<eks_ami_name>"]
  }
}
