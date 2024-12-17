#!/bin/bash

# sudo ./create_containers.sh 1 1 2 1 red service1 3600

# Args control.
if [ $# -lt 8 ]; then
    echo "Arguments less than 8"
    echo "Usage: $0 <pointX1> <pointY1> <pointX2> <pointY2> <colour> <service> <time_factor> <time_args>. Express two points and a row of containers will be created 
    from point 1 to point 2. If only a container wants to be created, express the same point again."
    exit 1
fi

SCRIPT_DIR=$(dirname "$0")

# Initialize an empty array to store argument pairs
points=()

cnt_name_suffix=$1
pointx1=$2
pointy1=$3
pointx2=$4
pointy2=$5
domain=$6
colour=$7
service=$8
disk=$9
ram=${10}
cpus=${11}
cluster=${12}
# timeseries=${10}
time_factor=${13}
inference_interval=${14}
inference_flag=${15}
time_args=${16}

if [ "$pointx1" -lt "$pointx2" ]; then

    while [ "$pointx1" -lt "$pointx2" ]; do
        points+=("$pointx1 $pointy1")
        ((pointx1++))
    done

elif [ "$pointy1" -lt "$pointy2" ]; then

    while [ "$pointy1" -lt "$pointy2" ]; do
        points+=("$pointx1 $pointy1")
        ((pointy1++))
    done

fi

# Add the last point to the list of points
points+=("$pointx2 $pointy2")

echo "Creating container/s..."

# Print the stored argument pairs
for pair in "${points[@]}"; do
    X_val="${pair%% *}"  # Get the first argument
    Y_val="${pair#* }"   # Get the second argument

    cnt_name="${cnt_name_suffix}-${X_val}-${Y_val}"
    echo "Creating container $cnt_name"

    # About profiles and cloud-inits:
    # We tried to use cloud-init but it's less efficient than creating the file with a lxc exec ...
    # https://cloudinit.readthedocs.io/en/latest/howto/predeploy_testing.html
    if [ $cnt_name_suffix == "alpine" ]; then
        lxc launch custom-alpine-3-17-cnt $cnt_name --profile k3s-profile
        distr_shell="ash"
    elif [ $cnt_name_suffix == "ubuntu" ]; then
        lxc launch custom-ubuntu-jammy-cnt $cnt_name --profile k3s-profile
        distr_shell="bash"
    fi

    # Create directories.
    lxc exec $cnt_name -- mkdir -p /usr/share/ils/conf
    lxc exec $cnt_name -- mkdir -p /usr/share/ils/bin
    # Create csv file where the configuration per container is stored.
    echo -e "Stakeholder, Vodafone\nType, Vertical\nDisk, $disk\nRAM, $ram\nEnergy_Source, wind\nvCPUs, $cpus\nBattery, 100\nColour, $colour\nService, $service\nDomain, $domain\nStatus, running"> container_info_temp.csv
    lxc file push "container_info_temp.csv" "$cnt_name/usr/share/ils/conf/container_info.csv"
    rm -f container_info_temp.csv

    # Push the file to prepull the service image
    sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/k3s_prepull_images_template.sh" > "$SCRIPT_DIR/k3s_prepull_images_temp.sh"
    lxc file push "$SCRIPT_DIR/k3s_prepull_images_temp.sh" "$cnt_name/usr/share/ils/bin/k3s_prepull_images.sh"
    rm -f $SCRIPT_DIR/k3s_prepull_images_temp.sh
    # Push the file to assign the node role as worker
    sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/k3s_set_node_role_template.sh" > "$SCRIPT_DIR/k3s_set_node_role_temp.sh"
    lxc file push "$SCRIPT_DIR/k3s_set_node_role_temp.sh" "$cnt_name/usr/share/ils/bin/k3s_set_node_role.sh"
    rm -f $SCRIPT_DIR/k3s_set_node_role_temp.sh
    # Push the file to check the service
    sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/k3s_service_check_template.sh" > "$SCRIPT_DIR/k3s_service_check_temp.sh"
    lxc file push "$SCRIPT_DIR/k3s_service_check_temp.sh" "$cnt_name/usr/share/ils/bin/k3s_service_check.sh"
    rm -f $SCRIPT_DIR/k3s_service_check_temp.sh
    # Create the daemon file to check the service
    echo -e "#!/bin/$distr_shell\nnohup /usr/share/ils/bin/k3s_service_check.sh $cnt_name > /usr/share/ils/bin/k3s_service_check.sh.nohup 2>&1 &" > $SCRIPT_DIR/daemon_k3s_service_check_temp.sh
    lxc file push "$SCRIPT_DIR/daemon_k3s_service_check_temp.sh" "$cnt_name/usr/share/ils/bin/daemon_k3s_service_check.sh"
    rm -f $SCRIPT_DIR/daemon_k3s_service_check_temp.sh
    lxc exec $cnt_name -- sh -c "chmod a+x /usr/share/ils/bin/k3s_set_node_role.sh /usr/share/ils/bin/k3s_service_check.sh /usr/share/ils/bin/daemon_k3s_service_check.sh /usr/share/ils/bin/k3s_prepull_images.sh"
    # Check if the node is elegible for hosting the migrating service:
    if [ "$cluster" == "cl" ]; then
        # Push the file to assign the node label service=iccsns
        sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/k3s_set_labels_template.sh" > "$SCRIPT_DIR/k3s_set_labels_temp.sh"
        lxc file push "$SCRIPT_DIR/k3s_set_labels_temp.sh" "$cnt_name/usr/share/ils/bin/k3s_set_labels.sh"
        rm -f $SCRIPT_DIR/k3s_set_labels_temp.sh
        lxc exec $cnt_name -- sh -c "chmod a+x /usr/share/ils/bin/k3s_set_labels.sh"
    fi
    # if [ "$timeseries" == "ts" ]; then
    #     # Push the file to create the table in the timeseries database.
    #     sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/create_timeseries_table_template.sh" > "$SCRIPT_DIR/create_timeseries_table_temp.sh"
    #     lxc file push "$SCRIPT_DIR/create_timeseries_table_temp.sh" "$cnt_name/usr/share/ils/bin/create_timeseries_table.sh"
    #     rm -f $SCRIPT_DIR/create_timeseries_table_temp.sh
    #     # Push the file to generate timeseries data based on the status of the container.
    #     sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/generate_timeseries_template.sh" > "$SCRIPT_DIR/generate_timeseries_temp.sh"
    #     lxc file push "$SCRIPT_DIR/generate_timeseries_temp.sh" "$cnt_name/usr/share/ils/bin/generate_timeseries.sh"
    #     rm -f $SCRIPT_DIR/generate_timeseries_temp.sh
    #     lxc exec $cnt_name -- sh -c "chmod a+x /usr/share/ils/bin/create_timeseries_table.sh /usr/share/ils/bin/generate_timeseries.sh"
    # fi

    # Check if the arguments regarding the fake time configuration are passed
    if [ $# -gt 12 ]; then
        # Create scripts to turn on and off the container from templates.
        sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/turn_off_template.sh" > "$SCRIPT_DIR/turn_off_temp.sh"
        lxc file push "$SCRIPT_DIR/turn_off_temp.sh" "$cnt_name/usr/share/ils/bin/turn_off.sh"
        rm -f $SCRIPT_DIR/turn_off_temp.sh
        sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/turn_on_template.sh" > "$SCRIPT_DIR/turn_on_temp.sh"
        lxc file push "$SCRIPT_DIR/turn_on_temp.sh" "$cnt_name/usr/share/ils/bin/turn_on.sh"
        rm -f $SCRIPT_DIR/turn_on_temp.sh
        # Create scripts for time system fro templates.
        sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/schedule_time_day_template.sh" > "$SCRIPT_DIR/schedule_time_day_temp.sh"
        lxc file push "$SCRIPT_DIR/schedule_time_day_temp.sh" "$cnt_name/usr/share/ils/bin/schedule_time_day.sh"
        rm -f $SCRIPT_DIR/schedule_time_day_temp.sh
        sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/schedule_time_week_template.sh" > "$SCRIPT_DIR/schedule_time_week_temp.sh"
        lxc file push "$SCRIPT_DIR/schedule_time_week_temp.sh" "$cnt_name/usr/share/ils/bin/schedule_time_week.sh"
        rm -f $SCRIPT_DIR/schedule_time_week_temp.sh
        # Create scripts for the battery algorithm of the extreme edge containers.
        sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/sustainability_metrics_template.sh" > "$SCRIPT_DIR/sustainability_metrics_temp.sh"
        lxc file push "$SCRIPT_DIR/sustainability_metrics_temp.sh" "$cnt_name/usr/share/ils/bin/sustainability_metrics.sh"
        rm -f $SCRIPT_DIR/sustainability_metrics_temp.sh
        if [ $inference_flag == "Y" ]; then
            # Create scripts for the inference algorithm of the extreme edge containers.
            sed -e "s|<distr_shell>|$distr_shell|g" "$SCRIPT_DIR/templates/send_inference_template.sh" > "$SCRIPT_DIR/send_inference_temp.sh"
            lxc file push "$SCRIPT_DIR/send_inference_temp.sh" "$cnt_name/usr/share/ils/bin/send_inference.sh"
            rm -f $SCRIPT_DIR/send_inference_temp.sh
        fi
        # Create the daemon file to check the time and change the container status
        echo -e "#!/bin/$distr_shell\nnohup /usr/share/ils/bin/schedule_time_week.sh $time_factor \"$time_args\" > /usr/share/ils/bin/schedule_time_week.sh.nohup 2>&1 &" > $SCRIPT_DIR/daemon_time_command_temp.sh
        lxc file push "$SCRIPT_DIR/daemon_time_command_temp.sh" "$cnt_name/usr/share/ils/bin/daemon_time_command.sh"
        rm -f $SCRIPT_DIR/daemon_time_command_temp.sh
        # echo -e "#!/bin/$distr_shell\nnohup /usr/share/ils/bin/generate_timeseries.sh > /usr/share/ils/bin/generate_timeseries.sh.nohup 2>&1 &" > $SCRIPT_DIR/daemon_timeseries_command_temp.sh
        # lxc file push "$SCRIPT_DIR/daemon_timeseries_command_temp.sh" "$cnt_name/usr/share/ils/bin/daemon_timeseries_command.sh"
        # rm -f $SCRIPT_DIR/daemon_timeseries_command_temp.sh
        # Create the daemon file to start the battery algorithm
        echo -e "#!/bin/$distr_shell\nnohup /usr/share/ils/bin/sustainability_metrics.sh > /usr/share/ils/bin/sustainability_metrics.sh.nohup 2>&1 &" > $SCRIPT_DIR/daemon_sustainability_metrics_temp.sh
        lxc file push "$SCRIPT_DIR/daemon_sustainability_metrics_temp.sh" "$cnt_name/usr/share/ils/bin/daemon_sustainability_metrics.sh"
        rm -f $SCRIPT_DIR/daemon_sustainability_metrics_temp.sh
        if [ $inference_flag == "Y" ]; then
            # Create daemon file to make inference after an interval time
            echo -e "#!/bin/$distr_shell\nnohup /usr/share/ils/bin/send_inference.sh $time_factor $inference_interval > /usr/share/ils/bin/send_inference.sh.nohup 2>&1 &" > $SCRIPT_DIR/daemon_send_inference_temp.sh
            lxc file push "$SCRIPT_DIR/daemon_send_inference_temp.sh" "$cnt_name/usr/share/ils/bin/daemon_send_inference.sh"
            rm -f $SCRIPT_DIR/daemon_send_inference_temp.sh
        fi
        # # Give permissions o all sh files
        lxc exec $cnt_name -- sh -c "chmod a+x /usr/share/ils/bin/turn_on.sh /usr/share/ils/bin/turn_off.sh /usr/share/ils/bin/schedule_time_day.sh /usr/share/ils/bin/sustainability_metrics.sh \
        /usr/share/ils/bin/schedule_time_week.sh /usr/share/ils/bin/daemon_time_command.sh /usr/share/ils/bin/daemon_sustainability_metrics.sh"
        if [ $inference_flag == "Y" ]; then
            lxc exec $cnt_name -- sh -c "chmod a+x /usr/share/ils/bin/daemon_send_inference.sh /usr/share/ils/bin/send_inference.sh"
        fi
    fi
    
done

echo "Done! Container/s created."