resource "vultr_dns_domain" "rtsa" {
  domain  = "roadtosysadmin.net"
  dns_sec = "enabled"
}

#TODO: move to the parent directory configuration
#      once the replacement webservers are ready
resource "vultr_dns_record" "zone_apex" {
  domain = vultr_dns_domain.rtsa.id
  name   = ""
  data   = "45.76.82.118"
  type   = "A"
}

#TODO: delete this resource when the above is true
resource "vultr_dns_record" "www_current" {
  domain = vultr_dns_domain.rtsa.id
  name   = "www"
  data   = "45.76.82.118"
  type   = "A"
}

resource "vultr_ssh_key" "rtsa" {
  name    = "RTSA"
  ssh_key = chomp(file("files/id_rtsa.pub"))
}

resource "terraform_data" "protect_core_resources" {
  depends_on = [
    vultr_dns_domain.rtsa,
    vultr_dns_record.zone_apex,
    vultr_dns_record.www_current,
    vultr_ssh_key.rtsa
  ]

  lifecycle {
    prevent_destroy = true
  }
}
