#!/bin/<distr_shell>

# Get kubernetes node name based on the container's hostname
node_name=$(hostname)

# Check if the node is ready
while ! k3s kubectl get nodes "$node_name" &> /dev/null; do
    sleep 1
done

# Apply label to the node
k3s kubectl label node "$node_name" service=ilens