/*----------------------------------------------------------------------*/
/* MemoryDB Variables                                                   */
/*----------------------------------------------------------------------*/
data "aws_route53_zone" "memorydb" {
  for_each = local.memorydb_route53

  zone_id      = lookup(each.value, "zone_id", null)
  name         = lookup(each.value, "zone_name", null)
  private_zone = lookup(each.value, "private_zone", false)
}

resource "aws_route53_record" "memorydb" {
  for_each = local.memorydb_route53

  zone_id         = data.aws_route53_zone.memorydb[each.key].zone_id
  name            = lookup(each.value, "record_name")
  allow_overwrite = false
  type            = "CNAME"
  ttl             = lookup(each.value, "ttl")
  records         = [lookup(each.value, "records")]
}

locals {
  memorydb_route53_tmp = [for resource_name, value1 in var.memorydb_parameters :
    {
      for dns_record_name, value2 in value1.dns_records :
      "${resource_name}-${dns_record_name}" =>
      {
        "name"         = resource_name
        "record_name"  = length(dns_record_name) > 0 ? dns_record_name : "${local.common_name}-${resource_name}.memorydb"
        "zone_name"    = value2.zone_name
        "private_zone" = value2.private_zone
        "ttl"          = lookup(value2, "ttl", 300)
        "records"      = module.memorydb[resource_name].cluster_endpoint_address
      }
    }
    if lookup(value1, "dns_records", null) != null
  ]
  memorydb_route53 = merge(local.memorydb_route53_tmp...)
}