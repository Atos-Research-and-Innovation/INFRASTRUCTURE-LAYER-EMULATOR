#!/bin/<distr_shell>

# Get kubernetes node name based on the container's hostname
node_name=$(hostname)
# Get the domain name based on the configuration file
domain=$(cat "/usr/share/ils/conf/container_info.csv" | grep "^Domain," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')

# Check if the node is ready
while ! k3s kubectl get nodes "$node_name" &> /dev/null; do
    sleep 1
done

# Apply label to the node
k3s kubectl label node "$node_name" node-role.kubernetes.io/worker=worker domain=$domain