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

resource "vultr_ssh_key" "rtsa_ssh_key" {
  name    = "rtsa-ssh-key"
  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+ao9nJS+22c0N4jYNxL+We5DAfOQcLKlymp4FJ4+v1XfztfoqdY6U7ufl4U6vMROmqJUS6RCNqrAh3Iqi7LZlBok8RiwK//IQWKv8gqjoiHP5Cocoy0Qqhd77rAU3ncOn09Fzj9RD9UGaQpxmfZk+0/6euyCQeGGYNpKNE9bj5SuOF+VFzfOIpgk4Zhy0dbnJ7G//WPWS0ecaqWb1KsgnAUuKzpjX0l9ta+/gr0uvg9W19T4CRocDdrEDeZULPkowoifXQ5G0bGEfb8o74JVwx0GdQk4dhqRZ7/ovIAhUCzJqabccPqdfzXyfC5dDIxRUEeXqmx852ezH34JJFlwCfbVUYNdGWYL4fgQK/L0KQfEO4kRaZV9JGmT4F8Peyns7YcdHCouuyB5hDW+qg9lhPQoFsSkD3WMkzAj2moea4L9UijcviigZWfYZ/4KIlg9krkYQ995SKG86ACNr7VpVOOEw05g1jJvlHYLZsXDV6iu6/96m585kcsmVoxkgYxkS4XSKIcJ8kggxcAW56z2laqsKmsIIzoF+Q/ILYm+zM9HxEHA4F57fi7Uu29PozbUPBYFs4NIYiuBD712euro6sSuhMiAmLBQ6QYx6zMsAEJnWgSXRN2DX4bmAwGhCkDSRr426CSMWRBKK+7ZhakQtGlGUCJkBUZi1sgQhNfTlOQ== RTSA"

}
