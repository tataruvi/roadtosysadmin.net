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
  ssh_key_ids = [vultr_ssh_key.rtsa_ssh_key.id]

  firewall_group_id = (
    each.key == "bastion" ?
      local.TEMP_FIREWALL_GROUP_ID["bastion"] :
      local.TEMP_FIREWALL_GROUP_ID["webservers"]
  )

  lifecycle {
    ignore_changes        = [ssh_key_ids]
    create_before_destroy = true
  }
}

resource "vultr_ssh_key" "rtsa_ssh_key" {
  name    = "rtsa_ssh_key"
  ssh_key = file("${path.root}/files/rtsa_ssh_key.pub")

  lifecycle {
    ignore_changes  = [ssh_key]
    prevent_destroy = true
  }
}
