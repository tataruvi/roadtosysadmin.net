data "vultr_dns_domain" "rtsa" {
  domain = "roadtosysadmin.net"
}

resource "vultr_dns_record" "host" {
  for_each = local.deployed_hosts.bastion

  domain = data.vultr_dns_domain.rtsa.id
  name   = "bastion"
  data   = vultr_instance.host["bastion"].main_ip
  type   = "A"
  ttl    = var.CONST.dns_record_ttl
}

resource "vultr_dns_record" "www_next" {
  for_each = local.deployed_hosts.webservers

  domain = data.vultr_dns_domain.rtsa.id
  name   = "www-next"
  data   = vultr_instance.host[each.key].main_ip
  type   = "A"
  ttl    = var.CONST.dns_record_ttl
}

resource "vultr_dns_record" "sshfp" {
  for_each = local.ssh_host_keys.all

  domain = data.vultr_dns_domain.rtsa.id
  name   = each.key
  data   = data.local_file.sshfp_rdata[each.key].content
  type   = "SSHFP"
  ttl    = var.CONST.dns_record_ttl
}
