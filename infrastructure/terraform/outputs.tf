output "bastion_ip_address" {
  description = "IPv4 address for the 'bastion' host"
  value       = vultr_instance.bastion_host.main_ip
}

output "webserver01_ip_address" {
  description = "IPv4 address for the 'webserver01' host"
  value       = vultr_instance.webserver01.main_ip
}

output "webserver02_ip_address" {
  description = "IPv4 address for the 'webserver02' host"
  value       = vultr_instance.webserver02.main_ip
}
