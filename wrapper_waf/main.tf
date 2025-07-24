/*----------------------------------------------------------------------*/
/* WAF General Variables                                                */
/*----------------------------------------------------------------------*/
module "waf" {
  for_each = var.waf_parameters
  source   = "./modules/terraform-aws-waf-webaclv2"

  enabled     = try(each.value.scope, "REGIONAL") == "REGIONAL" && try(each.value.enabled, true) == true ? true : false
  name_prefix = "${local.common_name}-${each.key}"
  scope       = try(each.value.scope, "REGIONAL")

  create_alb_association = try(each.value.create_alb_association, false)
  alb_arn                = try(each.value.alb_arn, "")
  alb_arn_list           = try(each.value.alb_arn_list, [])

  allow_default_action = try(each.value.allow_default_action, true)
  visibility_config    = try(each.value.visibility_config, { metric_name = "${local.common_name}-${each.key}" })
  rules                = try(each.value.rules, [{ name = "disabled" }])

  # Logging
  create_logging_configuration = try(each.value.logging_enable, false)
  log_destination_configs      = try([aws_cloudwatch_log_group.this[each.key].arn], [])
  logging_filter               = try(each.value.waf_logging_filter, local.logging_filter_default)

  tags = local.common_tags
}

module "waf_secondary" {
  for_each = var.waf_parameters
  source   = "./modules/terraform-aws-waf-webaclv2"

  enabled     = try(each.value.scope, "REGIONAL") == "CLOUDFRONT" && try(each.value.enabled, true) ? true : false
  name_prefix = "${local.common_name}-${each.key}"
  scope       = try(each.value.scope, "REGIONAL")

  create_alb_association = try(each.value.create_alb_association, false)
  alb_arn                = try(each.value.alb_arn, "")
  alb_arn_list           = try(each.value.alb_arn_list, [])

  allow_default_action = try(each.value.allow_default_action, true)
  visibility_config    = try(each.value.visibility_config, { metric_name = "${local.common_name}-${each.key}" })
  rules                = try(each.value.rules, [{ name = "disabled" }])

  # Logging
  create_logging_configuration = try(each.value.logging_enable, false)
  log_destination_configs      = try([aws_cloudwatch_log_group.this[each.key].arn], [])
  logging_filter               = try(each.value.waf_logging_filter, local.logging_filter_default)

  tags = local.common_tags

  providers = {
    aws = aws.use1
  }
}


# /*----------------------------------------------------------------------*/
# /* WAF Alerts Variables                                                 */
# /*----------------------------------------------------------------------*/
# resource "aws_cloudwatch_metric_alarm" "blocked" {
#   for_each = var.waf_parameters

#   alarm_name                = "${local.common_name}-${each.key}-blocked"
#   comparison_operator       = "GreaterThanUpperThreshold"
#   evaluation_periods        = "1"
#   threshold_metric_id       = "ad1"
#   alarm_description         = "This metric monitors WAF BlockedRequests"
#   insufficient_data_actions = []
#   actions_enabled           = "true"
#   treat_missing_data        = "notBreaching"
#   # alarm_actions             = [data.aws_sns_topic.project-alerts.arn]
#   # ok_actions                = [data.aws_sns_topic.project-alerts.arn]
#   alarm_actions = [var.aws_sns_topic_alerts]
#   ok_actions    = [var.aws_sns_topic_alerts]

#   metric_query {
#     id          = "ad1"
#     expression  = "ANOMALY_DETECTION_BAND(m1, 4)"
#     label       = "BlockedRequests (Expected)"
#     return_data = "true"
#   }

#   metric_query {
#     id          = "m1"
#     return_data = "true"
#     metric {
#       metric_name = "BlockedRequests"
#       namespace   = "AWS/WAFV2"
#       period      = "900"
#       stat        = "Average"

#       dimensions = {
#         WebACL = module.waf[each.key].web_acl_name
#         Rule   = "ALL"
#         Region = local.metadata.aws_region
#       }
#     }
#   }
# }