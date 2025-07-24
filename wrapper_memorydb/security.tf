module "security_group" {
  for_each = var.memorydb_parameters

  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name            = "${local.common_name}-memorydb-${each.key}"
  vpc_id          = data.aws_vpc.this[each.key].id
  use_name_prefix = false
  ingress_with_cidr_blocks = lookup(each.value, "ingress_with_cidr_blocks", [
    {
      rule        = "redis-tcp"
      cidr_blocks = data.aws_vpc.this[each.key].cidr_block
    }
  ])

  tags = local.common_tags
}