CONST = {
  backups        = "disabled"
  enable_ipv6    = false
  null_ipaddr    = "169.254.254.169"
  dns_record_ttl = 600
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
    os_id       = 2187
    os_name     = "OpenBSD 7.4"
    tags        = ["ssh", "icmp"]
  }
  webserver01 = {
    plan_id     = "vhp-1c-1gb-amd"
    region_id   = "ams"
    region_name = "Amsterdam"
    os_id       = 2136
    os_name     = "Debian 12"
    tags        = ["http", "https", "icmp"]
  }
  webserver02 = {
    plan_id     = "vhp-1c-1gb-amd"
    region_id   = "sgp"
    region_name = "Singapore"
    os_id       = 1869
    os_name     = "Rocky Linux 9"
    tags        = ["http", "https", "icmp"]
  }
}
