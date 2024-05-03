locals {
  # TODO: dismantle this approach once the CM code is done
  TEMP_FIREWALL_GROUP_ID = {
    bastion    = "4af0bd5a-4164-44b8-8a26-6f81acdfc4f5"
    webservers = "af3a8c3a-5e59-4988-abbd-9ebf8e0dab36"
  }
}

data "vultr_ssh_key" "rtsa" {
  filter {
    name   = "name"
    values = ["RTSA"]
  }
}

resource "vultr_startup_script" "bastion" {
  name   = "bootstrap_openbsd_for_ansible"
  type   = "boot"
  script = base64encode(
    templatefile(
      "templates/firstboot.exec.tftpl",
      {
        rtsa_ssh_key = data.vultr_ssh_key.rtsa.ssh_key
      }
    )
  )
}

#TODO: consider using custom conditions or checks to verify that
#      the hosts are operational before 'terraform apply' is done
resource "vultr_instance" "host" {
  for_each = {
    for instance, args in var.instance_args : instance => args
    if contains(var.deployable_instances, instance)
  }

  os_id       = each.value.os_id
  plan        = each.value.plan_id
  region      = each.value.region_id
  hostname    = each.key
  label       = each.key
  tags        = each.value.tags
  backups     = var.CONST.backups
  enable_ipv6 = var.CONST.enable_ipv6
  ssh_key_ids = [data.vultr_ssh_key.rtsa.id]

  firewall_group_id = (
    each.key == "bastion" ?
    local.TEMP_FIREWALL_GROUP_ID["bastion"] :
    local.TEMP_FIREWALL_GROUP_ID["webservers"]
  )

  script_id = (
    each.key == "bastion" ?
    vultr_startup_script.bastion.id :
    null
  )

  user_data = (
    each.key == "bastion" ?
    null :
    file("files/user_data.yaml")
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}
