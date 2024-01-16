output "hosts_to_ip_addr" {
  description = <<-EOT
    Map the hostnames of managed hosts to their corresponding routable IPv4
    addresses, should the hosts exist
  EOT

  value = {
    for instance, attributes in vultr_instance.host :
    instance => attributes.main_ip
    if contains(var.deployable_instances, instance)
  }
}

output "ansible_hosts" {
  description = <<-EOT
    Render a basic Ansible hosts template which can then be used as a form of
    dynamic inventory by the playbooks
  EOT

  value = templatefile(
    "templates/ansible_hosts.yaml.tftpl",
    {
      ansible_hosts_ipaddr = local.ansible_hosts_ipaddr
    }
  )
}
