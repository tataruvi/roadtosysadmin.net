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
  for_each = local.all_dns_sshfp_rdata_set

  domain = data.vultr_dns_domain.rtsa.id
  name   = each.key
  data   = data.local_file.dns_sshfp_rdata[each.key].content
  type   = "SSHFP"
  ttl    = var.CONST.dns_record_ttl

  #TODO: a better way to order ops is needed for this chain of deps:
  #      ssh host keys -> compute sshfp rdata outside TF and save it to disk
  #      -> read same sshfp rdata from disk (during apply)-> dns sshfp rr
  depends_on = [local.all_dns_sshfp_rdata_set]
}
