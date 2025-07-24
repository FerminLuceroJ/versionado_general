module "memorydb" {
  for_each = var.memorydb_parameters
  source   = "terraform-aws-modules/memory-db/aws"
  version  = "2.3.0"

  # Cluster
  name        = lower("${local.common_name}-${each.key}")
  description = "MemoryDB cluster for ${local.common_name}-${each.key}"


  engine                     = try(each.value.engine, var.memorydb_defaults.engine, null)
  engine_version             = try(each.value.engine_version, var.memorydb_defaults.engine_version, "7.1")
  auto_minor_version_upgrade = try(each.value.auto_minor_version_upgrade, var.memorydb_defaults.auto_minor_version_upgrade, true)
  node_type                  = try(each.value.node_type, var.memorydb_defaults.node_type, "db.t4g.small")
  num_shards                 = try(each.value.num_shards, var.memorydb_defaults.num_shards, 1)
  num_replicas_per_shard     = try(each.value.num_replicas_per_shard, var.memorydb_defaults.num_replicas_per_shard, 0)
  data_tiering               = try(each.value.data_tiering, var.memorydb_defaults.data_tiering, false)

  tls_enabled        = try(each.value.tls_enabled, var.memorydb_defaults.tls_enabled, true)
  security_group_ids = try(each.value.security_group_ids, var.memorydb_defaults.security_group_ids, [module.security_group[each.key].security_group_id])
  maintenance_window = try(each.value.maintenance_window, var.memorydb_defaults.maintenance_window, "sun:23:00-mon:01:30")
  # sns_topic_arn            = try(each.value.sns_topic_arn, var.memorydb_defaults.sns_topic_arn, aws_sns_topic.example.arn)
  snapshot_retention_limit = try(each.value.snapshot_retention_limit, var.memorydb_defaults.snapshot_retention_limit, 7)
  snapshot_window          = try(each.value.snapshot_window, var.memorydb_defaults.snapshot_window, "05:00-09:00")

  # Users
  users = try(each.value.users, var.memorydb_defaults.users, {})

  # ACL
  acl_name = lower("${local.common_name}-${each.key}")
  # acl_tags = try(each.value.acl_tags, var.memorydb_defaults.acl_tags, { acl = "custom" })

  # Parameter group
  parameter_group_name        = lower("${local.common_name}-${each.key}")
  parameter_group_description = "MemoryDB parameter group for ${local.common_name}-${each.key}"
  parameter_group_family      = try(each.value.parameter_group_family, var.memorydb_defaults.parameter_group_family, "memorydb_redis7")
  parameter_group_parameters = try(each.value.parameter_group_parameters, var.memorydb_defaults.parameter_group_parameters, [
    {
      name  = "activedefrag"
      value = "yes"
    }
    ]
  )
  # parameter_group_tags = try(each.value.parameter_group_tags, var.memorydb_defaults.parameter_group_tags, { parameter_group = "custom" })

  # Subnet group
  subnet_group_name        = lower("${local.common_name}-${each.key}")
  subnet_group_description = "MemoryDB subnet group for ${local.common_name}-${each.key}"
  subnet_ids               = try(each.value.subnets, null)

  tags = local.common_tags
}