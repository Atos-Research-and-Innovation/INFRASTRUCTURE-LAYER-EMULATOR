#!/bin/<distr_shell>

# sudo ./service_check.sh node namespace svc_name

node=$1
namespace=$2
svc_name=$3

# Perform a dummy execution of k3s kubectl get nodes to check if k3s is available
if ! k3s kubectl get nodes &> /dev/null; then
    echo "Error: k3s command not found or unable to connect. Exiting."
    exit 1
fi

echo "k3s exists, executing the command..."

# Lock file
# lockfile="/var/lock/container_info.lock"

while true; do

    # Acquire lock
    # exec 200>$lockfile
    # flock -n 200 || { echo "Failed to acquire lock."; exit 1; }

    # Access the config file to get the status.
    curr_status=$(cat "/usr/share/ils/conf/container_info.csv" | grep "^Status," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')

    if [ "$curr_status" == "standby" ]; then
        # Remove service
        # awk -v key="Service" -v svc_name="nose" -F", " '{if ($1 == key) $2 = svc_name; print $1 ", " $2}' /usr/share/ils/conf/container_info.csv > tmp_srv_file && mv tmp_srv_file /usr/share/ils/conf/container_info.csv
        sed -i 's/^Service, [^,]*/Service, nose/' /usr/share/ils/conf/container_info.csv
        # Remove the k3s worker node from the cluster in case the status changed from running to standby
        if [ "$curr_status" == "$prev_status" ]; then
            : # Do nothing
        else

            systemctl stop k3s-agent
            k3s kubectl delete node $(hostname) # As the hostname is the same as the k3s node
            pod_del=$(k3s kubectl get pods -n $namespace -o wide | grep $(hostname) | awk -F " " '{print $1}')
            k3s kubectl delete pod $pod_del -n $namespace --force

        fi
    else
        # Add the k3s worker node from the cluster in case the status changed from standby to running
        if [ "$curr_status" == "$prev_status" ]; then
            : # Do nothing
        else
            systemctl start k3s-agent
        fi
        # Assuming that the service is deployed on the same namespace
        read ns_name_out ns_status_out ns_deletion_timestamp < <(k3s kubectl get pods -n $namespace --field-selector spec.nodeName=$node -o custom-columns="POD_NAME:.metadata.name, STATUS:.status.phase, DELETION_TIMESTAMP:.metadata.deletionTimestamp" --no-headers)

        if [ ! -z "$ns_name_out" ] && [ "$ns_status_out" == "Running" ] && [ "$ns_deletion_timestamp" == "<none>" ]; then
            # awk -v key="Service" -v svc_name="nose" -F", " '{if ($1 == key) $2 = svc_name; print $1 ", " $2}' /usr/share/ils/conf/container_info.csv > tmp_srv_file && mv tmp_srv_file /usr/share/ils/conf/container_info.csv
            sed -i "s/^Service, [^,]*/Service, $svc_name/" /usr/share/ils/conf/container_info.csv
        else
            # awk -v key="Service" -v svc_name="$svc_name" -F", " '{if ($1 == key) $2 = svc_name; print $1 ", " $2}' /usr/share/ils/conf/container_info.csv > tmp_srv_file && mv tmp_srv_file /usr/share/ils/conf/container_info.csv
            sed -i 's/^Service, [^,]*/Service, nose/' /usr/share/ils/conf/container_info.csv
        fi
    fi

    prev_status=$curr_status

    # Release lock
    # flock -u 200

    sleep 2

done