# TODO: move the local values out of variables.tf

locals {
  # emulate constant values
  BACKUPS     = "disabled"
  ENABLE_IPV6 = false

  TEMP_FIREWALL_GROUP_ID = {
    bastion    = "4af0bd5a-4164-44b8-8a26-6f81acdfc4f5"
    webservers = "af3a8c3a-5e59-4988-abbd-9ebf8e0dab36"
  }

  # generate a dynamic map of hosts' IP addresses based on deployment status
  os_shortname = {
    for instance, args in var.instance_args :
    instance => lower(regex("\\w+", args.os_name))
  }

  NULL_IPADDR = "169.254.254.169" # "null" in respect to routing
  ansible_hosts_ipaddr = {
    for instance, args in var.instance_args :
    local.os_shortname[instance] => (
      contains(var.deployable_instances, instance) ?
      vultr_instance.host[instance].main_ip :
      local.NULL_IPADDR
    )
  }

  bastion_ipaddr = local.ansible_hosts_ipaddr[local.os_shortname["bastion"]]
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
