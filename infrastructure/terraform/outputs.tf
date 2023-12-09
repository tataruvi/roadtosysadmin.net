output "bastion_ip_address" {
  value = vultr_instance.bastion_host.main_ip
}

output "bastion_hostname" {
  value = vultr_instance.bastion_host.hostname
}

output "webserver01_ip_address" {
  value = vultr_instance.webserver01.main_ip
}

output "webserver01_hostname" {
  value = vultr_instance.webserver01.hostname
}

output "webserver02_ip_address" {
  value = vultr_instance.webserver02.main_ip
}

output "webserver02_hostname" {
  value = vultr_instance.webserver02.hostname
}
