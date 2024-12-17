#!/bin/bash

# sudo ./create_custom_ubuntu.sh

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

original_image_name="ubuntu-jammy-cnt"
cnt_name="ubuntu-jammy-tmp"
snapshot_name="ubuntu-cnt-snp"
custom_image="custom-ubuntu-jammy-cnt"

lxc image copy ubuntu:22.04 local: --alias $original_image_name
lxc launch $original_image_name $cnt_name -c security.privileged=true

# Update apt package manager.
echo "Update apt package manager..."
apt update -y
echo "Update done."

# Change timezone to Europe/Madrid:
echo "Change timezone to Europe/Madrid to have the same Timezone than the host."
lxc exec $cnt_name -- echo "Europe/Madrid" > /etc/timezone
lxc exec $cnt_name -- ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime

# Install desired packages and modifications...
# Execute the following commands inside the container to ensure connectivity
# lxc exec $cnt_name -- apt-get install openssh-server -y
# Change the ssh configuration for allowing public key authentication
# lxc exec $cnt_name -- sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
# lxc file push ../ssh-keypair/id_rsa.pub $cnt_name/root/.ssh/authorized_keys
echo "Installing required packages to interact with TimescaleDB."
lxc exec $cnt_name -- apt install postgresql-client-common -y
lxc exec $cnt_name -- apt install postgresql-client-14 -y
echo "Installing required packages to interact with TimescaleDB."

lxc snapshot $cnt_name $snapshot_name
lxc publish $cnt_name/$snapshot_name --alias $custom_image
lxc image delete $original_image_name
lxc stop $cnt_name
lxc delete $cnt_name
# Push to nexus repo:
# curl -v -u <username>:<password> --upload-file $image_name-modified.tar.gz "https://registry.atosresearch.eu:18495/$image_name-modified.tar.gz"
