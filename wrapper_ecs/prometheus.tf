# DISABLED
# module "ecs_cloudwatch_agent" {
#   for_each = var.ecs_parameters
#   source   = "./modules/aws/terraform-aws-ecs-cloudwatch-agent"

#   name                = "${local.common_name}-${each.key}"
#   create_enable       = lookup(each.value, "enabled_cw_agent", false)
#   common_name_base    = local.common_name_prefix
#   common_name_project = local.common_name
#   aws_region          = local.metadata.aws_region
#   vpc_name            = local.vpc_name
#   tags                = local.common_tags
# }
