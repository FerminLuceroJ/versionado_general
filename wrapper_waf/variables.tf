/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}

/*----------------------------------------------------------------------*/
/* SES | Variable Definition                                            */
/*----------------------------------------------------------------------*/
variable "waf_parameters" {
  type        = any
  description = "WAF parameteres to configure WAF module"
  default     = {}
}

variable "waf_defaults" {
  type        = any
  description = "WAF defaults parameteres to configure WAF module"
  default     = {}
}

# Temporal
variable "aws_sns_topic_alerts" {
  description = ""
  type        = string
  default     = ""
}
