locals {
  deployable_instances_map = {
    for instance, args in var.instance_args : instance => args
    if contains(var.deployable_instances, instance)
  }
  deployable_instances_set = toset(keys(local.deployable_instances_map))

  # helper constant sets
  bastion_set = toset(["bastion"])
  empty_set   = toset([])
  ###

  all_hosts_set    = toset(keys(vultr_instance.host))
  bastion_host_set = setintersection(
    local.all_hosts_set,
    local.bastion_set
  )
  webserver_hosts_set = setsubtract(
    local.all_hosts_set,
    local.bastion_host_set
  )

  all_ssh_hosts_set    = toset(keys(tls_private_key.ssh_host))
  bastion_ssh_host_set = setintersection(
    local.all_ssh_hosts_set,
    local.bastion_set
  )
}
