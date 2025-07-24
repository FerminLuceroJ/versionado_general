resource "aws_ssm_parameter" "cw_agent_config" {
  count = local.condition_create_enable

  name        = "${local.base_resource_name}-cwagent-config"
  description = "CWAgent SSM Parameter with App Mesh and Java EMF Definition for ECS Cluster: ${local.base_resource_name}"
  type        = "String"
  data_type   = "text"
  tier        = "Intelligent-Tiering"
  value       = local.ssm_parameter_cw_agent_config_value
  tags        = var.tags
}

resource "aws_ssm_parameter" "prometheus_config" {
  count = local.condition_create_enable

  name        = "${local.base_resource_name}-cwagent-prometheus-config"
  description = "Prometheus Scraping SSM Parameter for ECS Cluster: ${local.base_resource_name}"
  type        = "String"
  data_type   = "text"
  tier        = "Standard"
  value       = local.ssm_parameter_prometheus_config_value
  tags        = var.tags
}

module "app_container_definition" {
  source = "../../../../../../../workload/modules/aws/terraform-aws-container/modules/container_definition"

  count = local.condition_create_enable

  container_name  = "${local.base_resource_name}-cwagent-prometheus"
  container_image = "amazon/cloudwatch-agent:1.247354.0b251981"
  port_mappings   = []
  map_secrets     = local.container_environments
  docker_labels   = {}
  log_configuration = {
    logDriver     = "awslogs"
    secretOptions = null
    options = {
      "awslogs-group"         = "/aws/ecs/$${cloudwatch_log_group_name}"
      "awslogs-region"        = var.aws_region
      "awslogs-create-group"  = true
      "awslogs-stream-prefix" = "ecs"
    }
  }
  ulimits = []
}

module "container_module" {
  source = "../../../../../../../workload/modules/aws/terraform-aws-container"

  count               = local.condition_create_enable
  name                = substr("${local.base_resource_name}-cwagent-prometheus", 0, 50)
  common_name_base    = local.common_name_base
  common_name_project = local.common_name_project
  tags                = var.tags

  vpc_name                           = local.vpc_name
  ecs_task_port                      = 12345 #no deberia ser pedido
  ecs_task_cpu                       = var.ecs_task_cpu
  ecs_task_memory                    = var.ecs_task_memory
  ecs_task_container_definitions     = "[${module.app_container_definition[0].json_map_encoded}]"
  ecs_service_primary_container_name = "${local.base_resource_name}-cwagent-prometheus"
  ecs_service_task_desired_count     = 1
  ecs_task_iam_role_policies = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  "${aws_iam_policy.ecs_service_discovery[0].arn}"]
  ecs_execution_iam_role_policies = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  "${aws_iam_policy.ecs_ssm[0].arn}"]

  enable_ecs_service_autoscaling  = false
  enable_ecs_service_target_group = false
  enable_create_ecr               = false

  ecs_service_health_check_grace_period_seconds = null
}

resource "aws_iam_policy" "ecs_ssm" {
  count = local.condition_create_enable

  name        = "${local.base_resource_name}-ecs-ssm"
  path        = "/"
  description = ""

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "arn:aws:ssm:*:*:parameter/${local.base_resource_name}-*",
            "Effect": "Allow"
        }
    ]
}
  EOF

  tags = var.tags
}

resource "aws_iam_policy" "ecs_service_discovery" {
  count = local.condition_create_enable

  name        = "${local.base_resource_name}-ecs-service-discovery"
  path        = "/"
  description = ""

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Condition": {
                "ArnEquals": {
                    "ecs:cluster": "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${local.base_resource_name}"
                }
            },
            "Action": [
                "ecs:DescribeTasks",
                "ecs:ListTasks",
                "ecs:DescribeContainerInstances",
                "ecs:DescribeServices",
                "ecs:ListServices"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "ec2:DescribeInstances",
                "ecs:DescribeTaskDefinition"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
  tags   = var.tags

}
