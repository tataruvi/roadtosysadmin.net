locals {
  # helper sets, not to be used outside of locals.tf
  bastion_literal    = toset(["bastion"])
  all_deployed_hosts = toset(keys(vultr_instance.host))
  all_ssh_host_keys  = toset(keys(tls_private_key.ssh_host))
  ##

  deployable_instances = {
    for instance, args in var.instance_args : instance => args
    if contains(var.deployable_instances, instance)
  }

  deployed_hosts = {
    bastion = setintersection(
      local.all_deployed_hosts,
      local.bastion_literal
    )
    webservers = setsubtract(
      local.all_deployed_hosts,
      local.bastion_literal
    )
  }

  ssh_host_keys = {
    all     = local.all_ssh_host_keys
    bastion = setintersection(
      local.all_ssh_host_keys,
      local.bastion_literal
    )
  }

}
