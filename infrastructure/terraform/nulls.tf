# logical-only, i.e. "null", resources

#TODO: - switch the creation of ssh host keys to a local shell script
#      - add in a timer to delay the destruction of the hosts long enough
#        for Ansible to do its magic on their replacements; this will work
#        best when the code is run through a GitHub Actions pipeline

#TODO: consider changing resource name to "compute_sshfp_rdata"
resource "terraform_data" "sshfp_value" {
  for_each = local.ssh_host_keys.all

  provisioner "local-exec" {
    command     = "bash compute_sshfp_value.sh > ${each.key}_pubkey.sshfp"
    working_dir = "./files"

    environment = {
      pubkey_base64 = split(" ",
        tls_private_key.ssh_host[each.key].public_key_openssh
      )[1]
    }
  }
}

data "local_file" "dns_sshfp_rdata" {
  for_each = local.all_sshfp_values_set

  filename = "files/${each.key}_pubkey.sshfp"

  #TODO: need a better way to enforce dependencies between 'nulls'
  depends_on = [local.all_sshfp_values_set]
}
