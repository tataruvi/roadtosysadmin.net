locals {
  # emulate constant values
  BACKUPS     = "disabled"
  ENABLE_IPV6 = false
}

variable "instance_args" {
  description = <<-EOT
    Arguments used by vultr_instance resources; the optional values are used
    used to map Vultr API specific values to human-readable names
  EOT

  type = map(object({
    plan_id     = string
    region_id   = string
    region_name = optional(string)
    os_id       = number
    os_name     = optional(string)
    tags        = list(string)
  }))
}
