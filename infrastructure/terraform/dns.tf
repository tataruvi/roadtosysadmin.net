resource "vultr_dns_domain" "rtsa" {
  domain = "roadtosysadmin.net"
  ip     = "45.76.82.118"
}

resource "vultr_dns_record" "www_current" {
  domain = vultr_dns_domain.rtsa.id
  name   = "www"
  data   = "45.76.82.118"
  type   = "A"

}

resource "vultr_dns_record" "bastion" {
  domain = vultr_dns_domain.rtsa.id
  name   = "bastion"
  data   = vultr_instance.host["bastion"].main_ip
  type   = "A"
  ttl    = var.CONST.dns_record_ttl
}

resource "vultr_dns_record" "www_next" {
  for_each = {
    for host, attr in vultr_instance.host : host => attr
    if host != "bastion"
  }

  domain = vultr_dns_domain.rtsa.id
  name   = "www-next"
  data   = each.value.main_ip
  type   = "A"
  ttl    = var.CONST.dns_record_ttl
}
