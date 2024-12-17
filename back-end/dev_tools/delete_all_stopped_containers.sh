#!/bin/bash

#
# Stop all running containers
#

# stop running containers
for container in $(lxc list volatile.last_state.power=STOPPED -c n --format csv); do    
	    lxc delete "$container"
done

rm -f temporal_files/*