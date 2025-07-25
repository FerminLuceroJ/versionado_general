locals {
  metadata = var.metadata

  common_name_prefix = join("-", [
    local.metadata.key.company,
    local.metadata.key.env
  ])

  common_name = join("-", [
    local.common_name_prefix,
    var.project
  ])

  common_tags = {
    "company"     = local.metadata.key.company
    "provisioner" = "terraform"
    "environment" = local.metadata.environment
    "project"     = var.project
    "created-by"  = "GoCloud.la"
  }

  # VPC Name
  default_vpc_name       = local.common_name_prefix
  default_subnet_name    = "${local.common_name_prefix}-private*"
  default_security_group = "${local.common_name_prefix}-default"

  # default_egress_with_cidr_blocks_batch = [
  #   {
  #     rule        = "all-all"
  #     cidr_blocks = "0.0.0.0/0"
  #   }
  # ]

}