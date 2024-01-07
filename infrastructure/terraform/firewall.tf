resource "vultr_firewall_group" "bastion" {
  description = <<-EOT
    Firewall group for the bastion, meant to:
    - open SSH port to any
    - allow ICMP from any
  EOT
}

resource "vultr_firewall_rule" "bastion_allow_ssh" {
  firewall_group_id = vultr_firewall_group.bastion.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "22"
  notes             = "pf: pass in inet proto tcp port 22 from any"
}

resource "vultr_firewall_rule" "bastion_allow_icmp" {
  firewall_group_id = vultr_firewall_group.bastion.id
  protocol          = "icmp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  notes             = "pf: pass in inet proto icmp from any"
}

resource "vultr_firewall_group" "webservers" {
  description = <<-EOT
    Firewall group for the webservers, meant to:
    - open HTTP and HTTPS ports to any
    - open SSH port to <bastion>
    - allow ICMP from any
  EOT
}

resource "vultr_firewall_rule" "webservers_restrict_ssh" {
  firewall_group_id = vultr_firewall_group.webservers.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = vultr_instance.host["bastion"].main_ip
  subnet_size       = 32
  port              = "22"
  notes             = "pf: pass in inet proto tcp port 22 from <bastion>"
}

resource "vultr_firewall_rule" "webservers_allow_http" {
  firewall_group_id = vultr_firewall_group.webservers.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "80"
  notes             = "pf: pass in inet proto tcp port 80 from any"
}

resource "vultr_firewall_rule" "webservers_allow_https" {
  firewall_group_id = vultr_firewall_group.webservers.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "443"
  notes             = "pf: pass in inet proto tcp port 443 from any"
}

resource "vultr_firewall_rule" "webservers_allow_icmp" {
  firewall_group_id = vultr_firewall_group.webservers.id
  protocol          = "icmp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  notes             = "pf: pass in inet proto icmp from any"
}
