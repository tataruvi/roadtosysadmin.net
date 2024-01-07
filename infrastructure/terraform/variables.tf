locals {
  # emulate constant values
  BACKUPS     = "disabled"
  ENABLE_IPV6 = false

  TEMP_FIREWALL_GROUP_ID = {
    bastion    = "4af0bd5a-4164-44b8-8a26-6f81acdfc4f5"
    webservers = "af3a8c3a-5e59-4988-abbd-9ebf8e0dab36"
  }
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
