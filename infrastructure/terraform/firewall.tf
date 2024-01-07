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
  subnet            = vultr_instance.host["bastion"].main_ip
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
