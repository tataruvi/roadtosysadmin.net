resource "vultr_dns_record" "host" {
  for_each = local.deployed_hosts.all

  domain = vultr_dns_domain.rtsa.id
  name   = each.key
  data   = vultr_instance.host[each.key].main_ip
  type   = "A"
  ttl    = var.CONST.dns_rr_ttl
}

resource "vultr_dns_record" "zone_apex" {
  for_each = local.active_webservers

  domain = vultr_dns_domain.rtsa.id
  name   = ""
  data   = vultr_instance.host[each.key].main_ip
  type   = "A"
  ttl    = var.CONST.dns_rr_ttl
}

resource "vultr_dns_record" "www" {
  for_each = local.active_webservers

  domain = vultr_dns_domain.rtsa.id
  name   = "www"
  data   = vultr_instance.host[each.key].main_ip
  type   = "A"
  ttl    = var.CONST.dns_rr_ttl
}

resource "vultr_dns_record" "sshfp" {
  for_each = local.ssh_host_keys.all

  domain = vultr_dns_domain.rtsa.id
  name   = each.key
  data   = data.local_file.sshfp_rdata[each.key].content
  type   = "SSHFP"
  ttl    = var.CONST.dns_rr_ttl
}
