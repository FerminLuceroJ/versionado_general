/*----------------------------------------------------------------------*/
/* WAF Logging Variables                                                */
/*----------------------------------------------------------------------*/
locals {
  waf_logging = {
    for key, value in var.waf_parameters :
    key => value
    if try(value.logging_enable, false) != false
  }
}

resource "aws_cloudwatch_log_group" "this" {
  for_each = local.waf_logging
  name     = "aws-waf-logs-${local.common_name}-${each.key}"

  retention_in_days = try(each.value.logging_retention, 7)

  tags = local.common_tags
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  for_each        = local.waf_logging
  policy_document = data.aws_iam_policy_document.this[each.key].json
  policy_name     = "${local.common_name}-${each.key}"
}

data "aws_iam_policy_document" "this" {
  for_each = local.waf_logging
  version  = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.this[each.key].arn}:*"]
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}