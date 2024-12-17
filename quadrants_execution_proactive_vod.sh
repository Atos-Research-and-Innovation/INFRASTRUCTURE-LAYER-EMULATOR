#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

# Check if the file names are provided as args
# if [ "$#" -ne 1 ]; then
#    echo "Usage: $0 <time_start "YYYY-MM-DD HH24:MM:SS">"
#    exit 1
# fi

# Get args
# datehour=$1

# Declare directories variables
HOME_UBUNTU=/home/ubuntu
BACK_END=$(pwd)/back-end
K3S=$BACK_END/k3s

# check_k3s_master() {
#   output=$(kubectl --kubeconfig=$HOME_UBUNTU/.kube/config get --raw='/livez')
#   return $output
# }

# Set starting time
start_execution_time=$(date +%s%N)

# First execute the emulation creation:
$BACK_END/1_create_emulation_quadrants_proactive.sh
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

last_worker_container="ubuntu-15-10"

# Attach workers
$K3S/2_create_agent_nodes.sh $master_node_name $master_node_ip ubuntu-6-9 ubuntu-6-11 ubuntu-7-4 ubuntu-8-7 \
ubuntu-8-15 ubuntu-8-21 ubuntu-11-8 ubuntu-11-14 ubuntu-12-5 ubuntu-13-15 ubuntu-14-8 $last_worker_container

# Declare variable with the process name that must be finished befre proceeding.
process_name="crictl"

# Check if the image prepulling process has finished for the last container the worker node has been attached.
# Loop until the process is not found in the container
echo "Finishing K3s workers deployment..."
# Look for all processes with "ps aux", filter out the ones that contain the string of the variable
# $process_name, and finally, exclude the ones that contain the word "grep" to avoid
# getting the process of the grep itself
while lxc exec "$last_worker_container" -- ps aux | grep $process_name | grep -v grep > /dev/null; do
  # echo "Waiting for $process_name to finish in container $last_worker_container..."
  sleep 2  # Wait 2 seconds before checking again
done
echo "K3s workers attachment finished!"

# Deploy service
kubectl apply --kubeconfig=$HOME_UBUNTU/.kube/config -f $K3S/services/vod_service/vod_server.yaml
lxc config device add ubuntu-10-11 myproxy31664 proxy listen=tcp:0.0.0.0:31664 connect=tcp:127.0.0.1:31664 bind=host

# Set ending time
end_execution_time=$(date +%s%N)
elapsed_execution_time=$(( (end_execution_time - start_execution_time) / 1000000000 ))
echo "------------------------------------------------------------"
echo "Time to finish k3s deployment: $elapsed_execution_time seconds"
echo "------------------------------------------------------------"

# Start service cheking
# $K3S/3_start_service_check.sh ilens ilens

# Execute nodejs
# nodejs $BACK_END/nodejs-server/file-server-express.js &

# Start fake time
# hour=$(echo $datehour | awk -F " " '{print $2}')
# $BACK_END/2_execute_emulation.sh $hour "Y"

# Start GUI
# java $(pwd)/front-end/java_gui.java &

# Start checking
# $BACK_END/3_get_containers_status.sh $BACK_END/nodejs-server/config_matrix.txt $BACK_END/nodejs-server/matrix_size.txt $BACK_END/nodejs-server/time_diff.txt "$datehour" 360