output "hosts_to_ip_addr" {
  description = <<-EOT
    Map the hostnames of managed hosts to their corresponding IPv4 addresses
  EOT

  value = {
    for instance, attributes in vultr_instance.host :
    instance => attributes.main_ip
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
      host_ip_addr = {
        for instance, attributes in vultr_instance.host :
        lower(regex("\\w+", attributes.os)) => attributes.main_ip
      }
    }
  )
}
