CONST = {
  backups     = "disabled"
  enable_ipv6 = false
  null_ipaddr = "169.254.254.169"
  dns_rr_ttl  = 600
}

deployable_instances = [
  "bastion",
  "webserver01",
  "webserver02"
]

instance_args = {
  bastion = {
    plan_id     = "vc2-1c-0.5gb"
    region_id   = "ewr"
    region_name = "New Jersey"
    os_id       = 2286
    os_name     = "OpenBSD 7.5"
    tags        = ["ssh", "icmp"]
  }
  webserver01 = {
    plan_id     = "vhp-1c-1gb-amd"
    region_id   = "ams"
    region_name = "Amsterdam"
    os_id       = 2136
    os_name     = "Debian 12"
    tags        = ["http", "https", "icmp"]
    serves_http = true
  }
  webserver02 = {
    plan_id     = "vhp-1c-1gb-amd"
    region_id   = "fra"
    region_name = "Frankfurt"
    os_id       = 1869
    os_name     = "Rocky Linux 9"
    tags        = ["http", "https", "icmp"]
    serves_http = true
  }
}
