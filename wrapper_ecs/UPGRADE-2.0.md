# Upgrade from v1.x to v2.0

If you have a question regarding this upgrade process, please check code in `examples` directory:

If you found a bug, please open an issue in this repository.

## List of Changes

1. Removed resources

  - `default_capacity_provider_use_fargate`
  - `fargate_capacity_providers`

2. Moved resources

  - `fargate_capacity_providers` => `default_capacity_provider_strategy`

### Changed default variable values

1. Variables new values:

  - **cluster_settings** format changed from object to list of objects
  - **fargate_capacity_providers** renamed to **default_capacity_provider_strategy** and format change

## List of backward incompatible changes

### New ECS Parameters format

#### Before 2.x

```hcl
module "wrapper_ecs" {
  source = "../../"

  metadata = local.metadata
  project  = "example"

  ecs_parameters = {
    "00" = {
      cluster_settings = {
        name  = "containerInsights"
        value = "disabled"
      }
      default_capacity_provider_use_fargate = true
      fargate_capacity_providers = {
        FARGATE = {
          default_capacity_provider_strategy = {
            weight = 50
          }
        }
        FARGATE_SPOT = {
          default_capacity_provider_strategy = {
            weight = 50
          }
        }
      }
      autoscaling_capacity_providers = {}
    }
  }
  ecs_defaults = var.ecs_defaults
}
```

#### After 2.0

```hcl
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
    }
  }
  ecs_defaults = var.ecs_defaults
}
```