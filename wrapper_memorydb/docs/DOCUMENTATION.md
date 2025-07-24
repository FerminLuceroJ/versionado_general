# Documentation

## Introducción

El Wrapper de Terraform para MemoryDB simplifica la creacion del servicio MemoryDB (compatibilidad Redis) de Amazon, crea Cluster, redistro DNS y SecurityGroup asociado al servicio.

**Features**
- TODO

**Diagrama** <br/>
A continuación se puede ver una imagen que muestra la totalidad de recursos que se pueden desplegar con el wrapper:

<center>![alt text](diagrams/main.png)</center>

---

## Modo de Uso
```hcl
memorydb_parameters = {
  "ExSimple" = {
    subnets = data.aws_subnets.database.ids

    # engine_version             = "7.1"
    # auto_minor_version_upgrade = true
    # node_type                  = "db.t4g.small"
    # num_shards                 = 1
    # num_replicas_per_shard     = 0
    # data_tiering               = false
    # tls_enabled                = true

    # parameter_group_family      = "memorydb_redis7"
    # parameter_group_parameters  = [
    #   {
    #     name  = "activedefrag"
    #     value = "yes"
    #   }
    # ]

    users = {
      admin = {
        # MODO DE CONEXION: redis-cli -h ${HOST} -p 6379 --tls --user dmc-prd-example-exusers-administrator --pass password_administrator_1234567890
        user_name     = "dmc-prd-example-exusers-administrator"
        passwords     = ["password_administrator_1234567890"]
        access_string = "on ~* &* +@all"
      }
      readonly = {
        # MODO DE CONEXION: redis-cli -h ${HOST} -p 6379 --tls --user dmc-prd-example-exusers-readonly --pass password_readonly_1234567890
        user_name     = "dmc-prd-example-exusers-readonly"
        passwords     = ["password_readonly_1234567890"]
        access_string = "on ~* &* -@all +@read"
      }
    }

    dns_records = {
      "" = {
        zone_name    = local.zone_private
        private_zone = true
      }
    }
  }
}
elasticache_defaults = var.elasticache_defaults
```
<details>
<summary>Tabla de Variables</summary>

| Variable                        | Descripción                                                                                                                                                                      | Tipo                | Default | Alternativas |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- | ------- | ------------ |
| `engine`                        | The engine that will run on your nodes. Supported values are redis and valkey                                                                                                    | `string`            | `null`  | no           |
| `engine\_version`               | Version number of the engine to be used for the cluster. Downgrades are not supported                                                                                            | `string`            | `null`  | no           |
| `auto\_minor\_version\_upgrade` | When set to `true`, the cluster will automatically receive minor engine version upgrades after launch. Defaults to `true`                                                        | `bool`              | `null`  | no           |
| `node\_type`                    | The compute and memory capacity of the nodes in the cluster. See AWS documentation on supported node types as well as vertical scaling                                           | `string`            | `null`  | no           |
| `num\_shards`                   | The number of shards in the cluster. Defaults to `1`                                                                                                                             | `number`            | `null`  | no           |
| `num\_replicas\_per\_shard`     | The number of replicas to apply to each shard, up to a maximum of 5. Defaults to `1` (i.e. 2 nodes per shard)                                                                    | `number`            | `null`  | no           |
| `data\_tiering`                 | Must be set to `true` when using a data tiering node type                                                                                                                        | `bool`              | `null`  | no           |
| `tls\_enabled`                  | A flag to enable in-transit encryption on the cluster. When set to `false`, the `acl_name` must be `open-access`. Defaults to `true`                                             | `bool`              | `null`  | no           |
| `security\_group\_ids`          | Set of VPC Security Group ID-s to associate with this cluster                                                                                                                    | `list(string)`      | `null`  | no           |
| `snapshot\_arns`                | List of ARN-s that uniquely identify RDB snapshot files stored in S3. The snapshot files will be used to populate the new cluster                                                | `list(string)`      | `null`  | no           |
| `maintenance\_window`           | Specifies the weekly time range during which maintenance on the cluster is performed. It is specified as a range in the format `ddd:hh24:mi-ddd:hh24:mi`                         | `string`            | `null`  | no           |
| `snapshot\_retention\_limit`    | The number of days for which MemoryDB retains automatic snapshots before deleting them. When set to `0`, automatic backups are disabled. Defaults to `0`                         | `number`            | `null`  | no           |
| `snapshot\_window`              | The daily time range (in UTC) during which MemoryDB begins taking a daily snapshot of your shard. Example: `05:00-09:00`                                                         | `string`            | `null`  | no           |
| `users`                         | A map of user definitions (maps) to be created                                                                                                                                   | `any`               | `{}`    | no           |
| `acl\_name`                     | Name of ACL to be created if `create_acl` is `true`, otherwise its the name of an existing ACL to use if `create_acl` is `false`                                                 | `string`            | `null`  | no           |
| `parameter\_group\_name`        | Name of parameter group to be created if `create_parameter_group` is `true`, otherwise its the name of an existing parameter group to use if `create_parameter_group` is `false` | `string`            | `null`  | no           |
| `parameter\_group\_description` | Description for the parameter group. Defaults to `Managed by Terraform`                                                                                                          | `string`            | `null`  | no           |
| `parameter\_group\_family`      | The engine version that the parameter group can be used with                                                                                                                     | `string`            | `null`  | no           |
| `parameter\_group\_parameters`  | A list of parameter maps to apply                                                                                                                                                | `list(map(string))` | `[]`    | no           |
| `subnet\_group\_name`           | Name of subnet group to be created if `create_subnet_group` is `true`, otherwise its the name of an existing subnet group to use if `create_subnet_group` is `false`             | `string`            | `null`  | no           |
| `subnet\_group\_description`    | Description for the subnet group. Defaults to `Managed by Terraform`                                                                                                             | `string`            | `null`  | no           |
| `subnet\_ids`                   | Set of VPC Subnet ID-s for the subnet group. At least one subnet must be provided                                                                                                | `list(string)`      | `[]`    | no           |
| `tags`                          | A map of tags to use on all resources                                                                                                                                            | `map(string)`       | `{}`    | no           |
</details>
