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
  for_each = local.webserver_hosts_set

  domain = data.vultr_dns_domain.rtsa.id
  name   = "www-next"
  data   = vultr_instance.host[each.key].main_ip
  type   = "A"
  ttl    = var.CONST.dns_record_ttl
}

resource "vultr_dns_record" "sshfp" {
  for_each = local.all_ssh_hosts_set

  domain = data.vultr_dns_domain.rtsa.id
  name   = each.key
  data   = format("4 2 %s", file("files/${each.key}_pubkey.sshfp"))
  type   = "SSHFP"
  ttl    = var.CONST.dns_record_ttl

  lifecycle {
    ignore_changes = [data]
  }
}
