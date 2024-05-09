- ~~Reverse the HTTPS-to-HTTP firewall redirect, it does not work with browsers~~
- ~~Move Ansible user creation over to cloud-init (before host configuration)~~
- Consider replacing the RTSA SSH key with an Ed25519 one (currently RSA 4096)
- ~~Check if doas/sudo configuration can be performed via cloud-init too; if it
can, authorize the SSH key for the user and use it for Ansible connections~~
- ~~Create host certs (Ed25519) via helper script and load them via cloud-init;
remove all other certs found on the hosts and update sshd\_config accordingly~~
- ~~Configure Nginx and listen for HTTP traffic only for now; close port 443~~
- ~~Copy the website files into the repo, then deploy them via Ansible~~
- Consider changing the location of the webservers and checking DNS LB methods
- ~~Switch the DNS provider over from Hover to Vultr and enable DNSSEC~~
- ~~Create SSHFP records based on the generated host certs~~
- Consider the issue of DNS failover (TTL bound) when replacing webservers via
Terraform
- Fix the current .gitignore mess
- Add the source\_env.sh script to source control
- Consider describing the infrastructure in a YAML that would then be used as
a source of truth by both Terraform and Ansible
- ~~Clean up the excessive for\_each duplication of iterators and employ local
variables for the job~~
- Move the implementation of the controlled host SSH keys outside of Terraform; correct the use of SSHFP as a result
