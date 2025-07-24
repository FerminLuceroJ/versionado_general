module "batch" {
  source  = "terraform-aws-modules/batch/aws"
  version = "3.0.3"

  for_each = var.batch_parameters

  create                   = try(each.value.create, var.batch_defaults.create, true)
  create_instance_iam_role = try(each.value.create_instance_iam_role, var.batch_defaults.create_instance_iam_role, true)
  compute_environments = try(each.value.compute_environments, var.batch_defaults.compute_environments,
    {
      fargate = {
        name_prefix = "${local.common_name}-${each.key}-fargate"

        compute_resources = {
          type      = "FARGATE"
          max_vcpus = try(each.value.max_vcpus, 4)

          security_group_ids = [data.aws_security_group.default[each.key].id]
          #security_group_ids = [module.security_group_batch[each.key].security_group_id]

          subnets = data.aws_subnets.this[each.key].ids
        }
      }

      fargate_spot = {
        name_prefix = "${local.common_name}-${each.key}-fargate_spot"

        compute_resources = {
          type      = "FARGATE_SPOT"
          max_vcpus = try(each.value.max_vcpus, 4)

          security_group_ids = [data.aws_security_group.default[each.key].id]
          #security_group_ids = [module.security_group_batch[each.key].security_group_id]

          subnets = data.aws_subnets.this[each.key].ids
        }
      }
  })
  create_job_queues                      = try(each.value.create_job_queues, var.batch_defaults.create_job_queues, true)
  create_service_iam_role                = try(each.value.create_service_iam_role, var.batch_defaults.create_service_iam_role, true)
  create_spot_fleet_iam_role             = try(each.value.create_spot_fleet_iam_role, var.batch_defaults.create_spot_fleet_iam_role, false)
  instance_iam_role_additional_policies  = try(each.value.instance_iam_role_additional_policies, var.batch_defaults.instance_iam_role_additional_policies, {})
  instance_iam_role_description          = try(each.value.instance_iam_role_description, var.batch_defaults.instance_iam_role_description, null)
  instance_iam_role_name                 = try(each.value.instance_iam_role_name, var.batch_defaults.instance_iam_role_name, "${local.common_name}-${each.key}")
  instance_iam_role_path                 = try(each.value.instance_iam_role_path, var.batch_defaults.instance_iam_role_path, null)
  instance_iam_role_permissions_boundary = try(each.value.instance_iam_role_permissions_boundary, var.batch_defaults.instance_iam_role_permissions_boundary, null)
  instance_iam_role_tags                 = try(each.value.instance_iam_role_tags, var.batch_defaults.instance_iam_role_tags, {})
  instance_iam_role_use_name_prefix      = try(each.value.instance_iam_role_use_name_prefix, var.batch_defaults.instance_iam_role_use_name_prefix, true)
  job_queues = try(each.value.job_queues, var.batch_defaults.job_queues, {
    low_priority = {
      name     = "${local.common_name}-${each.key}-LowPriorityFargate"
      state    = "ENABLED"
      priority = 1

      compute_environment_order = {
        0 = {
          compute_environment_key = "fargate"
        }
        1 = {
          compute_environment_key = "fargate_spot"
        }
      }

      tags = {
        JobQueue = "Low priority job queue"
      }
    }

    high_priority = {
      name     = "${local.common_name}-${each.key}-HighPriorityFargate"
      state    = "ENABLED"
      priority = 99

      compute_environment_order = {
        0 = {
          compute_environment_key = "fargate"
        }
        1 = {
          compute_environment_key = "fargate_spot"
        }
      }

      fair_share_policy = {
        compute_reservation = 1
        share_decay_seconds = 3600

        share_distribution = [{
          share_identifier = "A1*"
          weight_factor    = 0.1
          }, {
          share_identifier = "A2"
          weight_factor    = 0.2
        }]
      }

      tags = {
        JobQueue = "High priority job queue"
      }
    }
  })
  service_iam_role_additional_policies     = try(each.value.service_iam_role_additional_policies, var.batch_defaults.service_iam_role_additional_policies, {})
  service_iam_role_description             = try(each.value.service_iam_role_description, var.batch_defaults.service_iam_role_description, null)
  service_iam_role_name                    = try(each.value.service_iam_role_name, var.batch_defaults.service_iam_role_name, "${local.common_name}-${each.key}")
  service_iam_role_path                    = try(each.value.service_iam_role_path, var.batch_defaults.service_iam_role_path, null)
  service_iam_role_permissions_boundary    = try(each.value.service_iam_role_permissions_boundary, var.batch_defaults.service_iam_role_permissions_boundary, null)
  service_iam_role_tags                    = try(each.value.service_iam_role_tags, var.batch_defaults.service_iam_role_tags, {})
  service_iam_role_use_name_prefix         = try(each.value.service_iam_role_use_name_prefix, var.batch_defaults.service_iam_role_use_name_prefix, true)
  spot_fleet_iam_role_additional_policies  = try(each.value.spot_fleet_iam_role_additional_policies, var.batch_defaults.spot_fleet_iam_role_additional_policies, {})
  spot_fleet_iam_role_description          = try(each.value.spot_fleet_iam_role_description, var.batch_defaults.spot_fleet_iam_role_description, null)
  spot_fleet_iam_role_name                 = try(each.value.spot_fleet_iam_role_name, var.batch_defaults.spot_fleet_iam_role_name, null)
  spot_fleet_iam_role_path                 = try(each.value.spot_fleet_iam_role_path, var.batch_defaults.spot_fleet_iam_role_path, null)
  spot_fleet_iam_role_permissions_boundary = try(each.value.spot_fleet_iam_role_permissions_boundary, var.batch_defaults.spot_fleet_iam_role_permissions_boundary, null)
  spot_fleet_iam_role_tags                 = try(each.value.spot_fleet_iam_role_tags, var.batch_defaults.spot_fleet_iam_role_tags, {})
  spot_fleet_iam_role_use_name_prefix      = try(each.value.spot_fleet_iam_role_use_name_prefix, var.batch_defaults.spot_fleet_iam_role_use_name_prefix, true)

  tags = local.common_tags
}