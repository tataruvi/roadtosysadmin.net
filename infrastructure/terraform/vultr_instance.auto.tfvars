vultr_api_instance_os = {
  bastion = {
    os_id      = 2187
    os_name    = "OpenBSD"
    os_version = "7.4 x64"
  }
  webserver01 = {
    os_id      = 2136
    os_name    = "Debian"
    os_version = "12 x64 (Bookworm)"
  }
  webserver02 = {
    os_id      = 1869
    os_name    = "Rocky Linux"
    os_version = "9 x64"
  }
}

vultr_api_instance_args = {
  bastion = {
    plan_id     = "vc2-1c-0.5gb"
    region_id   = "ewr"
    region_name = "New Jersey"
    hostname    = "bastion"
    tags        = ["bastion_host", "jump_host"]
  }
  webserver01 = {
    plan_id     = "vhp-1c-1gb-amd"
    region_id   = "lhr"
    region_name = "London"
    hostname    = "webserver01"
    tags        = ["webserver", "www"]
  }
  webserver02 = {
    plan_id     = "vhp-1c-1gb-amd"
    region_id   = "icn"
    region_name = "Seoul"
    hostname    = "webserver02"
    tags        = ["webserver", "www"]
  }
}
