# Documentation

## Introducción

El Wrapper de Terraform para AWS Batch define la configuración de los compute environments y las colas de prioridad para los jobs.
[Documentación Módulo Externo Batch](https://registry.terraform.io/modules/terraform-aws-modules/batch/aws/2.1.0)

**Diagrama** <br/>

A continuación se puede ver una imagen que muestra la totalidad de recursos que se pueden desplegar con el wrapper:

<center>![alt text](diagrams/main.png)</center>

---

## Modo de Uso

```hcl
  batch_parameters = {
    "00" = {
      # Cantidad de cpu a utilizar por los compute environments
      #max_vcpus = 4 # Default: 4
    }
  }
  batch_defaults = var.batch_defaults
```
<details>
<summary>Tabla de Variables</summary>

| Variable                              | Descripción de variable                                                                  | Tipo            | Default                     | Alternatives           |
|---------------------------------------|------------------------------------------------------------------------------------------|-----------------|-----------------------------|------------------------|
| compute_environments                  | Map of compute environment definitions to create                                         | `any`           | `{}`                        | `Custom compute environment` |
| create                                | Controls if resources should be created (affects nearly all resources)                  | `bool`          | `true`                      | `false`               |
| create_instance_iam_role              | Determines whether an IAM role is created or to use an existing IAM role                | `bool`          | `true`                      | `false`               |
| create_job_queues                     | Determines whether to create job queues                                                 | `bool`          | `true`                      | `false`               |
| create_service_iam_role               | Determines whether an IAM role is created or to use an existing IAM role                | `bool`          | `true`                      | `false`               |
| create_spot_fleet_iam_role            | Determines whether an IAM role is created or to use an existing IAM role                | `bool`          | `false`                     | `true`                |
| instance_iam_role_additional_policies | Additional policies to be added to the IAM role                                         | `map(string)`  | `{}`                        | `Custom policy list`  |
| instance_iam_role_description         | Cluster instance IAM role description                                                   | `string`        | `null`                      | `Custom description`  |
| instance_iam_role_name                | Cluster instance IAM role name                                                          | `string`        | `null`                      | `Custom name`         |
| instance_iam_role_path                | Cluster instance IAM role path                                                          | `string`        | `null`                      | `Custom path`         |
| instance_iam_role_permissions_boundary| ARN of the policy that is used to set the permissions boundary for the IAM role         | `string`        | `null`                      | `Custom ARN`          |
| instance_iam_role_tags                | A map of additional tags to add to the IAM role created                                 | `map(string)`   | `{}`                        | `Custom tag map`      |
| instance_iam_role_use_name_prefix     | Determines whether the IAM role name (instance_iam_role_name) is used as a prefix       | `string`        | `true`                      | `false`               |
| job_queues                            | Map of job queue and scheduling policy definitions to create                            | `any`           | `{}`                        | `Custom job queue`    |
| service_iam_role_additional_policies  | Additional policies to be added to the IAM role                                         | `maps(string)`  | `{}`                        | `Custom policy list`  |
| service_iam_role_description          | Batch service IAM role description                                                      | `string`        | `null`                      | `Custom description`  |
| service_iam_role_name                 | Batch service IAM role name                                                             | `string`        | `null`                      | `Custom name`         |
| service_iam_role_path                 | Batch service IAM role path                                                             | `string`        | `null`                      | `Custom path`         |
| service_iam_role_permissions_boundary| ARN of the policy that is used to set the permissions boundary for the IAM role         | `string`        | `null`                      | `Custom ARN`          |
| service_iam_role_tags                 | A map of additional tags to add to the IAM role created                                 | `map(string)`   | `{}`                        | `Custom tag map`      |
| service_iam_role_use_name_prefix      | Determines whether the IAM role name (service_iam_role_name) is used as a prefix        | `bool`          | `true`                      | `false`               |
| spot_fleet_iam_role_additional_policies| Additional policies to be added to the IAM role                                        | `list(string)`  | `{}`                        | `Custom policy list`  |
| spot_fleet_iam_role_description       | Spot fleet IAM role description                                                         | `string`        | `null`                      | `Custom description`  |
| spot_fleet_iam_role_name              | Spot fleet IAM role name                                                                | `string`        | `null`                      | `Custom name`         |
| spot_fleet_iam_role_path              | Spot fleet IAM role path                                                                | `string`        | `null`                      | `Custom path`         |
| spot_fleet_iam_role_permissions_boundary| ARN of the policy that is used to set the permissions boundary for the IAM role         | `string`        | `null`                      | `Custom ARN`          |
| spot_fleet_iam_role_tags              | A map of additional tags to add to the IAM role created                                 | `map(string)`   | `{}`                        | `Custom tag map`      |
| spot_fleet_iam_role_use_name_prefix   | Determines whether the IAM role name (spot_fleet_iam_role_name) is used as a prefix     | `bool`          | `true`                      | `false`               |
| tags                                  | A map of tags to add to all resources                                                   | `map(string)`   | `{}`                        | `Custom tag map`      |

</details>

## Modo de Uso Avanzado

### Administración de compute environments
Posibilita definir y administrar múltiples compute environments en caso de requerir utilizar infraestructura provisionada como alternativa a fargate y fargate_spot.

<details>
<summary>Código</summary>

```hcl
fargate = {
        name_prefix = "${local.common_name}-${each.key}-fargate"

        compute_resources = {
          type      = "FARGATE"
          max_vcpus = try(each.value.max_vcpus, 4)

          security_group_ids = [data.aws_security_group.default[each.key].id]
          subnets            = data.aws_subnets.this[each.key].ids
        }
      }

      fargate_spot = {
        name_prefix = "${local.common_name}-${each.key}-fargate_spot"

        compute_resources = {
          type      = "FARGATE_SPOT"
          max_vcpus = try(each.value.max_vcpus, 4)

          security_group_ids = [data.aws_security_group.default[each.key].id]
          subnets            = data.aws_subnets.this[each.key].ids
        }
      }

```
</details>

### Administración de colas de jobs
Gestiona colas de trabajos con prioridad, optimizando la asignación de recursos entre tareas de alta y baja prioridad.

<details>
<summary>Código</summary>

```hcl
low_priority = {
      name     = "${local.common_name}-${each.key}-LowPriorityFargate"
      state    = "ENABLED"
      priority = 1

      tags = {
        JobQueue = "Low priority job queue"
      }
    }

    high_priority = {
      name     = "${local.common_name}-${each.key}-HighPriorityFargate"
      state    = "ENABLED"
      priority = 99

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
```
</details>
