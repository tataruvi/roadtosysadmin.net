resource "vultr_instance" "bastion_host" {
  plan              = var.vultr_api_instance_args["bastion"].plan_id
  region            = var.vultr_api_instance_args["bastion"].region_id
  os_id             = var.vultr_api_instance_os["bastion"].os_id
  firewall_group_id = "4af0bd5a-4164-44b8-8a26-6f81acdfc4f5"
  hostname          = var.vultr_api_instance_args["bastion"].hostname
  label             = var.vultr_api_instance_args["bastion"].hostname
  tags              = var.vultr_api_instance_args["bastion"].tags
  backups           = "disabled"
  enable_ipv6       = false
  ssh_key_ids       = [vultr_ssh_key.rtsa_ssh_key.id]

  lifecycle {
    ignore_changes = [ssh_key_ids]
  }
}

resource "vultr_instance" "webserver01" {
  plan              = var.vultr_api_instance_args["webserver01"].plan_id
  region            = var.vultr_api_instance_args["webserver01"].region_id
  os_id             = var.vultr_api_instance_os["webserver01"].os_id
  firewall_group_id = "af3a8c3a-5e59-4988-abbd-9ebf8e0dab36"
  hostname          = var.vultr_api_instance_args["webserver01"].hostname
  label             = var.vultr_api_instance_args["webserver01"].hostname
  tags              = var.vultr_api_instance_args["webserver01"].tags
  backups           = "disabled"
  enable_ipv6       = false
  ssh_key_ids       = [vultr_ssh_key.rtsa_ssh_key.id]

  lifecycle {
    ignore_changes = [ssh_key_ids]
  }
}

resource "vultr_instance" "webserver02" {
  plan              = var.vultr_api_instance_args["webserver02"].plan_id
  region            = var.vultr_api_instance_args["webserver02"].region_id
  os_id             = var.vultr_api_instance_os["webserver02"].os_id
  firewall_group_id = "af3a8c3a-5e59-4988-abbd-9ebf8e0dab36"
  hostname          = var.vultr_api_instance_args["webserver02"].hostname
  label             = var.vultr_api_instance_args["webserver02"].hostname
  tags              = var.vultr_api_instance_args["webserver02"].tags
  backups           = "disabled"
  enable_ipv6       = false
  ssh_key_ids       = [vultr_ssh_key.rtsa_ssh_key.id]

  lifecycle {
    ignore_changes = [ssh_key_ids]
  }
}

resource "vultr_ssh_key" "rtsa_ssh_key" {
  name    = "rtsa_ssh_key"
  ssh_key = file("${path.root}/rtsa_ssh_key.txt")

  lifecycle {
    ignore_changes  = [ssh_key]
    prevent_destroy = true
  }
}
