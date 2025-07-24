# module "security_group_batch" {
#   for_each = var.batch_parameters

#   source  = "terraform-aws-modules/security-group/aws"
#   version = "~> 5.2.0"

#   name                     = "${local.common_name}-batch-${each.key}"
#   vpc_id                   = data.aws_vpc.this[each.key].id
#   use_name_prefix          = false
#   ingress_with_cidr_blocks = lookup(each.value, "ingress_with_cidr_blocks", [])
#   egress_with_cidr_blocks  = lookup(each.value, "egress_with_cidr_blocks", local.default_egress_with_cidr_blocks_batch)

#   tags = local.common_tags
# }

# NO SE APLICA POR EL SIGUIENTE ERROR:

# │ Error: Invalid for_each argument
# │ 
# │   on .terraform/modules/wrapper_batch.batch/main.tf line 8, in resource "aws_batch_compute_environment" "this":
# │    8:   for_each = { for k, v in var.compute_environments : k => v if var.create }
# │     ├────────────────
# │     │ var.compute_environments will be known only after apply
# │     │ var.create is true
# │ 
# │ The "for_each" map includes keys derived from resource attributes that cannot be determined until apply, and so
# │ Terraform cannot determine the full set of keys that will identify the instances of this resource.
# │ 
# │ When working with unknown values in for_each, it's better to define the map keys statically in your configuration and
# │ place apply-time results only in the map values.
# │ 
# │ Alternatively, you could use the -target planning option to first apply only the resources that the for_each value
# │ depends on, and then apply a second time to fully converge.
# ╵