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

resource "tls_private_key" "ssh_host" {
  for_each = toset([
    for instance, args in var.instance_args : instance
    if contains(var.deployable_instances, instance)
  ])

  algorithm = "ED25519"
}

resource "vultr_startup_script" "host" {
  for_each = toset([
    for ssh_host, attr in tls_private_key.ssh_host : "bastion"
    if ssh_host == "bastion"
  ])

  name = "bastion_host_initial_setup"
  type = "boot"

  script = base64encode(
    templatefile(
      "templates/firstboot.exec.tftpl",
      {
        rtsa_ssh_key = data.vultr_ssh_key.rtsa.ssh_key
        ssh_host_key = tls_private_key.ssh_host["bastion"].private_key_openssh
        ssh_host_pub = tls_private_key.ssh_host["bastion"].public_key_openssh
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
    vultr_startup_script.host["bastion"].id :
    null
  )

  # potential alternative approach to the cloud-init user_data:
  # https://registry.terraform.io/providers/hashicorp/cloudinit/latest
  user_data = (
    each.key == "bastion" ?
    null :
    sensitive(templatefile(
      "templates/user_data.yaml.tftpl",
      {
        distro = (
          lower(regex("\\w+", each.value.os_name)) == "debian" ?
          { "pkg_manager" = "apt", "sudoers_group" = "sudo" } :
          { "pkg_manager" = "dnf", "sudoers_group" = "wheel" }
        )
        rtsa_ssh_key = data.vultr_ssh_key.rtsa.ssh_key
        ssh_host_key = tls_private_key.ssh_host[each.key].private_key_openssh
        ssh_host_pub = tls_private_key.ssh_host[each.key].public_key_openssh
      }
    ))
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}
