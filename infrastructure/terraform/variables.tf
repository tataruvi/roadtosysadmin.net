variable "vultr_api_instance_os" {
  description = "Controls the OS of the various instances; also maps Vultr API's <os_id> arg to meaningful data"

  type = map(object({
    os_id      = number
    os_name    = optional(string)
    os_version = optional(string)
  }))

  default = {
    bastion = {
      os_id      = 2187
      os_name    = "OpenBSD"
      os_version = "7.4 x64"
    }
    webserver01 = {
      os_id      = 2136
      os_name    = "Debian"
      os_version = "12 x64 (Bookworm)"
    }
    webserver02 = {
      os_id      = 1869
      os_name    = "Rocky Linux"
      os_version = "9 x64"
    }
  }
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

  default = {
    bastion = {
      plan_id     = "vc2-1c-0.5gb"
      region_id   = "ewr"
      region_name = "New Jersey"
      hostname    = "bastion"
      tags        = ["bastion_host", "jump_host"]
    }
    webserver01 = {
      plan_id     = "vhp-1c-1gb-amd"
      region_id   = "lhr"
      region_name = "London"
      hostname    = "webserver01"
      tags        = ["webserver", "www"]
    }
    webserver02 = {
      plan_id     = "vhp-1c-1gb-amd"
      region_id   = "icn"
      region_name = "Seoul"
      hostname    = "webserver02"
      tags        = ["webserver", "www"]
    }
  }
}
