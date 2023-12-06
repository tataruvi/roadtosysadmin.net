resource "vultr_instance" "bastion_host" {
  plan              = "vc2-1c-0.5gb"
  region            = "ams"
  os_id             = 324
  firewall_group_id = "4af0bd5a-4164-44b8-8a26-6f81acdfc4f5"
  label             = "bastion"
  hostname          = "ssh"
  tags              = ["bastion_host", "jump_host"]
  backups           = "disabled"
}
