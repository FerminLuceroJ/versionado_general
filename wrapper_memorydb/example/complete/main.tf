module "wrapper_memorydb" {
  source = "../../"

  metadata = local.metadata
  project  = "example"

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
}