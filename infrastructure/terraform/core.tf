resource "vultr_dns_domain" "rtsa" {
  domain  = "roadtosysadmin.net"
  dns_sec = "enabled"
}

resource "vultr_ssh_key" "rtsa" {
  name    = "RTSA"
  ssh_key = chomp(file("files/id_rtsa.pub"))
}

resource "terraform_data" "protect_core_resources" {
  depends_on = [
    vultr_dns_domain.rtsa,
    vultr_ssh_key.rtsa
  ]

  lifecycle {
    prevent_destroy = true
  }
}
