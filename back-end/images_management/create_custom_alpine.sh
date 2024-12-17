#!/bin/bash

# sudo create_custom_alpine.sh

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

original_image_name="alpine-3-17-cnt"
cnt_name="alpine-3-17-tmp"
snapshot_name="alpine-cnt-snp"
custom_image="custom-alpine-3-17-cnt"

lxc image copy images:alpine/3.17/cloud local: --alias $original_image_name
lxc launch $original_image_name $cnt_name -c security.privileged=true

# Change timezone to Europe/Madrid:
lxc exec $cnt_name -- ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime

# Install desired packages and modifications...
# Execute the following commands inside the container to ensure connectivity
lxc exec $cnt_name -- apk update
lxc exec $cnt_name -- apk add coreutils
lxc exec $cnt_name -- apk add curl
lxc exec $cnt_name -- apk add openssh
lxc exec $cnt_name -- rc-update add sshd
# Change sshd config file to allow password authentication
# lxc exec $cnt_name -- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
lxc exec $cnt_name -- service sshd start
# Set password "alpine" for user "alpine"
lxc exec $cnt_name -- sh -c "echo "alpine:alpine" | chpasswd"
# lxc file push ../ssh-keypair/id_rsa.pub $cnt_name/root/.ssh/authorized_keys

lxc snapshot $cnt_name $snapshot_name
lxc publish $cnt_name/$snapshot_name --alias $custom_image
lxc image delete $original_image_name
lxc stop $cnt_name
lxc delete $cnt_name
# Push to nexus repo:
# curl -v -u <username>:<password> --upload-file $image_name-modified.tar.gz "https://registry.atosresearch.eu:18495/$image_name-modified.tar.gz"
