data "vultr_dns_domain" "rtsa" {
  domain = "roadtosysadmin.net"
}

resource "vultr_dns_record" "host" {
  for_each = toset([
    for host, attr in vultr_instance.host : host if host == "bastion"
  ])

  domain = data.vultr_dns_domain.rtsa.id
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

  domain = data.vultr_dns_domain.rtsa.id
  name   = "www-next"
  data   = each.value.main_ip
  type   = "A"
  ttl    = var.CONST.dns_record_ttl
}

resource "vultr_dns_record" "sshfp" {
  for_each = {
    for ssh_host, attr in tls_private_key.ssh_host :
    ssh_host => sha256(attr.public_key_openssh)
  }

  domain = data.vultr_dns_domain.rtsa.id
  name   = each.key
  data   = "4 2 ${each.value}"
  type   = "SSHFP"
  ttl    = var.CONST.dns_record_ttl
}
