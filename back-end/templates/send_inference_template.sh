#!/bin/<distr_shell>

# ./send_inference_template.sh 60 40 "10:24:00"

# Verify total arguments number.
if [ $# -ne 3 ]; then
    echo "Usage: $0 [time conversion factor (1, 60, 3600)], [inference interval in seconds (40)], [emulation time start ("10:24:00")]"
    exit 1
fi

conversion_factor=$1
interval=$2
time_start=$3

# Convert the time when the emulation must start to seconds.
time_start_ttmp=$(date -d "$time_start" +"%s")
# Convert the current time to seconds.
curr_date_ttmp=$(date +"%s")

# Calculate the difference between both.
time_diff=$((time_start_ttmp - curr_date_ttmp))

# Wait until the the current time is equal to the emulation start time.
sleep $time_diff
# Wait 3 more seconds to ensure all containers have changed their status
sleep 3

server_url="http://10.13.1.107:5000/report-state"
timestamp=$(date -d "2024-01-01T00:00:00" +"%s")
echo "Timestamp just after creation: $timestamp"

while true; do

    # Get the on/off status from the configuration file of the container
    curr_status=$(cat "/usr/share/ils/conf/container_info.csv" | grep "^Status," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')
    if [ "$curr_status" == "standby" ]; then
        status="0"
    else
        status="1"
    fi
    # Convert timestamp to iso 8601 format
    timestamp_iso=$(date -d "@$timestamp" +"%Y-%m-%dT%H:%M:%S")
    echo "Timestamp before sending to central server: $timestamp_iso"
    # Create a JSON payload
    payload=$(cat <<EOF
{
"container_name": "$(hostname)",
"state": "$status",
"timestamp": "$timestamp_iso"
}
EOF
    )
    # Send the container name, on/off status & timestamp to central server
    curl -X POST -H "Content-Type: application/json" -d "$payload" "$server_url"
    # Calculate the interval for the timestamp used for inference
    # depending on the conversion time factor variable
    inference_interval=$((interval * conversion_factor))
    # Sum the timestamp plus the interval time
    timestamp=$((timestamp + inference_interval))
    # Wait the interval time before sending the next value
    sleep $interval

done