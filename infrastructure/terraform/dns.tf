data "vultr_dns_domain" "rtsa" {
  domain = "roadtosysadmin.net"
}

resource "vultr_dns_record" "host" {
  for_each = local.bastion_host_set

  domain = data.vultr_dns_domain.rtsa.id
  name   = "bastion"
  data   = vultr_instance.host["bastion"].main_ip
  type   = "A"
  ttl    = var.CONST.dns_record_ttl
}

resource "vultr_dns_record" "www_next" {
  for_each = local.webserver_hosts_map

  domain = data.vultr_dns_domain.rtsa.id
  name   = "www-next"
  data   = each.value.main_ip
  type   = "A"
  ttl    = var.CONST.dns_record_ttl
}

resource "vultr_dns_record" "sshfp" {
  for_each = local.all_ssh_hosts_sshfp_map

  domain = data.vultr_dns_domain.rtsa.id
  name   = each.key
  data   = "4 2 ${each.value}"
  type   = "SSHFP"
  ttl    = var.CONST.dns_record_ttl
}
