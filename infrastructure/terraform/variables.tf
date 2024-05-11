variable "CONST" {
  description = "A collection of values to emulate the use of constants"

  type = object({
    backups     = string
    enable_ipv6 = bool
    null_ipaddr = string
    dns_rr_ttl  = number
  })
}

variable "deployable_instances" {
  description = <<-EOT
    A set of strings corresponding to the keys of the var.instance_args map,
    used to determine which of the instances found there are to be deployed

    note: the prefix "!" is used to mark an instance as undeployable
  EOT

  type = set(string)
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
