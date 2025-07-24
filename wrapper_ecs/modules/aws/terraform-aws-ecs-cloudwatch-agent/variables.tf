/*----------------------------------------------------------------------*/
/* General | Variable Definition                                        */
/*----------------------------------------------------------------------*/

variable "create_enable" {
  description = "Set to create all resources to ecs cloudwatch agent"
  type        = bool
  default     = true
}

variable "name" {
  description = "(Required) Name"
  type        = string
}

variable "common_name_base" {
  description = "(Required) base_resource_name"
  type        = string
}

variable "common_name_project" {
  description = "(Required) base_resource_name"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "(Optional) specify custom VPC Name"
  type        = string
  default     = null
}

/*----------------------------------------------------------------------*/
/* ECS Task | Variable Definition                                       */
/*----------------------------------------------------------------------*/

variable "ecs_task_cpu" {
  description = "cpu task"
  type        = number
  default     = 512
}

variable "ecs_task_memory" {
  description = "(Required) base_resource_name"
  type        = number
  default     = 1024
}
