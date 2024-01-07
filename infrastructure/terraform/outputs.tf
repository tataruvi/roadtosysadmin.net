output "host_ip_address" {
  description = "Map managed hosts to their corresponding IPv4 addresses"
  value = {
    for instance, attributes in vultr_instance.host :
    instance => attributes.main_ip
  }
}
