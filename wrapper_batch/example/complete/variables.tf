/*----------------------------------------------------------------------*/
/* Batch | Variable Definition                                          */
/*----------------------------------------------------------------------*/

variable "batch_parameters" {
  type        = any
  description = ""
  default     = {}
}

variable "batch_defaults" {
  description = "Map of default values which will be used for each item."
  type        = any
  default     = {}
}