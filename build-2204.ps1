
# variable files ending with .auto.pkrvars.hcl are automatically loaded

# Uncomment this two lines to enable log export
$env:PACKER_LOG=1
$env:PACKER_LOG_PATH="packerlog.txt"

packer build -var='vsphere_guest_os_type=ubuntu64Guest' `
  -var='vsphere_vm_name=tpl-ubuntu-2204' .
