locals {
  # helper set
  bastion_literal = toset(["bastion"])

  # all keys sets
  all_deployed_hosts      = toset(keys(vultr_instance.host))
  all_ssh_host_keys       = toset(keys(tls_private_key.ssh_host))
  all_sshfp_values_set    = toset(keys(terraform_data.sshfp_value))
  all_dns_sshfp_rdata_set = toset(keys(data.local_file.dns_sshfp_rdata))
  #TODO: - change the names of the "sshp" sets when changing the resource names
  #      - check if the sets can be reduced in number based on the dependencies
  #        between the various resources (SSHFP records would not exist without
  #        corresponding hosts, for instance, which would not exist without the
  #        prerequisite SSH host keys

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
