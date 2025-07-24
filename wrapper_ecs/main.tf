module "ecs" {
  for_each = var.ecs_parameters
  source   = "terraform-aws-modules/ecs/aws//modules/cluster"
  version  = "6.1.0"

  create  = true
  name    = "${local.common_name}-${each.key}"
  setting = try(each.value.cluster_settings, var.ecs_defaults.cluster_settings, [{ "name" : "containerInsights", "value" : "enabled" }])
  configuration = try(each.value.cluster_configuration, var.ecs_defaults.cluster_configuration,
    {
      execute_command_configuration = {
        logging = "OVERRIDE"
        log_configuration = {
          cloud_watch_log_group_name = "/aws/ecs/${local.common_name}-${each.key}"
        }
      }
    }
  )
  default_capacity_provider_strategy = try(each.value.default_capacity_provider_strategy, var.ecs_defaults.default_capacity_provider_strategy,
    {
      FARGATE = {
        weight = 0
      }
    }
  )
  autoscaling_capacity_providers         = try(each.value.autoscaling_capacity_providers, var.ecs_defaults.autoscaling_capacity_providers, {})
  create_cloudwatch_log_group            = try(each.value.create_cloudwatch_log_group, var.ecs_defaults.create_cloudwatch_log_group, true)
  cloudwatch_log_group_class             = try(each.value.cloudwatch_log_group_class, var.ecs_defaults.cloudwatch_log_group_class, null)
  cloudwatch_log_group_kms_key_id        = try(each.value.cloudwatch_log_group_kms_key_id, var.ecs_defaults.cloudwatch_log_group_kms_key_id, null)
  cloudwatch_log_group_name              = try(each.value.cloudwatch_log_group_name, var.ecs_defaults.cloudwatch_log_group_name, null)
  cloudwatch_log_group_retention_in_days = try(each.value.cloudwatch_log_group_retention_in_days, var.ecs_defaults.cloudwatch_log_group_retention_in_days, 14)
  cloudwatch_log_group_tags              = try(each.value.cloudwatch_log_group_tags, var.ecs_defaults.cloudwatch_log_group_tags, {})
  service_connect_defaults               = try(each.value.cluster_service_connect_defaults, var.ecs_defaults.cluster_service_connect_defaults, null)
  create_task_exec_iam_role              = try(each.value.create_task_exec_iam_role, var.ecs_defaults.create_task_exec_iam_role, false)
  create_task_exec_policy                = try(each.value.create_task_exec_policy, var.ecs_defaults.create_task_exec_policy, false)
  # task_exec_iam_role_description          = try(each.value.task_exec_iam_role_description, var.ecs_defaults.task_exec_iam_role_description, null)
  # task_exec_iam_role_name                 = try(each.value.task_exec_iam_role_name, var.ecs_defaults.task_exec_iam_role_name, null)
  # task_exec_iam_role_path                 = try(each.value.task_exec_iam_role_path, var.ecs_defaults.task_exec_iam_role_path, null)
  # task_exec_iam_role_permissions_boundary = try(each.value.task_exec_iam_role_permissions_boundary, var.ecs_defaults.task_exec_iam_role_permissions_boundary, null)
  # task_exec_iam_role_policies             = try(each.value.task_exec_iam_role_policies, var.ecs_defaults.task_exec_iam_role_policies, {})
  # task_exec_iam_role_tags                 = try(each.value.task_exec_iam_role_tags, var.ecs_defaults.task_exec_iam_role_tags, {})
  # task_exec_iam_role_use_name_prefix      = try(each.value.task_exec_iam_role_use_name_prefix, var.ecs_defaults.task_exec_iam_role_use_name_prefix, true)
  # task_exec_iam_statements                = try(each.value.task_exec_iam_statements, var.ecs_defaults.task_exec_iam_statements, {})
  # task_exec_secret_arns                   = try(each.value.task_exec_secret_arns, var.ecs_defaults.task_exec_secret_arns, ["arn:aws:secretsmanager:*:*:secret:*"])
  # task_exec_ssm_param_arns                = try(each.value.task_exec_ssm_param_arns, var.ecs_defaults.task_exec_ssm_param_arns, ["arn:aws:ssm:*:*:parameter/*"])


  tags = local.common_tags
}