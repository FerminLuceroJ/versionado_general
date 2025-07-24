# Documentation

## Introducción

El Wrapper de Terraform para AWS ECS simplifica la configuración del servicio de clusteres en la nube de AWS. Este envoltorio actúa como una plantilla predefinida, haciendo más fácil la creación y gestión de servicios ECS al ocuparse de todos los detalles técnicos.
[Documentación Módulo Externo ECS](https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/6.0.4)

**Modulos Externos** <br/>
[terraform-aws-ecs (5.12.0)](https://github.com/terraform-aws-modules/terraform-aws-ecs) <br/>

**Diagrama** <br/>

A continuación se puede ver una imagen que muestra la totalidad de recursos que se pueden desplegar con el wrapper:

<center>![alt text](diagrams/main.png)</center>

---

## Modo de Uso

```hcl
ecs_parameters = {
  ## Definición del cluster
  "00" = {
    ## Configuración de los parametros del cluster
    cluster_settings = {
      name  = "containerInsights"
      value = "disabled"
    }
  }
}
ecs_defaults = var.ecs_defaults
```
<details>
<summary>Tabla de Variables</summary>

| Variable                              | Descripción de variable                                                                 | Tipo          | Default                                                                     | Alternativas                                                                |
|---------------------------------------|-----------------------------------------------------------------------------------------|---------------|-----------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| cluster_settings                      | Configuration block(s) with cluster settings.                                           | `map(string)` | ```{ "name": "containerInsights", "value": "disabled" }```                  | ```{ "name": "containerInsights", "value": "enabled" }```                   |
| configuration                         | The execute command configuration for the cluster                                       | `any`         | ```{ execute_command_configuration = { logging = "DEFAULT" } }```           | ```{ execute_command_configuration = { logging = "NONE" } }```              |
| autoscaling_capacity_providers        | Map of autoscaling capacity provider definitons to create for the cluster               | `any`         | ```{}```                                                                    | ```{}```                                                                    |
| create_cloudwatch_log_group           | Create a cloudwatch log group                                                           | `bool`        | true                                                                        | true or false                                                               |
| cloudwatch_log_group_class            | Specified the log class of the log group                                                | `string`      | null                                                                        | `STANDARD` or `INFREQUENT_ACCESS`                                           |
| cloudwatch_log_group_kms_key_id       | Determines the KMS key id                                                               | `string`      | null                                                                        | Specific KMS                                                                |
| cloudwatch_log_group_name             | Name of the cloudwatch group                                                            | `string`      | null                                                                        | custom name                                                                 |
| cloudwatch_log_group_retention_in_days| Days of retention of the cloudwatch group                                               | `number`      | 14                                                                          | custom number                                                               |
| cloudwatch_log_group_tags             | Tags to apply to the CloudWatch log group.                                              | `map(string)` | ```{}```                                                                    | custom tags                                                                 |
| cluster_service_connect_defaults      | Default configuration for the service connection in the cluster.                        | `map(any)`    | ```{}```                                                                    | Specific configuration                                                      |
| create_task_exec_iam_role             | Determines the creation of a IAM role for task execution.                               | `bool`        | false                                                                       | true or false                                                               |
| create_task_exec_policy               | Determines the creation of IAM policy for task execution.                               | `bool`        | false                                                                       | true or false                                                               |
| default_capacity_provider_strategy    | Map of default capacity provider strategy definitions to use for the cluster            | `map(objet)`  | `{ FARGATE = { weight = 0 } })`                                             | Custom default capacity provider strategy                                                               |

</details>

:::info 
Habilitar la función para Container Insights genera costos adicionales.<br/>
:::
---

## Modo de Uso Avanzado

### Administración de Proveedores de Capacidad
Posibilita definir y administrar múltiples proveedores de capacidad en caso de requerir utilizar infraestructura provisionada como alternativa a fargate + fargate_spot.
<details>
<summary>Código</summary>
```hcl
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
      # cluster_configuration = { execute_command_configuration = { logging = "DEFAULT" } }

      # Cloudwatch: retention
      # cloudwatch_log_group_retention_in_days = 14
    }
  }
```
</details>