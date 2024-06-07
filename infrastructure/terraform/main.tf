data "vultr_ssh_key" "rtsa" {
  filter {
    name   = "name"
    values = ["RTSA"]
  }
}

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
      rtsa_ssh_key = data.vultr_ssh_key.rtsa.ssh_key
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
      cd inventory/
      envsubst < .hosts.tf_override_template.yml > hosts.tf_override.yml
      cp .vars.tf_override_source.yml vars.tf_override.yml
      cd ..
      env "ANSIBLE_INVENTORY_IGNORE=.yaml" ansible-playbook "$playbook"
      trap 'rm inventory/*.tf_override.yml' INT TERM EXIT
    EOT

    working_dir = "../ansible"
    environment = {
      os_shortname = lower(regex("\\w+", each.value.os_name))
      hostname     = self.hostname
      ip_addr      = self.main_ip
      playbook     = (
        each.key == "bastion" ?
        "setup_bastion_playbook.yaml" :
        "setup_${lower(regex("\\w+", each.value.os_name))}_playbook.yaml"
      )
      #TODO: introduce a 'os_shortname' key into var.instance_args (or assign
      #      the above expression to a local var) and normalize the naming of
      #      the Ansible playbook files; replace the expression in .tf files
    }
  }

}
