resource "vultr_instance" "bastion_host" {
  plan              = "vc2-1c-0.5gb"
  region            = "ewr"
  os_id             = 2187 #OpenBSD 7.4 x64
  firewall_group_id = "4af0bd5a-4164-44b8-8a26-6f81acdfc4f5"
  label             = "bastion"
  hostname          = "bastion"
  tags              = ["bastion_host", "jump_host"]
  backups           = "disabled"
  enable_ipv6       = false
  ssh_key_ids       = [vultr_ssh_key.rtsa_ssh_key.id]

  lifecycle {
    ignore_changes = [ssh_key_ids]
  }
}

resource "vultr_ssh_key" "rtsa_ssh_key" {
  name    = "rtsa_ssh_key"
  ssh_key = file("${path.root}/rtsa_ssh_key.txt")

  lifecycle {
    ignore_changes  = [ssh_key]
    prevent_destroy = true
  }
}
