resource "vultr_instance" "bastion_host" {
  os_id             = var.instance_args["bastion"].os_id
  plan              = var.instance_args["bastion"].plan_id
  region            = var.instance_args["bastion"].region_id
  hostname          = var.instance_args["bastion"].hostname
  label             = var.instance_args["bastion"].hostname
  tags              = var.instance_args["bastion"].tags
  backups           = local.BACKUPS
  enable_ipv6       = local.ENABLE_IPV6
  firewall_group_id = "4af0bd5a-4164-44b8-8a26-6f81acdfc4f5"
  ssh_key_ids       = [vultr_ssh_key.rtsa_ssh_key.id]

  lifecycle {
    ignore_changes        = [ssh_key_ids]
    create_before_destroy = true
  }
}

resource "vultr_instance" "webserver01" {
  os_id             = var.instance_args["webserver01"].os_id
  plan              = var.instance_args["webserver01"].plan_id
  region            = var.instance_args["webserver01"].region_id
  hostname          = var.instance_args["webserver01"].hostname
  label             = var.instance_args["webserver01"].hostname
  tags              = var.instance_args["webserver01"].tags
  backups           = local.BACKUPS
  enable_ipv6       = local.ENABLE_IPV6
  firewall_group_id = "af3a8c3a-5e59-4988-abbd-9ebf8e0dab36"
  ssh_key_ids       = [vultr_ssh_key.rtsa_ssh_key.id]

  lifecycle {
    ignore_changes        = [ssh_key_ids]
    create_before_destroy = true
  }
}

resource "vultr_instance" "webserver02" {
  os_id             = var.instance_args["webserver02"].os_id
  plan              = var.instance_args["webserver02"].plan_id
  region            = var.instance_args["webserver02"].region_id
  hostname          = var.instance_args["webserver02"].hostname
  label             = var.instance_args["webserver02"].hostname
  tags              = var.instance_args["webserver02"].tags
  backups           = local.BACKUPS
  enable_ipv6       = local.ENABLE_IPV6
  firewall_group_id = "af3a8c3a-5e59-4988-abbd-9ebf8e0dab36"
  ssh_key_ids       = [vultr_ssh_key.rtsa_ssh_key.id]

  lifecycle {
    ignore_changes        = [ssh_key_ids]
    create_before_destroy = true
  }
}

resource "vultr_ssh_key" "rtsa_ssh_key" {
  name    = "rtsa_ssh_key"
  ssh_key = file("${path.root}/files/rtsa_ssh_key.pub")

  lifecycle {
    ignore_changes  = [ssh_key]
    prevent_destroy = true
  }
}
