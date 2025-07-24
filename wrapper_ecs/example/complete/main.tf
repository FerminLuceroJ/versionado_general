module "wrapper_ecs" {
  source = "../../"

  metadata = local.metadata
  project  = "example"


  ecs_parameters = {
    "00" = {
      cluster_settings = [{
        name  = "containerInsights"
        value = "disabled"
      }]

      default_capacity_provider_strategy = {
        FARGATE = {
          weight = 50
        }
        FARGATE_SPOT = {
          weight = 50
        }
      }
      autoscaling_capacity_providers = {}

      # Disable Cloudwatch
      # create_cloudwatch_log_group = false # Default: true
      # cluster_configuration = {}
      # Cloudwatch: retention
      # cloudwatch_log_group_retention_in_days = 14
    }
  }
  ecs_defaults = var.ecs_defaults
}