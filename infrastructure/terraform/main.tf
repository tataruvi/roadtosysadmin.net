resource "tls_private_key" "ssh_host" {
  for_each = local.deployable_instances

  algorithm = "ED25519"
}

resource "vultr_startup_script" "host" {
  for_each = local.ssh_host_keys.bastion

  name = "bastion_host_initial_setup"
  type = "boot"

  script = sensitive(base64encode(templatefile(
    "templates/firstboot.exec.tftpl",
    {
      rtsa_ssh_key = vultr_ssh_key.rtsa.ssh_key
      ssh_host_key = tls_private_key.ssh_host["bastion"].private_key_openssh
      ssh_host_pub = tls_private_key.ssh_host["bastion"].public_key_openssh
    }
  )))
}

resource "vultr_instance" "host" {
  for_each = local.deployable_instances

  os_id       = each.value.os_id
  plan        = each.value.plan_id
  region      = each.value.region_id
  hostname    = each.key
  label       = each.key
  tags        = each.value.tags
  backups     = var.CONST.backups
  enable_ipv6 = var.CONST.enable_ipv6

  firewall_group_id = (
    each.key == "bastion" ?
    vultr_firewall_group.bastion.id :
    vultr_firewall_group.webservers.id
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
          local.os_shortname[each.key] == "debian" ?
          { "pkg_manager" = "apt", "sudoers_group" = "sudo" } :
          { "pkg_manager" = "dnf", "sudoers_group" = "wheel" }
        )
        rtsa_ssh_key = vultr_ssh_key.rtsa.ssh_key
        ssh_host_key = tls_private_key.ssh_host[each.key].private_key_openssh
        ssh_host_pub = tls_private_key.ssh_host[each.key].public_key_openssh
      }
    ))
  )

  provisioner "remote-exec" {
    inline = ["true"]

    connection {
      type     = "ssh"
      user     = "cm_user"
      timeout  = "10m"
      host     = self.main_ip

      bastion_user = "cm_user"
      bastion_host = (
        each.key == "bastion" ?
        "" :
        "bastion.roadtosysadmin.net"
      )
    }
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd ./inventory/
      envsubst < .deploy_host.yml.tftpl > deploy_host.yml
      cd ..
      ansible-playbook --limit "$hostname" "$playbook"
      trap 'rm ./inventory/deploy_host.yml' INT TERM EXIT
    EOT

    working_dir = "../ansible"
    environment = {
      os_shortname = local.os_shortname[each.key]
      hostname     = "deploy_${replace(self.hostname, "/\\d{2}$/", "")}"
      ip_addr      = self.main_ip
      playbook     = "setup_${local.os_shortname[each.key]}_playbook.yaml"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}
