resource "vultr_ssh_key" "rtsa" {
  name    = "RTSA"
  ssh_key = trimspace(file("files/id_rtsa.pub"))

  lifecycle {
    prevent_destroy = true
  }
}

resource "vultr_instance" "host" {
  for_each = var.instance_args

  os_id       = each.value.os_id
  plan        = each.value.plan_id
  region      = each.value.region_id
  hostname    = each.key
  label       = each.key
  tags        = each.value.tags
  backups     = local.BACKUPS
  enable_ipv6 = local.ENABLE_IPV6
  ssh_key_ids = [vultr_ssh_key.rtsa.id]

  firewall_group_id = (
    each.key == "bastion" ?
    local.TEMP_FIREWALL_GROUP_ID["bastion"] :
    local.TEMP_FIREWALL_GROUP_ID["webservers"]
  )

  lifecycle {
    create_before_destroy = true
  }
}
