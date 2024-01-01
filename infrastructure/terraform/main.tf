resource "vultr_instance" "bastion_host" {
  os_id             = var.vultr_api_instance_os["bastion"].os_id
  plan              = var.vultr_api_instance_args["bastion"].plan_id
  region            = var.vultr_api_instance_args["bastion"].region_id
  hostname          = var.vultr_api_instance_args["bastion"].hostname
  label             = var.vultr_api_instance_args["bastion"].hostname
  tags              = var.vultr_api_instance_args["bastion"].tags
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
  os_id             = var.vultr_api_instance_os["webserver01"].os_id
  plan              = var.vultr_api_instance_args["webserver01"].plan_id
  region            = var.vultr_api_instance_args["webserver01"].region_id
  hostname          = var.vultr_api_instance_args["webserver01"].hostname
  label             = var.vultr_api_instance_args["webserver01"].hostname
  tags              = var.vultr_api_instance_args["webserver01"].tags
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
  os_id             = var.vultr_api_instance_os["webserver02"].os_id
  plan              = var.vultr_api_instance_args["webserver02"].plan_id
  region            = var.vultr_api_instance_args["webserver02"].region_id
  hostname          = var.vultr_api_instance_args["webserver02"].hostname
  label             = var.vultr_api_instance_args["webserver02"].hostname
  tags              = var.vultr_api_instance_args["webserver02"].tags
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

resource "vultr_firewall_group" "bastion_host_fwgrp" {
  description = "Firewall group for the bastion host, will fully open port 22/TCP and allow ICMP"
}

resource "vultr_firewall_rule" "bastion_host_allow_ssh" {
  firewall_group_id = vultr_firewall_group.bastion_host_fwgrp.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "22"
  notes             = "Open port 22/TCP to the Internet"
}

resource "vultr_firewall_rule" "bastion_host_allow_icmp" {
  firewall_group_id = vultr_firewall_group.bastion_host_fwgrp.id
  protocol          = "icmp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  notes             = "Allow ICMP messages from anywhere"
}

resource "vultr_firewall_group" "webservers_fwgrp" {
  description = "Firewall group for the webservers, will fully open ports [80,443]/TCP, open port 22/TCP for the bastion host only and allow ICMP"
}

resource "vultr_firewall_rule" "webservers_restrict_ssh" {
  firewall_group_id = vultr_firewall_group.webservers_fwgrp.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = vultr_instance.bastion_host.main_ip
  subnet_size       = 32
  port              = "22"
  notes             = "Open port 22/TCP only for the bastion host"
}

resource "vultr_firewall_rule" "webservers_allow_http" {
  firewall_group_id = vultr_firewall_group.webservers_fwgrp.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "80"
  notes             = "Open port 80/TCP to the Internet"
}

resource "vultr_firewall_rule" "webservers_allow_https" {
  firewall_group_id = vultr_firewall_group.webservers_fwgrp.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "443"
  notes             = "Open port 443/TCP to the Internet"
}

resource "vultr_firewall_rule" "webservers_allow_icmp" {
  firewall_group_id = vultr_firewall_group.webservers_fwgrp.id
  protocol          = "icmp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  notes             = "Allow ICMP messages from anywhere"
}
