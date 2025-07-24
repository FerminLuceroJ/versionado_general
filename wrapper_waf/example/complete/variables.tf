/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

# variable "metadata" {
#   type = any
# }

# variable "project" {
#   type = string
# }

/*----------------------------------------------------------------------*/
/* RDS | Variable Definition                                            */
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