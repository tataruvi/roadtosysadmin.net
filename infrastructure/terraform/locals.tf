locals {
  deployable_instances_map = {
      for instance, args in var.instance_args : instance => args
      if contains(var.deployable_instances, instance)
    }
  deployable_instances_set = toset(keys(local.deployable_instances_map))

  webserver_hosts_map = {
    for host, attr in vultr_instance.host : host => attr if host != "bastion"
  }
  bastion_host_set = toset([
    for host, attr in vultr_instance.host : host if host == "bastion"
  ])
  bastion_ssh_host_set = toset([
    for ssh_host, attr in tls_private_key.ssh_host : ssh_host
    if ssh_host == "bastion"
  ])
  all_ssh_hosts_sshfp_map = {
    for ssh_host, attr in tls_private_key.ssh_host :
    ssh_host => sha256(attr.public_key_openssh)
  }
  all_ssh_hosts_set = toset(keys(tls_private_key.ssh_host))
}
