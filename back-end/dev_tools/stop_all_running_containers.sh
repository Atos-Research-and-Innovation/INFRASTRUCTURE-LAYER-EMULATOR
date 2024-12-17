#!/bin/bash

#
# Stop all running containers
#

# Start measuring time
start_time=$(date +%s)

# -----------------------------------
# stop running containers PARALLELLY.
# -----------------------------------
# Function to stop a container.
stop_container() {
	local container="$1"
	lxc stop "$container" --force
}

# Get the names of running containers and store them in an array
running_containers=($(lxc list volatile.last_state.power=RUNNING -c n --format csv))

# Iterate over the array to stop the containers in parallel.
for container in "${running_containers[@]}"; do
    stop_container "$container" &
done

# Wait till all processes finish.
wait

# End measuring time
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "-----------------------------------------------"
echo "Time to stop containers: $elapsed_time seconds."
echo "-----------------------------------------------"