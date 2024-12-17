#!/bin/<distr_shell>

# sudo ./sustainability_metrics.sh time_start

time_start=$1

# Convert the time when the emulation must start to seconds.
time_start_ttmp=$(date -d "$time_start" +"%s")
# Convert the current time to seconds.
curr_date_ttmp=$(date +"%s")

# Calculate the difference between both.
time_diff=$((time_start_ttmp - curr_date_ttmp))

# Wait until the the current time is equal to the emulation start time.
sleep $time_diff

# Initial mode (charging or discharging)
mode="discharging"
# prev_mode=$mode

# Battery level change per interval
CHANGE_RATE=1

generate_random_number() {
    echo $((RANDOM % 101))
}

# Function to determine if the state should change
should_change_state() {
    # Generate a random number
    random_number=$(generate_random_number)

    # Calculate the probabilities based on the current battery level
    # The variable "prob" indicates the probabiliy to switch the state
    # The higher the number, the higher the probability. Possible values: [0,100]
    if [ $current_level -ge 0 ] && [ $current_level -le 10 ]; then
        if [ $mode = "charging" ]; then
            prob=5
        else
            prob=95
        fi
    elif [ $current_level -ge 10 ] && [ $current_level -le 20 ]; then
        if [ $mode = "charging" ]; then
            prob=5
        else
            prob=90
        fi
    elif [ $current_level -ge 20 ] && [ $current_level -le 30 ]; then
        if [ $mode = "charging" ]; then
            prob=10
        else
            prob=30
        fi
    elif [ $current_level -ge 30 ] && [ $current_level -le 40 ]; then
        if [ $mode = "charging" ]; then
            prob=10
        else
            prob=25
        fi
    elif [ $current_level -ge 40 ] && [ $current_level -le 50 ]; then
        if [ $mode = "charging" ]; then
            prob=15
        else
            prob=20
        fi
    elif [ $current_level -ge 50 ] && [ $current_level -le 60 ]; then
        if [ $mode = "charging" ]; then
            prob=25
        else
            prob=20
        fi
    elif [ $current_level -ge 60 ] && [ $current_level -le 70 ]; then
        if [ $mode = "charging" ]; then
            prob=30
        else
            prob=10
        fi
    elif [ $current_level -ge 70 ] && [ $current_level -le 80 ]; then
        if [ $mode = "charging" ]; then
            prob=50
        else
            prob=10
        fi
    elif [ $current_level -ge 80 ] && [ $current_level -le 90 ]; then
        if [ $mode = "charging" ]; then
            prob=75
        else
            prob=5
        fi
    elif [ $current_level -ge 90 ] && [ $current_level -le 100 ]; then
        if [ $mode = "charging" ]; then
            prob=95
        else
            prob=5
        fi
    fi

    [ "$random_number" -lt "$prob" ]
}

# Function to update the battery status in the CSV file
while true; do

    # Access the config file to get the battery level.
    current_level=$(cat "/usr/share/ils/conf/container_info.csv" | grep "^Battery," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')
    # Get also the status to avoid decreasing the battery level in case the device is off.
    current_status=$(cat "/usr/share/ils/conf/container_info.csv" | grep "^Status," | cut -d ',' -f 2 | sed 's/^[[:space:]]*//')

    # Decide if in charging or discharging state.

    # Calculate the new battery level
    if [ "$mode" = "discharging" ] && [ $current_status = "running" ]; then
        if [ $current_level -gt 0 ]; then
            new_level=$((current_level - CHANGE_RATE))
            sed -i "s/^Battery, [^,]*/Battery, $new_level/" /usr/share/ils/conf/container_info.csv
            # Switch to charging using probability algorithm which depends on battery level
            if should_change_state; then
                mode="charging"
            fi
        fi
    elif [ "$mode" = "charging" ]; then
        if [ $current_level -lt 100 ]; then
            new_level=$((current_level + CHANGE_RATE))
            sed -i "s/^Battery, [^,]*/Battery, $new_level/" /usr/share/ils/conf/container_info.csv
            # Switch to discharging using probability algorithm which depends on battery level
            if should_change_state; then
                mode="discharging"
            fi
        fi
    elif [ "$mode" = "discharging" ]; then
        if should_change_state; then
            mode="charging"
        fi
    fi

    sleep 5

done