#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

# Check if the file names are provided as args
if [ "$#" -ne 1 ]; then
   echo "Usage: $0 <time_start "YYYY-MM-DD HH24:MM:SS">"
   exit 1
fi

# Get args
datehour=$1

# Declare directories variables
HOME_UBUNTU=/home/ubuntu
BACK_END=$(pwd)/back-end
K3S=$BACK_END/k3s

# check_k3s_master() {
#   output=$(kubectl --kubeconfig=$HOME_UBUNTU/.kube/config get --raw='/livez')
#   return $output
# }

# First execute the emulation creation:
$BACK_END/1_create_emulation_video_streaming.sh
master_node_name="ubuntu-10-11"

# Create master
$K3S/1_create_masters.sh $master_node_name
master_node_ip=$(lxc list $master_node_name -f csv -c 4 | awk -F " " '{print $1}')
echo "The master node IP is: $master_node_ip"

# Access k3s API
lxc exec $master_node_name -- sh -c "k3s kubectl config view --flatten" > $HOME_UBUNTU/.kube/ILE/LXD_k3s_${master_node_name}_config.yaml
sed -i "s/127.0.0.1/${master_node_ip}/g" $HOME_UBUNTU/.kube/ILE/LXD_k3s_${master_node_name}_config.yaml
cp $HOME_UBUNTU/.kube/ILE/LXD_k3s_${master_node_name}_config.yaml $HOME_UBUNTU/.kube/config

# echo "Waiting for the master node to be available..."
# while ! output=$(check_k3s_master); do
#   echo "$output"
#   sleep 2
# done
# echo "Master node $master_node_name is up and accessible through k3s API!"

# Attach workers
$K3S/2_create_agent_nodes.sh $master_node_name $master_node_ip ubuntu-6-9 ubuntu-6-11 ubuntu-8-7 ubuntu-8-15 \
ubuntu-11-8 ubuntu-11-10 ubuntu-11-11 ubuntu-11-14 ubuntu-12-5 ubuntu-13-15 ubuntu-14-8 ubuntu-15-10

# Deploy service
kubectl apply --kubeconfig=$HOME_UBUNTU/.kube/config -f $K3S/services/nginx/nginx_video.yaml
lxc config device add ubuntu-10-11 myproxy30788 proxy listen=tcp:0.0.0.0:30788 connect=tcp:127.0.0.1:30788 bind=host

# Start service cheking
$K3S/3_start_service_check.sh nginx nginx

# Execute nodejs
# nodejs $BACK_END/nodejs-server/file-server-express.js &

# Start fake time
hour=$(echo $datehour | awk -F " " '{print $2}')
$BACK_END/2_execute_emulation.sh $hour

# Start GUI
# java $(pwd)/front-end/java_gui.java &

# Start checking
$BACK_END/3_get_containers_status.sh $BACK_END/nodejs-server/config_matrix.txt $BACK_END/nodejs-server/matrix_size.txt $BACK_END/nodejs-server/time_diff.txt "$datehour" 60