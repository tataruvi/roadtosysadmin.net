output "hosts_public_ipaddr" {
  description = <<-EOT
    Map the hostnames of managed hosts to their corresponding public -routable-
    IPv4 addresses, if they have been deployed; resulting map can be empty
  EOT

  value = {
    for host, attr in vultr_instance.host : host => attr.main_ip
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
      domain_name   = "roadtosysadmin.net"
      ansible_hosts = {
        for instance, args in var.instance_args :
        instance => {
          os_shortname : local.os_shortname[instance]
          ipaddr : (
            contains(var.deployable_instances, instance) ?
            vultr_instance.host[instance].main_ip :
            var.CONST.null_ipaddr
          )
        }
      }
    }
  )
}

output "website_dns_records" {
  description = "Published DNS records through which the website is served"

  value = {
    for dns_record in vultr_dns_record.www_next :
    "${dns_record.name}.${dns_record.domain}" => dns_record.data...
  }
}
