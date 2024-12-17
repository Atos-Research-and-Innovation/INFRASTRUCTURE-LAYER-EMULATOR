#!/bin/bash

# Args control.
if [ $# -lt 1 ]; then
    echo "Arguments equal to 1"
    echo "Usage: $0 <master-node> <master-IP> <worker-node-1> <worker-node-2> ... <worker-node-N>"
    exit 1
fi

SCRIPT_DIR=$(dirname "$0")

master_name=$1
shift
# Get IP from the master node
master_ip=$1
# Get token from the master node
master_token=$(lxc exec $master_name -- sh -c "cat /var/lib/rancher/k3s/server/node-token")
shift

# Download k3s from official GitHub repository
echo "Downloading k3s file from official GitHub repository..."
wget https://github.com/rancher/k3s/releases/download/v1.28.3+k3s2/k3s -P $SCRIPT_DIR &> /dev/null
echo "k3s file downloaded."
chmod +x $SCRIPT_DIR/k3s
echo "Permissions changed to executable for file k3s"

# Get config file from the master and substitute the IP.
lxc exec $master_name -- sh -c "k3s kubectl config view --flatten" > $SCRIPT_DIR/k3s.yaml
sed -i "s/127.0.0.1/${master_ip}/g" $SCRIPT_DIR/k3s.yaml

for cnt_name in "$@"; do

    echo "Attaching worker $cnt_name to master $master_name node..."
    # Push the file inside the container in order to execute k3s
    lxc file push $SCRIPT_DIR/k3s $cnt_name/usr/local/bin/k3s
    # Configure the template k3s-server.agent-template to add correct values
    sed -e "s|<master-node>|$master_ip|g" -e "s|<master-token>|$master_token|g" "$SCRIPT_DIR/templates/k3s-agent.service-template" > "$SCRIPT_DIR/k3s-agent.service"
    # Push also the file to crete the service in order to execute the k3s server in the background
    lxc file push $SCRIPT_DIR/k3s-agent.service $cnt_name/etc/systemd/system/k3s-agent.service
    # Delete file k3s-agent.service
    rm -f $SCRIPT_DIR/k3s-agent.service
    # Push the config.toml.tmpl to define the config.toml config for containerd to make k3s work. Refer to https://docs.k3s.io/advanced for more info
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
    # Copy the kubeconfig in worker nodes in order to be able to access from inside them
    lxc exec $cnt_name -- sh -c "mkdir -p /etc/rancher/k3s"
    lxc file push $SCRIPT_DIR/k3s.yaml $cnt_name/etc/rancher/k3s/k3s.yaml
    # Start k3s agent service
    lxc exec $cnt_name -- systemctl start k3s-agent
    echo "Worker $cnt_name attached to master $master_name node."

done

# Delete k3s and k3s.yaml files in the host
rm -f $SCRIPT_DIR/k3s.yaml
rm -f $SCRIPT_DIR/k3s
echo "k3s file deleted."