#!/bin/bash

namespace=$1
svc_name=$2

for cnt_name in $(lxc ls -cn -fcsv); do
    distribution=$(echo "$cnt_name" | sed 's/-.*//')
    if [ "$distribution" == "ubuntu" ]; then
        lxc exec $cnt_name -- sh -c "sed -i 's/>/'$namespace' '$svc_name' >/' /usr/share/ils/bin/daemon_k3s_service_check.sh && /usr/share/ils/bin/daemon_k3s_service_check.sh" &
    fi
done