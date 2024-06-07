# logical-only, i.e. "null", resources

#TODO: switch the creation of ssh host keys to a local shell script

resource "terraform_data" "sshfp_rdata" {
  for_each = local.ssh_host_keys.all

  provisioner "local-exec" {
    command     = "bash compute_sshfp_rdata.sh > ${each.key}_sshfp_rdata"
    working_dir = "./files"

    environment = {
      pubkey_base64 = split(" ",
        tls_private_key.ssh_host[each.key].public_key_openssh
      )[1]
    }
  }
}

data "local_file" "sshfp_rdata" {
  for_each = local.ssh_host_keys.all

  filename = "files/${each.key}_sshfp_rdata"

  depends_on = [terraform_data.sshfp_rdata]
}
