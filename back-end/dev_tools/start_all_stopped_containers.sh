#!/bin/bash

#
# Stop all running containers
#

# Start measuring time
start_time=$(date +%s)

# Function to start a container.
start_container() {
	local container="$1"
	lxc start "$container"
}

# Get the names of running containers and store them in an array
stopped_containers=($(lxc list volatile.last_state.power=STOPPED -c n --format csv))

# Iterate over the array to stop the containers in parallel.
for container in "${stopped_containers[@]}"; do
    start_container "$container" &
done

# Wait till all processes finish.
wait
# ---------------------------------------
# Total time for 20 containers: 7 seconds
# ---------------------------------------

# End measuring time
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "-----------------------------------------------"
echo "Time to start containers: $elapsed_time seconds."
echo "-----------------------------------------------"