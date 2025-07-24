module "wrapper_waf" {
  source = "../../"

  providers = {
    aws.use1 = aws.use1
  }

  metadata = local.metadata

  waf_parameters = {
    "exSimple" = {
      logging_enable = false
      # logging_filter    = {} # Log All events (default only COUNT & BLOCK)
      # logging_retention = # Default 7 days
      rules = [
        {
          name            = "AWSManagedRulesCommonRuleSet-rule-1"
          priority        = "10"
          override_action = "none"
          visibility_config = {
            metric_name = "AWSManagedRulesCommonRuleSet-metric"
          }
          managed_rule_group_statement = {
            name        = "AWSManagedRulesCommonRuleSet" //WCU 700
            vendor_name = "AWS"
          }
        }
      ]
    }
    "exCloudfront" = {
      scope                = "CLOUDFRONT"
      logging_enable       = false
      allow_default_action = false
      rules = [
        {
          name     = "AWSCloudfrontIPWhitelist-rule-1"
          priority = "1"
          action   = "allow"
          visibility_config = {
            cloudwatch_metrics_enabled = true
            metric_name                = "AWSCloudfrontIPWhitelist-metric"
            sample_requests_enabled    = false
          }
          ip_set_reference_statement = {
            arn = aws_wafv2_ip_set.cloudfront_ip_whitelist.arn
          }
        }
      ]
    }
    # "exLogs" = {

    # }
  }

  waf_defaults = var.waf_defaults
}

resource "aws_wafv2_ip_set" "cloudfront_ip_whitelist" {
  provider = aws.use1

  name = "test-cloudfront-ip-whitelist"

  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"

  # list of ips
  addresses = ["10.0.10.100/32"]
}