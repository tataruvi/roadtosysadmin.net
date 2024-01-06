locals {
  # emulate constant values
  BACKUPS     = "disabled"
  ENABLE_IPV6 = false
}

variable "vultr_api_instance_os" {
  description = "Controls the OS of the various instances; also maps Vultr API's <os_id> arg to meaningful data"

  type = map(object({
    os_id      = number
    os_name    = optional(string)
    os_version = optional(string)
  }))
}

variable "vultr_api_instance_args" {
  description = "Provides the rest of the args (required or optional, but desired) used when creating an instance; also maps the API's <region> arg to a meaningful name"

  type = map(object({
    plan_id     = string
    region_id   = string
    region_name = optional(string)
    hostname    = string
    tags        = list(string)
  }))
}
