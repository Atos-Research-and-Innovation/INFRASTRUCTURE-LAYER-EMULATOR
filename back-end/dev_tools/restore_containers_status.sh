#!/bin/bash

# sudo restore_containers_status.sh "13:50:00" nginx nginx

time_start=$1
namespace=$2
svc_name=$3

for cnt_name in $(lxc ls -cn -fcsv); do
    srv_pid=$(lxc exec $cnt_name -- sh -c "ps aux | grep '/bin/bash /usr/share/ils/bin/k3s_service_check.sh' | head -1 | awk 'NR==1 {printf \"%s\", \$2}'")
    lxc exec $cnt_name -- sh -c "kill -9 $srv_pid"
    week_time_pid=$(lxc exec $cnt_name -- sh -c "ps aux | grep '/bin/bash /usr/share/ils/bin/schedule_time_week.sh' | head -1 | awk 'NR==1 {printf \"%s\", \$2}'")
    lxc exec $cnt_name -- sh -c "kill -9 $week_time_pid"
    day_time_pid=$(lxc exec $cnt_name -- sh -c "ps aux | grep '/bin/bash /usr/share/ils/bin/schedule_time_day.sh' | head -1 | awk 'NR==1 {printf \"%s\", \$2}'")
    lxc exec $cnt_name -- sh -c "kill -9 $day_time_pid"
done

for cnt_name in $(lxc ls -cn -fcsv); do
    lxc exec $cnt_name -- sh -c "sed -i 's/ \"'$time_start'\"//' /usr/share/ils/bin/daemon_time_command.sh"
    lxc exec $cnt_name -- sh -c "sed -i 's/ $namespace $svc_name//' /usr/share/ils/bin/daemon_k3s_service_check.sh"
    sudo lxc exec $cnt_name -- sh -c "awk -v key=\"Service\" -v svc_name=\"nose\" -F\", \" '{if (\$1 == key) \$2 = svc_name; print \$1 \", \" \$2}' /usr/share/ils/conf/container_info.csv > tmp_srv_file && mv tmp_srv_file /usr/share/ils/conf/container_info.csv"
    sudo lxc exec $cnt_name -- sh -c "awk -v key=\"Status\" -v status=\"running\" -F\", \" '{if (\$1 == key) \$2 = status; print \$1 \", \" \$2}' /usr/share/ils/conf/container_info.csv > tmp_srv_file && mv tmp_srv_file /usr/share/ils/conf/container_info.csv"
    sudo lxc exec $cnt_name -- sh -c "systemctl start k3s-agent"
done