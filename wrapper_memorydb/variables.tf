/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}

variable "project" {
  type = string
}

/*----------------------------------------------------------------------*/
/* ALB | Variable Definition                                            */
/*----------------------------------------------------------------------*/

variable "memorydb_parameters" {
  type        = any
  description = ""
  default     = {}
}

variable "memorydb_defaults" {
  description = "Map of default values which will be used for each item."
  type        = any
  default     = {}
}
