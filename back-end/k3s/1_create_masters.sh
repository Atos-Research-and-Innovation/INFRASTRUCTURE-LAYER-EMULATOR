#!/bin/bash

# Args control.
if [ $# -lt 1 ]; then
    echo "Arguments lower than 1"
    echo "Usage: $0 <container1> <container2> ... <containerN>"
    exit 1
fi

SCRIPT_DIR=$(dirname "$0")

# Download k3s from official GitHub repository
echo "Downloading k3s file from official GitHub repository..."
wget https://github.com/rancher/k3s/releases/download/v1.28.3+k3s2/k3s -P $SCRIPT_DIR &> /dev/null
echo "k3s file downloaded."
chmod +x $SCRIPT_DIR/k3s
echo "Permissions changed to executable for file k3s"

for cnt_name in "$@"; do

    echo "Creating the master node for container $cnt_name..."
    # Push the file inside the container in order to execute k3s
    lxc file push $SCRIPT_DIR/k3s $cnt_name/usr/local/bin/k3s
    # Push also the file to crete the service in order to execute the k3s server in the background
    lxc file push $SCRIPT_DIR/templates/k3s-server.service-template $cnt_name/etc/systemd/system/k3s-server.service
    # Push config.toml.tmpl to define the config.toml config for containerd to make k3s work. Refer to https://docs.k3s.io/advanced for more info
    lxc exec $cnt_name -- mkdir -p /var/lib/rancher/k3s/agent/etc/containerd
    lxc file push $SCRIPT_DIR/templates/config.toml.tmpl $cnt_name/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl
    # Push registries.yaml to point to mirrored docker hub registry instead of official docker.io
    # lxc exec $cnt_name -- mkdir -p /etc/rancher/k3s
    # lxc file push $SCRIPT_DIR/templates/registries-template.yaml $cnt_name/etc/rancher/k3s/registries.yaml
    # Execute commands inside the container
    lxc exec $cnt_name -- sudo ln -s /dev/console /dev/kmsg
    # Redirect stdout and stderr to /dev/null to avoid get the error when the mount point does not exist
    lxc exec $cnt_name -- mount -t cgroup -o cpu none /sys/fs/cgroup/cpu,cpuacct &>/dev/null
    lxc exec $cnt_name -- mount -t cgroup -o cpuacct none /sys/fs/cgroup/cpu,cpuacct &>/dev/null
    lxc exec $cnt_name -- systemctl start k3s-server
    echo "Master node created for container $cnt_name."

done

# Delete k3s file in the host
rm -f $SCRIPT_DIR/k3s
echo "k3s file deleted."
