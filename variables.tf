variable "project_region" {
  description = "The default region"
  type        = string
}

variable "pipeline_name" {
  description = "The name of the cloud deploy pipeline"
  type        = string
}

variable "target_prefix" {
  description = "The prefix for the cloud deploy targets"
  type        = string
}

variable "development_targets" {
  description = "The development targets"
  type = list(object({
    project_id : string
    region : string
    deploy_parameters : map(any)
  }))
}

variable "production_targets" {
  description = "The production targets"
  type = list(object({
    project_id : string
    region : string
    deploy_parameters : map(any)
  }))
}
