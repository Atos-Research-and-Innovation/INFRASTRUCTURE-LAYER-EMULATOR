#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

# Check if the file names are provided as args
if [ "$#" -ne 2 ]; then
   echo "Usage: $0 <time_start> <inference_flag>"
   exit 1
fi

time_start=$1
inference_flag=$2
# time_start=$(echo "$time_start" | awk -F: '{printf "%02d:%02d:%02d", ($1-1+24)%24, $2, $3}') # subtract one hour.
echo "Time start: $time_start"

echo "Executing the time script in each of the containers."

start_time=$(date +%s)

for cnt_name in $(lxc ls -cn -fcsv); do

  if [ $inference_flag == "N" ]; then
    lxc exec $cnt_name -- sh -c "sed -i 's/>/\"'$time_start'\" >/' /usr/share/ils/bin/daemon_sustainability_metrics.sh /usr/share/ils/bin/daemon_time_command.sh && \ 
    /usr/share/ils/bin/daemon_time_command.sh && /usr/share/ils/bin/daemon_sustainability_metrics.sh" &
  else
    lxc exec $cnt_name -- sh -c "sed -i 's/>/\"'$time_start'\" >/' /usr/share/ils/bin/daemon_sustainability_metrics.sh /usr/share/ils/bin/daemon_time_command.sh \
    /usr/share/ils/bin/daemon_send_inference.sh && /usr/share/ils/bin/daemon_time_command.sh && /usr/share/ils/bin/daemon_sustainability_metrics.sh && \
    /usr/share/ils/bin/daemon_send_inference.sh" &
  fi
  
done

echo "Timing execution finished"

# End measuring time
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "------------------------------------------------------------"
echo "Time to create timings in containers: $elapsed_time seconds."
echo "------------------------------------------------------------"